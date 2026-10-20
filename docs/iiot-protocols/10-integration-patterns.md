# 10 — Integration Patterns

## The canonical IIoT data path

Almost every successful plant-to-cloud architecture is some version of this:

```
Field devices          Control            Edge (DMZ)              Platform
-----------------      ---------------    ------------------      ----------------
sensors, drives  --->  PLC / DCS   --->   gateway          --->   broker / cloud
HART, IO-Link          OPC UA server      - protocol xlate        historian
Modbus, PROFIBUS       Modbus TCP         - normalise             analytics
                                          - buffer                dashboards
                                          - publish outbound      MES / ERP
```

The important properties are structural, not technological:

1. **Read from the controller, not the field bus**, wherever possible. The PLC already
   polls the devices correctly, with the right scaling and the right engineering. A
   second master on the fieldbus adds load and risk.
2. **Normalise at the edge.** The gateway is where register 40107 becomes
   `Line3/Filler/Motor1/PowerFactor` with a unit and a timestamp. Do it once, close to
   the source, not in every consumer.
3. **Buffer at the edge.** The uplink will fail. Decide what happens to data during
   the outage before it happens.
4. **Publish outbound only.** The gateway initiates connections to the platform;
   nothing from outside initiates a connection into the plant. This is the single most
   valuable security property of the whole design.

## Protocol conversion: what you lose at each hop

Every translation discards something. Know what, so you can decide whether it matters.

| Conversion | What is lost |
|---|---|
| OPC UA to MQTT (raw JSON) | StatusCode quality, source timestamp, data types, the type hierarchy |
| OPC UA to Sparkplug B | The object model and references; metric names flatten to strings |
| Modbus to anything | Nothing is lost because nothing was there — but nothing is gained either; you must add units, scaling and names from a manual |
| PROFINET/EtherNet/IP to OPC UA | Cyclic timing context; you get values, not the deterministic guarantee |
| HART to Modbus | Device diagnostics, multiple variables, device identity |
| Anything to a flat tag list | Hierarchy, relationships, and the ability to discover |

The two losses that cause most downstream trouble:

- **Quality and status.** If the sensor is faulty and OPC UA says
  `Bad_SensorFailure`, a gateway that forwards only the number turns a known failure
  into a believable reading. Analytics then trains on garbage. **Always carry quality
  through**, even if it means a slightly richer payload.
- **Source timestamps.** If the gateway stamps messages with its own clock on
  publication, you lose the ability to order events correctly and to tell a delayed
  batch from a current one. After an outage, a thousand buffered readings all arrive
  with the same gateway timestamp and the history is meaningless. **Preserve the
  original timestamp** and add the gateway time separately if you need it.

## Edge buffering and store-and-forward

Design this explicitly rather than discovering the default behaviour during your first
outage.

Decisions to make:

- **How long must you survive disconnected?** A cellular site might need 24-72 hours.
  Multiply by the message rate and payload size to size the store.
- **What is the storage medium?** RAM is fast but lost on power failure — which often
  accompanies network failure. SD cards wear out under continuous write; specify
  industrial-grade with wear levelling, or use a circular buffer sized well below
  capacity.
- **What happens when the buffer is full?** Drop oldest (keep recent trend), drop
  newest (keep the start of the event), or downsample older data progressively. All
  three are defensible; silence is not.
- **How fast do you drain?** Dumping 72 hours of backlog at full rate can saturate the
  uplink and overwhelm the ingest endpoint, which then throttles you, which looks like
  a new outage. Rate-limit the catch-up.
- **Will consumers cope with out-of-order and late data?** A dashboard showing "last
  value" will jump backwards in time during a drain. Downstream systems need to key on
  source timestamp, not arrival order.

## Unified Namespace rollout

If you adopt the UNS pattern from [01](01-landscape-and-architecture.md), the
namespace design is the most consequential decision in the project — it is the
interface every future consumer codes against.

### Designing the topic hierarchy

Make it mirror the **physical and organisational reality**, because that is what stays
stable:

```
<enterprise>/<site>/<area>/<line>/<cell>/<device>/<metric>
```

Guidelines that prevent later pain:

- **Describe location and function, not technology.** `line3/filler/motor1` survives a
  PLC replacement; `plc_192_168_1_50/db100/dbw24` does not.
- **Be consistent about depth.** Consumers write wildcard subscriptions like
  `+/+/+/+/+/+/temperature`; irregular depth breaks them.
- **Lower case, no spaces, no national characters.** Topics are case-sensitive and
  some tooling handles Unicode poorly.
- **Never put values or units in topic names.** `temperature_celsius` forces a topic
  rename when you move to Fahrenheit; put the unit in the payload.
- **Separate current state from events and commands.** A common split is a state
  branch, an event branch and a command branch, so ACLs can grant publish rights to
  state without granting command rights.
- **Write it down and version it.** The namespace is an API; treat it like one.

### Phasing

1. **One line, read-only.** Prove the pattern end to end on a single production line,
   publishing only. No writes, so the risk to production is near zero.
2. **Add consumers.** Dashboard, historian. Demonstrate that adding a consumer needs no
   change at the edge — this is the argument that wins support for the pattern.
3. **Extend horizontally** to more lines using the same namespace template.
4. **Add commands last**, with strict ACLs, confirmation semantics and an audit trail.
   Writing to a plant from a message broker deserves real care.

## Which protocol for which hop

| Hop | Default choice | Why |
|---|---|---|
| Sensor to controller | The machine's native fieldbus | Determinism; it is already there |
| Instrument diagnostics | HART-IP or IO-Link | Data already exists, cheap to harvest |
| Controller to edge | OPC UA | Semantics, security, vendor-neutral |
| Legacy device to edge | Modbus TCP via gateway | Universal, adequate for monitoring |
| Edge to platform | MQTT + Sparkplug B | Efficient, decoupled, self-describing, NAT-friendly |
| Platform to enterprise | AMQP or REST | Transactional semantics, existing IT tooling |
| Controller to controller, fast | OPC UA PubSub or native fieldbus | Deterministic one-to-many |
| Inside a robot or vehicle | DDS | QoS contracts, low latency, redundancy |

## Timestamping and time synchronisation

Industrial data is almost useless without trustworthy time, and this is routinely
underestimated.

- **NTP** gives millisecond accuracy on a LAN — sufficient for SCADA, historians and
  analytics.
- **PTP / IEEE 1588** gives sub-microsecond accuracy with hardware support — needed for
  motion coordination, power quality and sequence-of-events analysis across devices.
- **Timestamp at the source** whenever the source has a clock. A reading stamped by
  the PLC is worth far more than one stamped by a cloud ingest endpoint three hops and
  an outage later.
- **Use UTC everywhere and convert for display only.** Local time in stored data
  creates an hour of duplicated or missing records twice a year, and the resulting
  analytics bugs are genuinely hard to find.
- **Keep one time source for the whole plant.** Two unsynchronised sources make
  cross-system correlation impossible, which defeats the main purpose of collecting
  the data.

## Testing an integration before it reaches production

- **Read-only first.** Commission every path with writes disabled.
- **Verify against a known value.** Compare the value your pipeline reports against the
  HMI reading, for a quantity you can also confirm physically. Do this for one tag per
  device type before trusting hundreds.
- **Check scaling and endianness deliberately** (see [04](04-modbus.md)). A plausible
  but wrong number is far more dangerous than an obviously broken one.
- **Test the failure modes, not just the happy path.** Pull the uplink cable. Power
  cycle the gateway mid-publish. Fill the buffer. Expire a certificate in a lab. These
  are the behaviours that determine whether the system is trustworthy.
- **Measure the load you add.** Check controller scan time and fieldbus cycle time
  before and after. If your monitoring extends the PLC scan, you have made the plant
  worse to observe it.
- **Confirm the quality path.** Force a sensor fault or disconnect a transmitter and
  verify that the downstream consumer shows bad quality rather than a stale number.

## Pitfalls

- **Polling the same device from several systems.** Modbus TCP devices often allow only
  one or two connections. Aggregate at one gateway and fan out from there.
- **No decommissioning process.** Retired devices leave retained MQTT messages, stale
  OPC UA nodes and dead tags that quietly corrupt dashboards and models for years.
- **Mapping tables maintained by hand in spreadsheets.** This is the integration tax
  returning through the back door. Generate configuration from a single source of
  truth.
- **Gateway as a single point of failure with no monitoring.** Monitor the monitor:
  publish a heartbeat and alarm on its absence.
- **Letting each project invent its own namespace.** Three plants with three
  conventions cannot be analysed together, which is usually the entire business case.
- **Treating the edge gateway as appliance-like and never patching it.** It is a
  Linux computer in your DMZ with credentials to both sides. It needs the same
  lifecycle management as any server.

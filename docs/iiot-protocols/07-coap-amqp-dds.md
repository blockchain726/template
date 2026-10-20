# 07 — CoAP, AMQP & DDS

Three protocols that solve problems MQTT does not: REST semantics on tiny
battery-powered devices (CoAP), reliable transactional enterprise messaging (AMQP),
and real-time data-centric distribution with QoS contracts (DDS).

---

## CoAP

**Constrained Application Protocol** (RFC 7252) is REST for devices too small for
HTTP and TCP. It keeps the familiar model — GET, POST, PUT, DELETE on URIs, response
codes, content types — but runs over **UDP** with a 4-byte fixed header.

### Why not just use HTTP?

An HTTP request with headers is typically several hundred bytes; TCP needs a
three-way handshake and keeps connection state; TLS adds a multi-round-trip
handshake. On a device with 32 kB of RAM running from a coin cell over a lossy
radio, all of that is prohibitive. A CoAP exchange can be a single UDP datagram in
each direction, with the radio powered for a few milliseconds.

### How it works

- **Message types**: Confirmable (CON, requires ACK), Non-confirmable (NON, fire and
  forget), Acknowledgement (ACK), Reset (RST). Reliability is implemented at the CoAP
  layer with exponential backoff, rather than relying on TCP.
- **Response codes** mirror HTTP: `2.05 Content`, `4.04 Not Found`, `5.03 Service
  Unavailable`.
- **Observe** (RFC 7641) is the important extension: a client registers interest in a
  resource and the server pushes updates as it changes. This gives publish/subscribe
  behaviour without a broker.
- **Block-wise transfer** (RFC 7959) moves payloads larger than one datagram in
  numbered blocks — necessary for firmware updates.
- **Resource discovery** via `GET /.well-known/core` returning CoRE Link Format, so a
  client can enumerate what a device offers.
- **Proxying** to HTTP is straightforward because the semantics align, which makes
  CoAP devices easy to expose to web tooling.
- **CoAP over TCP/TLS/WebSockets** (RFC 8323) exists for traversing networks that
  block UDP.
- Default ports: **5683** (plaintext), **5684** (DTLS).

### Payloads

CoAP carries any content type; in practice **CBOR** (RFC 8949, a compact binary
JSON-equivalent) and **SenML** (RFC 8428, a standard sensor measurement format) are
usual. SenML is worth knowing because it gives a conventional way to express value,
unit, time and name — the semantics MQTT lacks.

### Security

**DTLS** (TLS over UDP) with pre-shared keys, raw public keys or certificates.
PSK is common on constrained devices since certificate handling is heavy. **OSCORE**
(RFC 8613) is an alternative providing object-level security that survives proxying,
which DTLS cannot.

### When to use it

**Good for:** battery-powered sensors; 6LoWPAN/Thread networks; large fleets of
constrained devices; situations where you want REST semantics end to end;
**LwM2M** device management, which is built on CoAP and is the standard way to manage
cellular IoT fleets.

**Bad for:** anything behind NAT without a persistent mapping (UDP bindings expire);
plant-floor control; high-throughput data; environments whose firewalls block UDP.

---

## AMQP

**Advanced Message Queuing Protocol**. Two incompatible things share the name, and
confusing them wastes a lot of time:

- **AMQP 0-9-1** — the protocol RabbitMQ is built around. Defines exchanges, queues
  and bindings as broker-side concepts.
- **AMQP 1.0** — the OASIS and ISO/IEC 19464 standard. Defines only the wire protocol
  between nodes; broker topology is out of scope. This is what Azure Service Bus,
  Azure IoT Hub, ActiveMQ and Qpid implement.

### What it offers over MQTT

| Capability | AMQP 1.0 | MQTT |
|---|---|---|
| Message metadata | Rich typed headers and annotations | Topic + small set of properties (MQTT 5) |
| Payload typing | Self-describing type system | Opaque bytes |
| Transactions | Yes — atomic multi-message commit | No |
| Flow control | Credit-based, per link | `Receive Maximum` (MQTT 5 only) |
| Queue semantics | Explicit queues, competing consumers | Shared subscriptions (MQTT 5 only) |
| Protocol overhead | Higher | Minimal |
| Footprint | Larger client stacks | Tiny |

The decisive features are **transactions** and **credit-based flow control**. If a
message represents a financial or inventory event that must not be lost or
duplicated, AMQP's transactional semantics are worth the overhead. Credit-based flow
control means a consumer explicitly grants the sender permission for N more messages,
which makes backpressure precise rather than best-effort.

### Model

- **Connection** carries one or more **sessions**; each session carries **links**.
- A link is unidirectional: a **sender** attaches to a target, a **receiver** to a
  source.
- **Settlement** defines delivery guarantees: at-most-once, at-least-once, or
  exactly-once via a two-phase disposition exchange.
- Ports: **5672** plaintext, **5671** TLS. Authentication via **SASL** (PLAIN,
  EXTERNAL for client certificates, and others).

### When to use it

**Good for:** Level 3-4 integration — MES to ERP, order and batch records, anything
transactional; cloud ingestion where the platform speaks AMQP natively (Azure IoT Hub
uses it as a primary protocol); workloads needing competing consumers over a work
queue.

**Bad for:** constrained devices; very large device fleets, where MQTT's smaller
footprint and simpler model win; anything where you only need telemetry fan-out.

---

## DDS

**Data Distribution Service** (OMG) is different in kind from the others. It is
**data-centric** rather than message-centric: participants publish and subscribe to
strongly typed **topics** forming a shared **global data space**, and the middleware
maintains that state with contractual QoS guarantees. There is no broker.

### Core concepts

- **Domain** — an isolation boundary identified by an integer. Participants in
  different domains never see each other.
- **Topic** — a name plus a data type defined in **IDL**.
- **DataWriter / DataReader** — the typed endpoints.
- **Keys** — a field marked as key makes a topic behave like a table of instances:
  one `SensorReading` topic keyed on `sensor_id` maintains an independent value and
  lifecycle per sensor.
- **RTPS** — the Real-Time Publish-Subscribe wire protocol, normally over UDP
  multicast, which makes DDS implementations interoperable across vendors.
- **Automatic discovery** — SPDP finds participants, SEDP matches readers to writers
  by topic, type and QoS compatibility. No configuration of addresses.

### QoS policies: the real distinguishing feature

QoS is a **contract**. A reader and writer connect only if their requested and offered
policies are compatible, so incompatibility surfaces at startup rather than as
mysterious data loss later.

| Policy | Effect |
|---|---|
| `RELIABILITY` | `BEST_EFFORT` or `RELIABLE` (with retransmission) |
| `DURABILITY` | `VOLATILE`, `TRANSIENT_LOCAL`, `TRANSIENT`, `PERSISTENT` — late joiners can receive historical data |
| `HISTORY` | `KEEP_LAST(n)` or `KEEP_ALL` |
| `DEADLINE` | Maximum expected interval between samples; violation raises a status |
| `LIVELINESS` | How writer aliveness is asserted and how quickly loss is detected |
| `OWNERSHIP` | `EXCLUSIVE` with strength values lets a standby publisher take over automatically |
| `LATENCY_BUDGET` | Permits batching within a stated latency allowance |
| `TIME_BASED_FILTER` | Reader-side rate limiting |
| `PARTITION` | Logical sub-channels within a topic |
| `RESOURCE_LIMITS` | Bounded memory — essential for embedded determinism |

`OWNERSHIP` with `EXCLUSIVE` deserves emphasis: it provides redundant publisher
failover as a configuration setting rather than application code, which is why DDS
appears in systems that must not stop.

### Where it is used

Defence and aerospace (it originated there), air traffic control, naval systems,
medical devices, autonomous vehicles, and **ROS 2**, whose entire middleware layer is
DDS. If you work on robotics, you are using DDS whether or not you think about it.

**DDS Security** (a separate OMG specification) adds authentication, access control,
cryptography and logging as pluggable components, with permissions expressed in signed
governance and permissions documents.

### When to use it

**Good for:** many-to-many high-rate data inside a system; latency in the
sub-millisecond to low-millisecond range; applications needing redundancy and
failover; robotics and autonomous platforms; cases where QoS must be explicit and
enforced.

**Bad for:** crossing the internet or NAT (multicast discovery does not traverse it;
routing services exist but add complexity); constrained 8-bit devices; simple
telemetry, where it is substantial overkill; teams without the appetite for its
genuine conceptual complexity.

---

## Choosing between the three

| Need | Choose |
|---|---|
| Battery sensor, lossy radio, REST semantics | **CoAP** |
| Device management for a cellular fleet | **CoAP** (via LwM2M) |
| Transactional business events, exactly-once | **AMQP 1.0** |
| Work queue with competing consumers | **AMQP 1.0** |
| Real-time data sharing inside a robot or vehicle | **DDS** |
| Publisher redundancy with automatic failover | **DDS** |
| Plain telemetry from many devices to many consumers | **MQTT** (see [02](02-mqtt-and-sparkplug.md)) |

## Pitfalls

- **CoAP behind NAT.** UDP mappings expire in as little as 30 seconds on some
  cellular networks. Either keep traffic device-initiated with short intervals, or use
  CoAP over TCP.
- **CoAP without congestion awareness.** UDP has no built-in congestion control; a
  fleet retrying simultaneously after an outage can saturate the uplink. Randomise
  backoff.
- **Confusing AMQP 0-9-1 with 1.0.** A RabbitMQ client library will not talk to an
  AMQP 1.0 endpoint without the appropriate plugin or a different library.
- **DDS multicast on a network that does not forward it.** Discovery silently fails
  and nothing connects. Check IGMP and, where needed, configure a discovery peer list
  explicitly.
- **DDS QoS mismatch.** A `BEST_EFFORT` writer will not match a `RELIABLE` reader. The
  reader simply receives nothing, with no error unless you check the matched-publication
  status. Always log discovery and match events during commissioning.
- **Unbounded DDS history on an embedded target.** `KEEP_ALL` with no
  `RESOURCE_LIMITS` will eventually exhaust memory. Set limits deliberately.

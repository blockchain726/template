# 01 — Landscape & Architecture

## Why industrial networks look strange to IT engineers

An industrial network optimises for different things than an office network. A web
service cares about throughput and average latency. A machine controller cares about
**determinism**: the guarantee that a message arrives within a bounded time, every
time. A control loop that usually completes in 1 ms but occasionally takes 40 ms is
not a slow control loop — it is a broken one, and it may wreck the product or the
machine.

This single difference explains most of the design decisions that follow: why
fieldbuses avoid TCP, why some protocols bypass the IP stack entirely, and why
"just put it all on MQTT" is not an answer at the control layer.

## The automation pyramid

The traditional model stacks five levels. It is dated — but it is still the mental
map most plant engineers use, and the vocabulary is unavoidable.

```
Level 4   ERP / business systems      SAP, Oracle          days - months
          ---------------------------------------------------------------
Level 3   MES / operations            scheduling, batch    minutes - hours
          ---------------------------------------------------------------
Level 2   SCADA / HMI                 operator screens     100 ms - 1 s
          ---------------------------------------------------------------
Level 1   Control: PLC / DCS / PAC    the control logic    1 - 100 ms
          ---------------------------------------------------------------
Level 0   Field: sensors, drives      the physical process 10 us - 10 ms
```

Protocols cluster by level:

- **Level 0-1**: EtherCAT, PROFINET, EtherNet/IP, PROFIBUS, IO-Link, HART
- **Level 1-2**: Modbus TCP, OPC UA client/server, OPC Classic (DA)
- **Level 2-3**: OPC UA, MQTT/Sparkplug, SQL historians, REST
- **Level 3-4**: AMQP, Kafka, REST, file transfer

### The problem with the pyramid

Data has to be relayed up level by level, and each hop is a hand-built mapping:
a PLC tag becomes a Modbus register number, which a SCADA system maps to a point
name, which an MES integration maps to a database column. Change a tag and three
layers break. This is the "integration tax" that dominates the cost of most
industrial data projects.

## The Unified Namespace alternative

The Unified Namespace (UNS) inverts the flow. Instead of each layer polling the one
below, every producer **publishes its current state** to a central broker using a
hierarchical topic that mirrors the physical plant, and any consumer subscribes to
whatever it needs.

```
enterprise/site/area/line/cell/device/metric

acme/dallas/packaging/line3/filler/motor1/temperature
```

Properties worth understanding:

- **Report by exception.** A value is published when it changes, not on a poll cycle.
  Quiet plants generate almost no traffic.
- **Single source of current state.** With MQTT retained messages or Sparkplug birth
  certificates, a newly connected client gets the present value immediately without
  waiting for the next change.
- **Producers do not know consumers.** Adding an analytics tool requires no change to
  any PLC or gateway.
- **The broker becomes critical infrastructure.** It needs clustering, monitoring and
  a security model — this is the main cost of the pattern.

A UNS does *not* replace Level 0-1 protocols. Nobody closes a servo loop over MQTT.
It replaces the brittle Level 2-4 integration layer.

## Communication models

### Request/response (polling)

A client asks, a server answers. Modbus and OPC UA reads work this way.

- Simple, easy to debug, client controls the load.
- Bandwidth is spent whether or not data changed.
- Latency to detect a change is up to one full poll cycle.
- Scaling is poor: N clients polling M devices is N x M traffic.

### Publish/subscribe (brokered)

Publishers send to a topic on a broker; subscribers receive. MQTT and AMQP work
this way.

- Decouples producers and consumers in space, time and quantity.
- Traffic proportional to *change*, not to the number of clients.
- The broker is a single point of failure and a bandwidth concentrator.
- Harder to reason about end-to-end timing.

### Publish/subscribe (brokerless, data-centric)

Participants discover each other directly and exchange typed data. DDS works this
way, as does OPC UA PubSub over UDP multicast.

- No broker hop, so lower and more predictable latency.
- Discovery traffic grows with participant count and needs multicast.
- Rich QoS contracts (deadline, liveliness, durability) are negotiated per topic.

### Cyclic I/O exchange

Controller and device swap a fixed-size data image every cycle, forever, whether or
not anything changed. PROFINET, EtherNet/IP implicit messaging and EtherCAT work
this way.

- Jitter is bounded and tiny; this is what real-time control needs.
- Payloads are fixed at configuration time; there is no ad-hoc querying.
- Needs engineering tools and device description files (GSDML, EDS, ESI).

## Determinism classes

A useful way to classify any industrial link:

| Class | Cycle time | Jitter tolerance | Typical use | Technologies |
|---|---|---|---|---|
| Isochronous / motion | 31.25 us - 1 ms | < 1 us | Coordinated multi-axis motion, CNC | EtherCAT DC, PROFINET IRT, POWERLINK, Sercos III |
| Hard real-time | 1 - 10 ms | < 100 us | Standard machine I/O, safety | PROFINET RT, EtherNet/IP, Modbus RTU on dedicated link |
| Soft real-time | 10 - 100 ms | milliseconds | Process control, SCADA polling | Modbus TCP, OPC UA subscriptions |
| Non-real-time | > 100 ms | seconds | Historians, dashboards, analytics, cloud | MQTT, AMQP, REST, Kafka |

Most "IIoT" work lives in the bottom two rows. Recognising that early saves a lot of
argument: if your use case is a dashboard refreshed every few seconds, you do not
need — and should not pay for — a deterministic fieldbus.

## Where the OSI model helps and where it misleads

Several industrial protocols deliberately skip layers to cut latency:

- **EtherCAT** rides directly on Ethernet with EtherType `0x88A4`. No IP, no TCP.
  You cannot route it; you cannot see it with a normal IP-based tool.
- **PROFINET RT** uses EtherType `0x8892` for cyclic data, while acyclic
  configuration and diagnostics use UDP/IP. The same cable carries both.
- **Modbus RTU** is effectively an application protocol sitting straight on a serial
  line, with no network layer at all.

Practical consequences: a router or L3 switch will drop EtherCAT and PROFINET RT
frames. VLANs and managed switches must be configured with these EtherTypes in mind.
And a packet capture filtered on `tcp` or `ip` will show you nothing of the actual
control traffic.

## Choosing: the three questions that decide it

1. **What is the required cycle time, and what jitter can the process tolerate?**
   This alone eliminates most options. Sub-millisecond with tight jitter forces a
   dedicated industrial Ethernet fieldbus.

2. **Who needs the data, and does that set change over time?**
   One fixed controller reading one device: polling is fine. An unknown and growing
   set of consumers: publish/subscribe will pay for itself.

3. **Does the consumer need to understand the data without a human explaining it?**
   If yes, you need a protocol carrying semantics — OPC UA, Sparkplug B or DDS — not
   raw Modbus registers. This is the difference between `40001 = 1247` and
   `Line3.Filler.Motor1.Temperature = 124.7 degC (good, 2026-10-20T08:14:22Z)`.

## Pitfalls

- **Assuming Ethernet means interoperable.** PROFINET, EtherNet/IP and EtherCAT all
  run on Ethernet cable and are mutually unintelligible.
- **Polling a device faster than it updates.** Many transmitters refresh internally
  at 100-500 ms. Polling at 10 ms gives you the same value ten times and may starve
  the device's own processing.
- **Putting control traffic and video on one untagged VLAN.** A camera burst will
  blow the jitter budget of a cyclic bus.
- **Forgetting the gateway is a translator, not a pipe.** Every protocol conversion
  loses something: data types collapse, timestamps get replaced with gateway time,
  quality flags vanish. Know what you are losing at each hop.
- **Designing the topic namespace last.** In a UNS the namespace *is* the API. Rename
  it after a hundred devices are deployed and you will do it twice.

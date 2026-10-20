# IIoT Communication Protocols — A Practical Guide

A working engineer's reference to the protocols used to move data around industrial
systems: from a sensor on a machine, up through controllers and gateways, to
historians, MES and cloud analytics.

These guides are **originally written** for this repository. They do not reproduce
any standards body's copyrighted specification text — see
[`references.md`](references.md) for where to obtain the official documents.

## Contents

| # | Guide | Covers |
|---|---|---|
| 01 | [Landscape & architecture](01-landscape-and-architecture.md) | OT vs IT, the automation pyramid, Unified Namespace, determinism classes, pub/sub vs request/response |
| 02 | [MQTT & Sparkplug B](02-mqtt-and-sparkplug.md) | Topics, QoS, retain, LWT, MQTT 5 features, Sparkplug payloads and state management |
| 03 | [OPC UA](03-opc-ua.md) | Information modelling, address space, services, PubSub, security, profiles |
| 04 | [Modbus](04-modbus.md) | RTU/ASCII/TCP framing, the four register tables, function codes, real-world pitfalls |
| 05 | [Industrial Ethernet](05-industrial-ethernet.md) | PROFINET, EtherNet/IP/CIP, EtherCAT, POWERLINK, Sercos III, conformance classes |
| 06 | [Fieldbus & device level](06-fieldbus-and-device-level.md) | PROFIBUS, HART, Foundation Fieldbus, CANopen, J1939, IO-Link, AS-Interface |
| 07 | [CoAP, AMQP & DDS](07-coap-amqp-dds.md) | Constrained REST, enterprise messaging, and real-time data-centric middleware |
| 08 | [Wireless & LPWAN](08-wireless-and-lpwan.md) | WirelessHART, ISA100, Zigbee, BLE, LoRaWAN, NB-IoT/LTE-M, 5G URLLC |
| 09 | [Security](09-security.md) | IEC 62443, Purdue zones, TLS and PKI in OT, per-protocol security posture |
| 10 | [Integration patterns](10-integration-patterns.md) | Gateways, protocol conversion, edge buffering, store-and-forward, UNS rollout |
| — | [References](references.md) | Official specifications, standards bodies, licensing notes |

## Quick pick

**"I need to get PLC data to the cloud."**
OPC UA for the semantic model at the plant, MQTT + Sparkplug B for the transport
north of the gateway. See [10](10-integration-patterns.md).

**"I need to read a flow meter over two wires."**
Modbus RTU if it is a simple register device; HART if it is a 4–20 mA transmitter
you also want diagnostics from. See [04](04-modbus.md) and [06](06-fieldbus-and-device-level.md).

**"I need motion control with microsecond jitter."**
EtherCAT or POWERLINK, or PROFINET IRT. Not MQTT, not OPC UA client/server.
See [05](05-industrial-ethernet.md).

**"I need battery sensors reporting a few times an hour over kilometres."**
LoRaWAN or NB-IoT. See [08](08-wireless-and-lpwan.md).

**"I need robot/vehicle software components to share data at high rate."**
DDS. See [07](07-coap-amqp-dds.md).

## Comparison at a glance

| Protocol | Model | Typical cycle | Transport | Discovery | Built-in security | Payload is self-describing |
|---|---|---|---|---|---|---|
| Modbus TCP | Polled register read/write | 10 ms – 1 s | TCP/502 | None | None | No |
| Modbus RTU | Polled register read/write | 20 ms – 1 s | RS-485 | None | None | No |
| OPC UA client/server | Session + subscriptions | 50 ms – 1 s | TCP/4840, HTTPS | LDS / GDS | Yes (X.509, per-message) | Yes |
| OPC UA PubSub | Publish/subscribe | 1 – 100 ms | UDP multicast, MQTT, AMQP | Yes | Yes | Yes |
| MQTT | Broker pub/sub | Event-driven | TCP/1883, TLS/8883 | None (topics by convention) | TLS + authN | No (bytes) |
| Sparkplug B | Broker pub/sub + state | Event-driven | MQTT | Yes (birth certificates) | Inherits MQTT | Yes (protobuf, typed) |
| CoAP | REST on UDP | Event or poll | UDP/5683, DTLS/5684 | CoRE Link Format | DTLS / OSCORE | Partly (CBOR/SenML) |
| AMQP 1.0 | Brokered queues/topics | Event-driven | TCP/5672, TLS/5671 | None | TLS + SASL | Yes (typed) |
| DDS / RTPS | Data-centric pub/sub | 0.1 – 10 ms | UDP multicast | Automatic (SPDP/SEDP) | DDS Security | Yes (IDL types) |
| PROFINET RT | Cyclic I/O | 1 – 10 ms | Raw Ethernet 0x8892 | DCP | Limited | Via GSDML |
| PROFINET IRT | Scheduled cyclic I/O | 31.25 µs – 1 ms | Raw Ethernet + scheduling | DCP | Limited | Via GSDML |
| EtherNet/IP | Implicit (I/O) + explicit | 1 – 10 ms | UDP/2222, TCP/44818 | ListIdentity | CIP Security | Via EDS |
| EtherCAT | Summation frame | 50 µs – 1 ms | Raw Ethernet 0x88A4 | Automatic | FSoE for safety only | Via ESI |
| LoRaWAN | Uplink/downlink via gateway | Minutes – hours | Sub-GHz radio | Join procedure | AES-128 (two keys) | No |
| HART | Digital over 4–20 mA | ~2 updates/s | Current loop | Yes | None (WirelessHART: AES) | Yes (device description) |

## How to read these guides

Each protocol guide follows the same shape so you can compare them directly:

1. **What it is and where it sits** — the layer and the problem it solves
2. **How it works** — framing, addressing, data model
3. **Configuration that matters** — the handful of settings that cause most trouble
4. **Security posture** — what it does and does not protect
5. **When to use it / when not to**
6. **Pitfalls** — the failures that actually happen in the field

## Scope and honest limits

These are **integration-oriented** guides. They are written to help you choose a
protocol, wire it up correctly, and avoid common failure modes. They are not a
substitute for the normative specification when you are *implementing* a stack or
certifying a device — for that you need the official document, and
[`references.md`](references.md) tells you where each one lives and what it costs.

Figures such as cycle times are typical field values, not guaranteed limits; the
achievable number always depends on the specific hardware, topology and
configuration.

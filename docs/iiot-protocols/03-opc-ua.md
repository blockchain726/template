# 03 — OPC UA

## What it is and where it sits

OPC UA (IEC 62541) is the standard way to expose industrial data **with its meaning
attached**. Where Modbus gives you register 40001 and MQTT gives you bytes, OPC UA
gives you a browsable, typed, self-describing address space: a `MotorTemperature`
variable of type `Double`, in engineering units of degrees Celsius, with a timestamp,
a quality status, and a documented relationship to the motor object it belongs to.

It is platform-independent (unlike OPC Classic, which was built on Microsoft COM/DCOM
and was notoriously painful to secure and tunnel across subnets) and spans Level 1
to Level 4.

Two distinct communication patterns live under the same name, and conflating them
causes most OPC UA confusion:

- **Client/server** — sessions, browsing, reads, writes, method calls, subscriptions.
  Connection-oriented, TCP, one-to-one.
- **PubSub** — connectionless publish/subscribe over UDP multicast, MQTT or AMQP.
  One-to-many, added in Part 14.

## The information model

### Nodes and the address space

Everything in an OPC UA server is a **node** in a graph. Each node has a NodeId,
a BrowseName, a NodeClass and typed attributes. Nodes are connected by **references**,
which are themselves typed.

Principal node classes:

| NodeClass | Role |
|---|---|
| `Object` | A container representing a thing — a pump, a machine, a folder |
| `Variable` | Holds a value; this is what you read and write |
| `Method` | A callable function with input and output arguments |
| `ObjectType` / `VariableType` | Type definitions that instances point to |
| `ReferenceType` | The kinds of relationship (`HasComponent`, `Organizes`, ...) |
| `DataType` | Structure and scalar type definitions |

Because references are typed, a client can ask structural questions: *what components
does this pump have*, *what type is this instance*, *which objects does this alarm
refer to*. This is the real advantage over a flat tag list.

### NodeIds

A NodeId is a namespace index plus an identifier:

```
ns=2;i=1234          numeric identifier in namespace 2
ns=2;s=Line3.Motor1  string identifier
ns=3;g=<guid>        GUID
ns=0;i=2258          standard node: Server_ServerStatus_CurrentTime
```

Namespace 0 is reserved for the OPC Foundation's standard nodes. **The namespace
index is not stable across server restarts or firmware updates** — it is an index
into the server's namespace array. Always resolve by namespace *URI* at startup and
map to the current index, or your client will break after a controller upgrade. This
is one of the most common production bugs in OPC UA clients.

### Companion specifications

The base standard defines the mechanics; **companion specifications** define
industry-specific models so that two vendors describe the same machine the same way.
Widely used ones include PackML and Weihenstephan for packaging, Euromap for plastics
machinery, UMATI for machine tools, PLCopen for IEC 61131 program structures, and
VDMA models for many machine categories. If one exists for your domain, use it —
it is the difference between integration and re-integration.

## Services

OPC UA services are grouped into sets. The ones you will actually use:

| Service set | Key services | Purpose |
|---|---|---|
| Discovery | `FindServers`, `GetEndpoints` | Locate servers and their security options |
| SecureChannel / Session | `OpenSecureChannel`, `CreateSession`, `ActivateSession` | Establish an authenticated, encrypted channel |
| View | `Browse`, `BrowseNext`, `TranslateBrowsePathToNodeIds` | Navigate the address space |
| Attribute | `Read`, `Write`, `HistoryRead`, `HistoryUpdate` | Access values and historical data |
| Method | `Call` | Invoke a method on an object |
| MonitoredItem | `CreateMonitoredItems`, `ModifyMonitoredItems` | Register items for change notification |
| Subscription | `CreateSubscription`, `Publish` | Receive batched notifications |

### Subscriptions: the part that is usually misconfigured

Do not poll an OPC UA server with repeated `Read` calls. Create a **subscription** and
let the server notify you. Three parameters govern behaviour:

- **Publishing interval** (subscription level) — how often the server sends a batch of
  notifications.
- **Sampling interval** (per monitored item) — how often the server checks the value
  internally. May be faster than the publishing interval; samples are queued.
- **Queue size and discard policy** (per monitored item) — how many samples are held
  between publishes, and whether the oldest or newest is dropped on overflow.

A worked example: sampling at 100 ms, publishing at 1 s, queue size 10 gives you all
ten samples per second delivered in one packet — full resolution at one tenth the
network overhead. Queue size 1 under the same settings gives you only the latest value
and silently discards nine out of ten samples. Choosing queue size 1 while expecting
complete data is a frequent and hard-to-spot error.

Also set a **deadband** (absolute or percentage) on noisy analogue values, or a
fluctuating last digit will generate notifications continuously.

### Data value: what a read actually returns

Every value comes with more than a number:

- **Value** — typed, possibly a structure or array
- **StatusCode** — `Good`, `Uncertain`, `Bad`, with specific sub-codes such as
  `Bad_SensorFailure` or `Uncertain_LastUsableValue`
- **SourceTimestamp** — when the source produced it
- **ServerTimestamp** — when the server processed it

Propagate the StatusCode. A gateway that maps OPC UA to MQTT and throws away status
converts a known sensor failure into a plausible-looking reading, which is worse than
no reading.

## OPC UA PubSub (Part 14)

Client/server is excellent for engineering and modelling but has a per-session cost
and a request/response latency floor. PubSub addresses one-to-many and faster
exchange:

- **Publisher** sends `NetworkMessage`s containing `DataSetMessage`s, described by
  `DataSetMetaData`.
- **Transport** is UDP multicast (`opc.udp://`) for low latency on a local network,
  or MQTT/AMQP as a broker-mediated transport for routed and cloud-bound traffic.
- **No session**, so publishers do not care how many subscribers exist.
- Combined with TSN, this is the basis of deterministic OPC UA for controller-to-
  controller traffic.

Choose PubSub for many-to-many cyclic data and controller-to-controller exchange;
choose client/server when you need browsing, methods, history or write confirmation.

## Security posture

OPC UA has the most thorough security model of any protocol in this collection, and
it is genuinely good when actually switched on.

### Layers

1. **Transport** — `opc.tcp` with the UA Secure Conversation protocol, or HTTPS.
2. **Message security mode** — `None`, `Sign`, or `SignAndEncrypt`. Signing gives
   integrity and authenticity; encryption adds confidentiality.
3. **Application authentication** — server and client each hold an X.509 certificate
   and must place the other's in a trust list. Mutual authentication is the default
   design, not an add-on.
4. **User authentication** — anonymous, username/password, X.509 user certificate, or
   an issued token (JWT, Kerberos).
5. **Authorisation** — per-node read/write/browse permissions and role-based access
   control (RBAC) in newer versions.

### Security policies

Policy names encode the cryptographic suite, for example
`Basic256Sha256`, `Aes128_Sha256_RsaOaep` and `Aes256_Sha256_RsaPss`. The older
`Basic128Rsa15` and `Basic256` are **deprecated and should be disabled** — they rely on
SHA-1 and PKCS#1 v1.5. Prefer `Aes256_Sha256_RsaPss`, falling back to
`Basic256Sha256` for older equipment.

### What goes wrong in practice

- **`SecurityPolicy#None` left enabled** so commissioning engineers can connect with
  any tool. It is almost always still enabled years later. Disable the `None` endpoint
  in production.
- **Certificate trust by blind acceptance.** Clients that auto-trust any presented
  certificate discard the entire authentication model. Provision trust lists
  deliberately.
- **Certificate expiry.** UA certificates expire, often after 1-5 years, and an
  expired one stops the connection dead — typically at 02:00 on a Sunday. Track expiry
  dates and plan rotation; a GDS (Global Discovery Server) automates this at scale.
- **Anonymous user tokens with full write access.** Separate application
  authentication from user authorisation; a trusted client is not the same as a
  privileged user.

## When to use it

**Good for:** exposing a machine or line in a way others can discover and interpret;
vendor-neutral integration between PLC/DCS and MES or historian; replacing OPC
Classic; anywhere you want a data model rather than a tag list; secure access across
network zones.

**Bad for:** very constrained devices (a full UA stack is heavy, though
UA Nano/Micro profiles and `opc.ua.binary` over constrained transports help);
hard real-time motion control with client/server; high-cardinality
cloud fan-out, where MQTT/Sparkplug is usually more economical — the common pattern
is OPC UA inside the plant, MQTT northbound.

## Pitfalls

- **Hard-coding namespace indices.** Resolve by namespace URI every time you connect.
- **Browsing the whole address space on every start.** Large servers hold hundreds of
  thousands of nodes; cache the browse result and refresh on a model-change event.
- **Ignoring `BadTooManySessions` / `BadTooManyMonitoredItems`.** Embedded servers in
  PLCs often cap sessions at 5-10 and monitored items in the low thousands. Share one
  client connection across consumers rather than letting every tool open its own.
- **Reading each tag with a separate `Read` call.** Batch node IDs into one request;
  the per-call overhead dominates otherwise.
- **Expecting consistent performance from embedded servers.** An OPC UA server running
  on the PLC CPU competes with the control task. Aggressive subscriptions can extend
  the scan time of the machine itself.
- **Forgetting that `Write` may be refused silently by a gateway.** Always check the
  returned StatusCode rather than assuming success.

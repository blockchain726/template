# 02 — MQTT & Sparkplug B

## What it is and where it sits

MQTT is a lightweight publish/subscribe transport. A client connects to a **broker**
over TCP, publishes messages to **topics**, and subscribes to topic filters. The
broker does the routing; publishers and subscribers never address each other.

It sits at Level 2-4 — gateway to cloud, edge to historian. MQTT itself carries
**opaque bytes** and defines no data model, which is both its great strength
(it will carry anything) and its great weakness (nothing knows what the bytes mean).
Sparkplug B, covered below, is the layer that fixes this for industrial use.

Versions you will meet: **3.1.1** (OASIS, 2014 — still the most widely deployed) and
**5.0** (OASIS, 2019 — worth using for new work, see the feature list below).

## How it works

### Topics

Topics are UTF-8 strings with `/` as a hierarchy separator. There is no registration
step; publishing to a topic creates it implicitly.

```
acme/dallas/packaging/line3/filler/motor1/temperature
```

Subscriptions may use two wildcards:

| Wildcard | Meaning | Example | Matches |
|---|---|---|---|
| `+` | exactly one level | `acme/dallas/+/line3/#` | any area |
| `#` | all remaining levels (must be last) | `acme/dallas/#` | everything under the site |

Rules worth knowing: topics are case-sensitive; a leading `/` creates an empty first
level (`/acme` is not `acme`); `$SYS/...` is reserved by convention for broker
statistics; and you cannot publish to a wildcard.

### Quality of Service

QoS is negotiated per publish and per subscription; the effective QoS of delivery is
the **minimum** of the two.

| QoS | Guarantee | Handshake | Cost | Use for |
|---|---|---|---|---|
| 0 | At most once — fire and forget | PUBLISH | 1 message | High-rate telemetry where a gap is harmless |
| 1 | At least once — **duplicates possible** | PUBLISH / PUBACK | 2 messages | Most industrial telemetry |
| 2 | Exactly once | PUBLISH / PUBREC / PUBREL / PUBCOMP | 4 messages | Commands, totalisers, billing counters |

The practical advice: **QoS 1 for data, QoS 2 for commands**. QoS 1 duplicates are
real and will appear after a reconnect — make consumers idempotent. QoS 2 costs two
round trips and will throttle a high-rate stream.

### Retained messages

A publish with the **retain** flag set causes the broker to store that one message as
the "last known good" value for the topic and deliver it immediately to any future
subscriber.

This is how you solve the cold-start problem: a dashboard that connects at 03:00
gets the current tank level at once, instead of a blank field until the level next
changes. Exactly one retained message is kept per topic; publishing a zero-length
payload with retain set clears it.

### Last Will and Testament

At connect time a client may register a **will** message — topic, payload and QoS.
If the client disconnects ungracefully (no DISCONNECT packet, or keepalive expiry),
the broker publishes that message on its behalf.

This is the standard device-offline detection mechanism. Combine it with a retained
birth message on the same topic and subscribers always know whether a device is
alive:

```
Topic:   acme/dallas/line3/filler/status
Connect: publish "ONLINE"  (retain=true)
Will:    publish "OFFLINE" (retain=true)
```

### Keepalive and sessions

`Keep Alive` is the maximum interval the client promises between packets; if it has
nothing to say it sends PINGREQ. The broker declares the client dead after
**1.5 x keepalive**. Short keepalives detect failure faster but cost traffic on
cellular links.

Sessions determine what survives a disconnect. In MQTT 5 a session persists for
`Session Expiry Interval` seconds, during which the broker holds the client's
subscriptions and queued QoS 1/2 messages. In 3.1.1 the cruder `Clean Session` flag
either keeps state indefinitely or discards it entirely.

## MQTT 5 features that matter industrially

| Feature | Why you care |
|---|---|
| **Reason codes** on every ack | A rejected publish tells you *why* instead of silently dropping the connection |
| **Session Expiry Interval** | Bounded state retention; fixes the 3.1.1 "persistent session forever" leak |
| **Message Expiry Interval** | Stale telemetry is discarded rather than delivered hours late after an outage |
| **Topic Alias** | Replaces a long topic with a 2-byte integer after first use — significant on metered cellular |
| **User Properties** | Arbitrary key/value headers; carry units, source, trace IDs without touching the payload |
| **Shared Subscriptions** (`$share/group/topic`) | Load-balance one topic across a pool of consumers — enables horizontal scaling |
| **Request/Response** (`Response Topic`, `Correlation Data`) | Standardised RPC pattern instead of hand-rolled reply topics |
| **Flow control** (`Receive Maximum`) | Prevents a fast publisher overwhelming a slow consumer |

## Sparkplug B

MQTT's silence about payloads means two vendors can both "support MQTT" and still
not interoperate at all. **Sparkplug B** (an Eclipse Foundation specification) closes
this by defining three things on top of MQTT:

1. **A topic namespace**
2. **A payload format** (Google Protocol Buffers, with typed metrics)
3. **A state management model** (birth and death certificates)

### Topic structure

```
spBv1.0/<group_id>/<message_type>/<edge_node_id>[/<device_id>]
```

| Message type | Meaning |
|---|---|
| `NBIRTH` / `NDEATH` | Edge node birth / death certificate |
| `DBIRTH` / `DDEATH` | Device birth / death certificate |
| `NDATA` / `DDATA` | Node / device data (changes only) |
| `NCMD` / `DCMD` | Command to node / device |
| `STATE` | Primary application state (host online/offline) |

### Why birth certificates are the key idea

On connect, an edge node publishes `NBIRTH` listing **every metric it will ever
report**, with name, datatype, an integer alias and the current value. Subsequent
`NDATA` messages carry only what changed, referencing the compact alias instead of
the full name.

The consequences are worth spelling out, because this is what makes Sparkplug
genuinely different from ad-hoc MQTT:

- **Auto-discovery.** A new consumer learns the entire tag list from the birth
  message. No CSV of tag names emailed between integrators.
- **Self-describing types.** Metrics carry real datatypes (Int32, Float, Boolean,
  String, DateTime) rather than ambiguous bytes.
- **Bandwidth efficiency.** After birth, payloads are protobuf with integer aliases —
  typically a fraction of equivalent JSON.
- **Guaranteed state.** `NDEATH` is registered as the MQTT will message, so an
  ungraceful dropout is detected by the broker and announced. Sequence numbers
  (`seq`, 0-255 rolling) let a consumer detect a missed message and request a full
  refresh via `NCMD`/`Node Control/Rebirth`.

### Sparkplug constraints to plan for

- Requires **QoS 0 for DATA** and **QoS 1 for BIRTH/DEATH/CMD** per spec, and forbids
  retained messages on Sparkplug topics — state comes from birth certificates
  instead, which surprises people who expect `retain` to work.
- The `group_id`/`edge_node_id` structure is flatter than a full plant hierarchy; the
  physical hierarchy usually goes into metric *names*
  (`Line3/Filler/Motor1/Temperature`).
- Protobuf payloads are not human-readable in a generic MQTT client — you need a
  Sparkplug-aware tool to debug.

## Security posture

MQTT provides **no security of its own**. Everything depends on configuration:

- **Transport**: TLS on port 8883. Without it, credentials and payloads are plaintext
  on the wire. Verify the broker certificate — a client that skips verification is
  trivially machine-in-the-middled.
- **Authentication**: username/password in CONNECT (useless without TLS), or X.509
  client certificates (much better for fixed devices), or MQTT 5 enhanced
  authentication with SASL-style challenge/response.
- **Authorisation**: per-topic ACLs on the broker, controlling publish and subscribe
  separately. This is the control that matters most, and the one most often left
  wide open. A device should be able to publish only to its own branch of the
  namespace and subscribe only to its own command topics.
- **No payload integrity**: MQTT does not sign messages. A compromised client with
  valid credentials can publish any value to any topic its ACL allows.

Default-deny ACLs, per-device credentials (never one shared account), and a broker
that is not directly exposed to the internet cover most of the risk.

## When to use it

**Good for:** telemetry from many devices to many consumers; unreliable or metered
links (it reconnects and resumes gracefully); deployments where the consumer set
changes; plant-to-cloud; Unified Namespace implementations.

**Bad for:** closed-loop control of any kind; anything needing bounded latency (the
broker hop plus TCP retransmission makes worst-case timing unbounded); very large
payloads such as video or waveform files — publish a reference to object storage
instead; and request/response-heavy workloads, where a REST API or OPC UA is simpler.

## Pitfalls

- **Wildcard subscription to `#` on a busy broker.** You will receive everything,
  including other sites, and probably fall behind. Subscribe narrowly.
- **One client ID used by two devices.** The broker enforces uniqueness by
  disconnecting the older session, so two devices sharing an ID will knock each other
  offline in an endless loop. Derive client IDs from serial numbers.
- **Assuming QoS 1 means no duplicates.** It means *at least* once. Deduplicate or be
  idempotent.
- **Retained messages accumulating forever.** Every topic ever published with retain
  keeps a message until explicitly cleared. Decommissioned devices leave ghosts in
  the namespace; clear them with a zero-length retained publish.
- **Keepalive longer than a NAT or firewall idle timeout.** The device thinks it is
  connected, the broker thinks so too, and the middlebox has silently dropped the
  flow. Keep keepalive below the shortest idle timeout on the path (often 300 s).
- **No backpressure plan at the edge.** When the uplink fails, where do readings go?
  Size a local store-and-forward buffer deliberately and decide what to discard when
  it fills.
- **Treating the broker as stateless.** With persistent sessions and retained
  messages it holds real state that needs backup and capacity planning.

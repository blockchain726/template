# 04 — Modbus

## What it is and where it sits

Modbus is the oldest protocol here (Modicon, 1979) and still the most widely
implemented. It is a simple request/response protocol in which a client (historically
"master") reads and writes numbered registers in a server (historically "slave").

It has no data model, no discovery, no security and no timestamps. It survives because
it is trivial to implement, royalty-free, and supported by essentially every piece of
industrial equipment ever made. For reading a flow meter or a power monitor, it is
often the right answer precisely because it is boring.

Three variants:

| Variant | Physical layer | Framing | Addressing |
|---|---|---|---|
| **Modbus RTU** | RS-485 / RS-232 | Binary, CRC-16, silence-based delimiting | 1-247 unit ID on a shared bus |
| **Modbus ASCII** | RS-485 / RS-232 | Hex text, LRC, `:` start and CRLF end | 1-247 unit ID |
| **Modbus TCP** | Ethernet | MBAP header, no checksum (TCP covers it) | IP address + unit ID |

## The four data tables

Modbus exposes four separate address spaces. They are genuinely separate — coil 1 and
holding register 1 are unrelated storage.

| Table | Type | Access | Function codes | Classic numbering |
|---|---|---|---|---|
| Discrete Inputs | 1 bit | Read-only | 2 | 10001-19999 |
| Coils | 1 bit | Read/write | 1, 5, 15 | 00001-09999 |
| Input Registers | 16 bit | Read-only | 4 | 30001-39999 |
| Holding Registers | 16 bit | Read/write | 3, 6, 16 | 40001-49999 |

### The off-by-one that bites everyone

Documentation written for humans uses 1-based "classic" numbering; the protocol on the
wire uses 0-based addresses. Holding register **40001** is transmitted as address
**0x0000**.

So when a vendor manual says "power factor is in register 40107", the request you must
send contains address 106. Worse, some vendors document the wire address directly, and
some document `4x107` meaning "holding register 107" which is wire address 106.

**Always confirm with a known value.** Read the device's firmware revision or serial
number register first — if it comes back as the documented value, your offset
convention is right. Do not debug a scaling problem before confirming the offset.

## Common function codes

| Code | Name | Notes |
|---|---|---|
| 1 | Read Coils | Up to 2000 bits |
| 2 | Read Discrete Inputs | Up to 2000 bits |
| 3 | Read Holding Registers | Up to 125 registers per request |
| 4 | Read Input Registers | Up to 125 registers per request |
| 5 | Write Single Coil | Value `0xFF00` = on, `0x0000` = off |
| 6 | Write Single Register | |
| 15 | Write Multiple Coils | |
| 16 | Write Multiple Registers | Up to 123 registers |
| 23 | Read/Write Multiple Registers | One round trip for both |

An error response sets the high bit of the function code (`0x83` for a failed FC 3)
and returns an exception code:

| Exception | Meaning | Usual real cause |
|---|---|---|
| 1 | Illegal function | Device does not support that FC |
| 2 | Illegal data address | Register does not exist — usually your off-by-one |
| 3 | Illegal data value | Value outside the device's accepted range |
| 4 | Server device failure | Internal fault in the device |
| 6 | Server device busy | Retry later; common during device config writes |

## Data beyond 16 bits

Modbus registers are 16 bits. Anything larger is spread over consecutive registers,
and **the specification does not define the order**. This is the single biggest
source of Modbus integration pain.

A 32-bit float 123.456 (IEEE 754 `0x42F6E979`) may appear as:

| Convention | Register N | Register N+1 | Name |
|---|---|---|---|
| Big-endian | `0x42F6` | `0xE979` | ABCD |
| Little-endian | `0x79E9` | `0xF642` | DCBA |
| Big-endian byte swap | `0xF642` | `0x79E9` | BADC |
| Little-endian byte swap | `0xE979` | `0x42F6` | CDAB (word-swapped) |

CDAB — correct byte order within each register, registers swapped — is extremely
common because many devices are internally little-endian at the 32-bit level.

**How to resolve it quickly:** read a register whose value you know and can recognise.
A temperature reading of roughly 25 that decodes as `1.3e-19` or `4.6e18` is a byte
order problem, not a scaling problem. Most Modbus clients offer a word-order toggle;
flip it before touching anything else.

Similar ambiguity applies to 32-bit integers, 64-bit values and to strings packed two
characters per register.

### Scaling

Registers carry raw integers. A temperature of 124.7 degC is typically transmitted as
`1247` with a documented divisor of 10. Scaling factors live only in the vendor manual
and must be hand-configured in every client. There is no way to discover them, and no
units travel with the value. This is exactly what OPC UA and Sparkplug exist to fix.

## Configuration that matters

### Modbus RTU on RS-485

- **Baud, parity, stop bits, data bits** must match on every node. 19200 8N1 and
  9600 8E1 are both common defaults; a mismatch produces garbage or silence.
- **Unit IDs must be unique** on the bus. Two devices answering as ID 1 produce
  corrupted frames that look like noise.
- **Termination**: 120 ohm resistors at both physical ends of the bus only. Over-
  terminating and under-terminating both cause reflections and intermittent CRC
  errors — the classic "works at 9600, fails at 115200" symptom.
- **Bias resistors** hold the idle line in a defined state; without them some
  transceivers see false start bits.
- **Topology**: daisy chain. Star and stub topologies work until they do not,
  typically on a hot afternoon.
- **Silent interval**: frames are delimited by 3.5 character times of silence, so
  an interval that is too short merges frames.
- **Turnaround delay**: half-duplex RS-485 needs the client to stop driving the line
  before the server replies. Devices with slow transceivers need an added delay.

### Modbus TCP

- **Port 502** by default.
- **Unit ID** is still present in the MBAP header. For a native Ethernet device it is
  usually ignored or must be 1 or 255; for a **gateway** bridging to serial, it selects
  the downstream RTU device. Getting this wrong is a common gateway failure.
- **One request at a time per connection** for most devices. Pipelining several
  outstanding transactions, though allowed by the Transaction Identifier field, breaks
  many embedded implementations.
- **Connection limits** are low — often 1 to 4 concurrent sockets. A polling tool left
  running on an engineer's laptop can lock out the SCADA system.
- **No CRC** at Modbus level; TCP checksums are relied on.

## Security posture

Modbus has **no security whatsoever**. No authentication, no authorisation, no
integrity, no encryption. Any host that can reach port 502 can write any register,
including ones that start a motor or change a setpoint. Function code 8 (diagnostics)
can in some implementations force a listen-only mode or restart communications.

Modbus/TCP Security (a later addendum adding TLS on port 802 with X.509) exists but
is rarely implemented in the field.

Therefore protection must be external:

- Put Modbus devices on an isolated VLAN or segment with no route from general IT.
- Use a firewall that permits only the specific client IPs to reach port 502.
- Prefer a **data diode or read-only gateway** where only monitoring is needed — this
  removes the write risk structurally rather than by policy.
- Use a protocol-aware firewall if available, to allow read function codes and block
  write function codes.
- Never expose port 502 to the internet. Internet-wide scans find these constantly,
  and they are unauthenticated by design.

## When to use it

**Good for:** reading simple instruments — power meters, flow meters, temperature
controllers, VFDs, inverters; small point counts; situations where the device offers
nothing else; quick integration where a data model is unnecessary.

**Bad for:** anything needing semantics, discovery or timestamps; high tag counts
(register maps become unmanageable spreadsheets); event-driven data, since Modbus can
only poll; writing to safety-relevant outputs over a shared network; multi-consumer
access to one device, given the tiny connection limits.

## Pitfalls

- **The off-by-one.** Verify against a known register before anything else.
- **Word order on 32-bit values.** Verify against a known value before anything else.
- **Polling too fast.** A meter that integrates over 250 ms will return the same value
  if polled at 50 ms, and may slow down or stop responding under the load.
- **Requesting a span that crosses an unimplemented gap.** Reading registers 100-120
  fails entirely with exception 2 if 110 does not exist. Read contiguous implemented
  blocks.
- **Exceeding 125 registers in one read.** The limit comes from the 253-byte PDU; many
  clients do not check it and simply produce a malformed frame.
- **Trusting a stale value.** Modbus has no quality flag and no timestamp. If a device
  stops updating internally but still answers, you will read the last value forever
  and never know. Add a heartbeat or counter register to your poll and alarm on it
  failing to change.
- **Assuming the gateway's unit ID mapping is transparent.** Serial-to-TCP gateways
  vary in whether they map unit ID, port number or IP alias to the downstream device.

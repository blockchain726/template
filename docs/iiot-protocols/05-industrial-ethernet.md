# 05 — Industrial Ethernet

## The core problem

Standard Ethernet with TCP/IP is excellent at throughput and hopeless at determinism.
Collisions are gone with switches, but queuing delay, switch buffering, TCP
retransmission and OS scheduling all add unbounded jitter. A servo drive that needs a
new position setpoint every 250 microseconds, with less than a microsecond of
variation, cannot use it as-is.

Each industrial Ethernet protocol solves this differently, and the approach determines
what hardware you need and what the network can do:

| Approach | How determinism is achieved | Examples |
|---|---|---|
| Prioritised frames on standard switches | VLAN priority, small cyclic frames, bypass TCP/IP | PROFINET RT, EtherNet/IP |
| Time-scheduled transmission | Frames sent in reserved time slots, synchronised clocks | PROFINET IRT, Sercos III, TSN |
| Summation frame / on-the-fly processing | One frame passes all nodes; each reads and writes in transit | EtherCAT |
| Time-slotted master control | Master grants each node an exclusive send window | POWERLINK |

## PROFINET

PROFINET (PROFIBUS & PROFINET International) is dominant in Siemens-centric plants
and across much of Europe.

### Conformance and real-time classes

| Class | Mechanism | Cycle time | Hardware needed |
|---|---|---|---|
| **NRT** | TCP/UDP/IP | > 100 ms | Any Ethernet |
| **RT** (Class A/B) | EtherType `0x8892`, VLAN priority, no IP stack | 1-10 ms | Standard managed switch |
| **IRT** (Class C) | Scheduled transmission, synchronised clocks, reserved bandwidth | 31.25 us - 1 ms | PROFINET-aware switch ASIC |

Conformance Classes A, B, C and D describe certified capability levels; CC-C is
required for IRT, and CC-D covers TSN-based PROFINET.

### How it works

- **Device description** is a **GSDML** file (XML). It declares modules, submodules,
  I/O data sizes and parameters. The engineering tool uses it to build the
  configuration; without the right GSDML version you cannot commission the device.
- **Addressing** uses a device **name** (not primarily an IP) assigned via **DCP**
  (Discovery and Configuration Protocol). The controller resolves name to MAC at
  startup. A replaced device must be given the correct name or the controller will not
  recognise it — this is the most common PROFINET field task.
- **Cyclic I/O** exchanges a fixed process image each cycle. The controller writes
  outputs, the device writes inputs; both continue regardless of change.
- **Acyclic services** (parameter read/write, diagnostics, alarms) use UDP/IP on the
  same wire.
- **PROFIsafe** carries safety data (up to SIL 3) inside the standard channel using a
  safety CRC and watchdog — a "black channel" approach, so the underlying network need
  not be safety-certified.
- **Media Redundancy Protocol (MRP)** gives ring topology recovery, typically in tens
  of milliseconds; **MRPD** achieves bumpless redundancy for IRT.

## EtherNet/IP

EtherNet/IP (ODVA) is dominant in North America and in Rockwell/Allen-Bradley
installations. The "IP" means **Industrial Protocol**, not Internet Protocol.

- Built on **CIP** (Common Industrial Protocol), the same application layer used by
  DeviceNet and ControlNet. Devices are modelled as **objects** with classes,
  instances and attributes.
- **Explicit messaging** uses TCP port 44818 for configuration, diagnostics and
  non-time-critical reads — request/response, higher overhead.
- **Implicit messaging** uses UDP port 2222 for cyclic I/O, with a configured
  **Requested Packet Interval (RPI)**. Typical RPI is 1-20 ms.
- **Device description** is an **EDS** file.
- **CIP Safety** provides SIL 3 safety; **CIP Sync** uses IEEE 1588 for time
  synchronisation; **CIP Motion** adds motion control.
- **CIP Security** adds authentication and integrity to CIP — relatively recent and
  not yet universally supported.

A frequent planning error is sizing multicast traffic. Implicit messaging has
historically used multicast for producer-to-consumer I/O, which floods switches that
lack IGMP snooping. Enable IGMP snooping with a querier, or configure unicast
connections where the hardware allows.

## EtherCAT

EtherCAT (EtherCAT Technology Group, originally Beckhoff) takes a fundamentally
different approach and achieves the best cycle times with ordinary cabling.

### The summation frame

The master sends **one** Ethernet frame that passes through every slave in the
logical ring. Each slave reads its own output data and inserts its input data **as the
frame passes through the hardware**, with a delay of nanoseconds. The frame returns to
the master containing the complete updated process image.

Consequences:

- Extremely efficient: one frame can serve hundreds of nodes, so bandwidth use is
  near-optimal and 100 Mbit/s is usually ample.
- Cycle times of 50-100 microseconds for substantial node counts are routine.
- **Distributed Clocks** synchronise slaves to well under 1 microsecond, which is what
  makes coordinated multi-axis motion possible.
- Slaves need an EtherCAT slave controller ASIC; you cannot make an EtherCAT slave in
  software on a normal NIC. The master, by contrast, can be pure software on a standard
  NIC.
- It uses EtherType `0x88A4` with no IP. It is **not routable** and cannot cross a
  normal L3 boundary. `EoE` (Ethernet over EtherCAT) tunnels normal traffic when
  needed.
- Topology is physically flexible (line, tree, star with junctions) but always a
  logical ring. Cable redundancy is available by closing the ring back to a second
  master port.

**Device description** is an **ESI** file (XML). **FSoE** (Fail Safe over EtherCAT)
carries SIL 3 safety data.

## POWERLINK and Sercos III

**Ethernet POWERLINK** (B&R / EPSG) uses a managing node that polls each controlled
node in a strictly scheduled cycle, so no two nodes transmit simultaneously and
collisions cannot occur. It is open source on the master side, achieves cycle times
down to around 100-200 microseconds, and runs on standard Ethernet hardware.

**Sercos III** combines a telegram-based real-time channel with an unused-bandwidth
channel for IP traffic, reaching 31.25 microsecond cycles. It is strong in machine
tools and motion applications.

Both are more specialised than PROFINET/EtherNet/IP/EtherCAT; choose them when the
machine builder or drive vendor already standardises on them.

## TSN: the convergence story

**Time-Sensitive Networking** is a set of IEEE 802.1 amendments that push determinism
into standard Ethernet, so that control traffic and ordinary IT traffic can share
infrastructure safely.

Key pieces:

| Standard | Function |
|---|---|
| 802.1AS | Time synchronisation (a profile of IEEE 1588 / gPTP) |
| 802.1Qbv | Time-aware shaper — scheduled transmission gates per queue |
| 802.1Qbu / 802.3br | Frame pre-emption — a long frame yields to an urgent one |
| 802.1Qav | Credit-based shaper for bandwidth reservation |
| 802.1Qcc | Centralised configuration of streams |
| 802.1CB | Frame replication and elimination for reliability |

TSN is a *layer-2 toolbox*, not a protocol in itself. PROFINET over TSN, EtherNet/IP
over TSN and OPC UA PubSub over TSN all exist. The promise is one physical network
carrying motion control, process data and video. The practical caveat is that TSN
requires TSN-capable switches throughout the path and careful central scheduling; a
single non-TSN switch in the middle voids the guarantees.

## Choosing between them

In practice the decision is usually made for you:

- **Your PLC vendor decides.** Siemens leads to PROFINET; Rockwell to EtherNet/IP;
  Beckhoff and most motion-centric machine builders to EtherCAT.
- **Your drives decide.** If the servo drives you need only speak EtherCAT, that
  settles the machine network.
- **Your customer's plant standard decides.** Many large manufacturers mandate one
  protocol for maintainability, and that is a legitimate engineering reason.

If genuinely free to choose: EtherCAT for motion and the fastest cycles; PROFINET for
large plant-wide installations with mixed vendors in Europe; EtherNet/IP in North
America or an existing Rockwell estate.

## Security posture

Fieldbus protocols at this level were designed for physically isolated networks and
their native security is minimal:

- Cyclic frames are unauthenticated. Anything on the segment that can emit the right
  EtherType can inject I/O data.
- PROFINET DCP lets any host on the segment rename or re-address devices. A DCP
  "flash LED" or "reset to factory" command needs no credentials.
- EtherCAT has no access control at all; physical access to the ring is total control.
- Safety layers (PROFIsafe, CIP Safety, FSoE) protect against **random faults and
  corruption**, not against a deliberate attacker. They are functional safety, not
  cybersecurity. This distinction matters and is often blurred in vendor material.

Controls that actually work here are architectural: strict segmentation, with the
machine network behind a controller or firewall and never bridged to IT; physical
security of panels and switch ports; disabling unused switch ports; and restricting
engineering access to a hardened, monitored jump host. Add CIP Security or PROFINET
security extensions where the hardware supports them, but do not rely on them as a
substitute for segmentation.

## Pitfalls

- **Using an unmanaged switch for RT traffic.** No VLAN priority handling means no
  prioritisation; IRT will not work at all.
- **Connecting a laptop to the machine network to "just have a look".** Windows
  broadcast traffic and discovery chatter have stopped production lines.
- **Mixing protocols on one segment without separation.** PROFINET and EtherNet/IP can
  coexist electrically, but multicast storms and bandwidth contention will eventually
  break the slower budget.
- **Replacing a device without setting its device name (PROFINET) or station alias.**
  The controller will not adopt it.
- **Forgetting that EtherCAT cable order is topology.** Moving a slave to a different
  port changes its position in the ring and therefore its address.
- **Ignoring IGMP snooping with EtherNet/IP multicast.** Works fine on the bench with
  three nodes; floods the network at forty.
- **Assuming GSDML/EDS/ESI files are interchangeable between firmware versions.** They
  are version-matched; a mismatch shows up as cryptic configuration errors.

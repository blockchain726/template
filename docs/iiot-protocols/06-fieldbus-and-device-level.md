# 06 — Fieldbus & Device Level

These are the protocols closest to the physical process. Many predate Ethernet and
remain installed in enormous numbers — a refinery or water utility commissioned in
1998 is still running, and its instruments still speak these. Any realistic IIoT
project is partly an exercise in extracting data from them.

## HART

**HART** (Highway Addressable Remote Transducer) is the cleverest piece of
backward-compatibility engineering in industrial instrumentation.

The installed base of process transmitters uses a **4-20 mA current loop**: the
transmitter varies current in proportion to the measurement, and this analogue signal
is simple, robust and intrinsically safe. HART superimposes a **frequency-shift-keyed
digital signal** (1200 Hz and 2200 Hz, 1200 bit/s) on top of the same two wires. The
FSK signal averages to zero current, so the analogue reading is undisturbed.

The result: a 1990s control system keeps reading 4-20 mA while a modern asset
management tool simultaneously reads the device's serial number, calibration data,
secondary variables and diagnostics over the same pair.

- Roughly 2-3 digital updates per second — not a control-rate protocol.
- Up to four process variables plus device status per device.
- **Multidrop mode** allows up to 15 devices digitally on one pair, but the analogue
  current is then fixed at 4 mA and unusable — rarely used.
- **HART-IP** carries HART payloads over Ethernet/UDP, which is the usual route for
  getting HART diagnostics into an IIoT platform.
- Device capability is described by a **DD** (Device Description) or **FDI** package.

**Why this matters for IIoT:** a vast amount of diagnostic data already exists in
installed transmitters and is simply never read, because the DCS only samples the
analogue value. A HART multiplexer or a HART-capable I/O card plus HART-IP is often
the cheapest possible condition-monitoring project — no new sensors required.

## PROFIBUS

| Variant | Use | Physical layer |
|---|---|---|
| **PROFIBUS DP** | Factory automation, fast I/O | RS-485, 9.6 kbit/s - 12 Mbit/s |
| **PROFIBUS PA** | Process industry instrumentation | MBP, 31.25 kbit/s, bus-powered, intrinsically safe |

- Token-passing between masters, polling of slaves; cycle times of a few milliseconds
  for modest node counts on DP.
- Device description is a **GSD** file.
- **PA** carries power and data on the same pair and supports hazardous areas, which
  is why it persists in chemical and oil-and-gas plants.
- Baud rate limits cable length strictly: 12 Mbit/s allows only 100 m per segment,
  while 9.6 kbit/s allows 1200 m. Repeaters extend this but add delay.
- **Termination is active** and requires powered terminators at segment ends; an
  unpowered terminator is a frequent cause of flaky PROFIBUS segments.

Migration path is PROFINET, usually via a PROFIBUS-to-PROFINET proxy that keeps the
existing field wiring.

## Foundation Fieldbus

**FOUNDATION Fieldbus H1** (31.25 kbit/s, bus-powered, intrinsically safe) competes
with PROFIBUS PA in process plants. Its distinguishing idea is **control in the
field**: function blocks (PID, AI, AO) execute inside the instruments themselves, and
a loop can keep running even if the host controller is lost. A scheduled,
publisher/subscriber link layer provides deterministic block execution.

This is powerful but makes the configuration genuinely complex, and the commissioning
skill set is specialised. New installations increasingly choose PROFIBUS PA, HART or
Ethernet-APL instead.

## Ethernet-APL

**Ethernet-APL** (Advanced Physical Layer) is the significant recent development for
process industries: 10 Mbit/s Ethernet over a single twisted pair, delivering power
to the device, with cable runs to 1000 m and intrinsic safety for Zone 0 / Division 1
hazardous areas.

It lets process instruments speak Ethernet protocols — typically **PROFINET** or
**OPC UA/HART-IP** — directly, with the same two-wire installation practice and
hazardous-area approvals the industry already uses. For greenfield process plants it
removes the historical reason for separate fieldbus physical layers, and it is the
main reason to expect OPC UA to reach down to individual transmitters over the next
decade.

## CAN-based protocols

**CAN** (Controller Area Network) is a robust multi-master serial bus with
collision resolution by message priority and strong error detection. CAN itself
defines only layers 1-2; higher-layer protocols add meaning.

### CANopen

- Device profiles standardise how classes of device (drives, I/O modules, encoders)
  expose their data.
- The **Object Dictionary** indexes all parameters (16-bit index, 8-bit subindex).
- **PDOs** (Process Data Objects) carry real-time data, up to 8 bytes, unconfirmed.
- **SDOs** (Service Data Objects) provide confirmed access to any dictionary entry for
  configuration.
- **NMT** (Network Management) handles state (pre-operational, operational, stopped)
  and heartbeats.
- Common in machinery, medical devices, off-highway vehicles and maritime.

### SAE J1939

- CAN-based standard for heavy-duty vehicles: trucks, buses, agricultural and
  construction machines, and many generator sets.
- Data is organised into **PGNs** (Parameter Group Numbers) containing **SPNs**
  (Suspect Parameter Numbers), with standardised definitions for engine speed, coolant
  temperature, fuel rate, diagnostic trouble codes and so on.
- 250 kbit/s classically, 500 kbit/s increasingly.
- For IIoT this is the protocol behind most telematics: a J1939 reader on a generator
  or a fleet vehicle yields standardised engine data without vendor negotiation.

## IO-Link

**IO-Link** (IEC 61131-9) is point-to-point digital communication over the existing
three-wire sensor cable, between a sensor/actuator and an **IO-Link master**. The
master then connects upward via PROFINET, EtherNet/IP or EtherCAT.

Why it is genuinely useful:

- A simple proximity or photoelectric sensor gains **parameters, diagnostics and
  identity** — temperature, operating hours, signal quality, manufacturer and serial
  number — over the same cheap unshielded cable.
- **Automatic parameter download**: replace a failed sensor and the master writes its
  configuration automatically. No hand-setting of potentiometers or teach buttons.
- Device description is an **IODD** file.
- Cable lengths up to 20 m, unshielded, standard M12 connectors.

IO-Link is one of the highest-value, lowest-friction additions to an existing machine
for condition monitoring, because it reuses wiring already in place.

## AS-Interface

**AS-i** (Actuator Sensor Interface) is a two-wire bus carrying both power and data
for simple binary devices, with a distinctive yellow flat cable pierced by
self-sealing connectors. Up to 62 slaves, cycle time around 5-10 ms. It is cheap and
quick to install for large numbers of simple on/off devices, and typically appears
behind a gateway to PROFINET or EtherNet/IP.

## BACnet and building systems

**BACnet** (ASHRAE 135, also ISO 16484-5) is the dominant building automation
protocol: HVAC, lighting, access control, metering.

- Object-oriented model: Analog Input, Binary Output, Schedule, Trend Log and similar
  standard object types with defined properties.
- **BACnet/IP** (UDP port 47808) is now most common; BACnet MS/TP over RS-485 is widely
  installed for field devices.
- Supports change-of-value subscriptions, scheduling, trending and alarming natively.

It matters for IIoT because facility energy data — chillers, air handling, submetering
— usually lives in BACnet while production data lives in PROFINET or Modbus. Any
serious plant energy-efficiency project has to bridge both.

## DNP3 and utility protocols

**DNP3** (IEEE 1815) dominates electric utilities, water and wastewater SCADA in North
America, with **IEC 60870-5-101/104** filling the same role in Europe.

Features that distinguish it from Modbus:

- **Timestamped events with sequence-of-events buffering.** A device records *what
  changed and when*, buffers it, and reports on request — so a brief outage does not
  lose the event history. This is essential for fault analysis on a power network.
- **Unsolicited responses**: the outstation can report spontaneously rather than
  waiting to be polled.
- **Data quality flags** accompany values.
- **DNP3 Secure Authentication (SAv5)** adds challenge-response authentication — one
  of the few retrofitted security layers in this group that is actually deployed.

**IEC 61850** is the substation automation standard, worth knowing for its
architecture: a rich object model with standardised logical nodes, plus **GOOSE**
messages (multicast layer-2, for protection trips in under 4 ms) and **sampled
values** for digitised current and voltage waveforms.

## Getting data out of legacy buses

The realistic options, roughly in order of preference:

1. **Read it from the controller.** The PLC or DCS already polls the fieldbus. Exposing
   an OPC UA server or Modbus TCP slave on the controller is usually the least
   invasive route, and preserves the engineering that is already correct.
2. **Protocol gateway.** A dedicated device bridging PROFIBUS, CANopen, HART or AS-i to
   Modbus TCP, OPC UA or MQTT. Cheap and effective; adds a translation hop and a device
   to maintain.
3. **Tap the bus directly.** A passive listener on RS-485 or CAN can read traffic
   without disturbing it. Attractive because it cannot write, but you must reverse the
   address and scaling conventions yourself.
4. **Add parallel instrumentation.** Where the existing system cannot be touched —
   validated pharmaceutical or safety-related installations — fitting independent
   sensors with their own IIoT path is sometimes the only permissible option.

Whichever route, do not disturb the control network to gather monitoring data. Adding
a polling client to a loaded PROFIBUS segment can extend its cycle time enough to
affect control.

## Pitfalls

- **Adding a polling master to a live fieldbus.** Token and cycle budgets are finite;
  monitoring traffic can degrade control.
- **Assuming HART data is available.** It requires HART-capable I/O cards or a
  multiplexer. Many installations have HART instruments wired to plain analogue inputs,
  so the digital channel exists but nothing is listening.
- **Ignoring intrinsic safety requirements.** In hazardous areas, energy limits are
  certified. Connecting a non-certified gateway into an IS circuit invalidates the
  area classification — a safety and legal issue, not a technical preference.
- **Mismatched GSD/EDS/IODD versions** after a device replacement.
- **Unpowered or missing bus terminators** on PROFIBUS and RS-485 segments.
- **Treating J1939 or CANopen addresses as fixed.** Node IDs and PGN availability vary
  by engine or device manufacturer and model year, despite the standard.

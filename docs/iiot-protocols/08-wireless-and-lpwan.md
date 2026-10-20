# 08 — Wireless & LPWAN

## The trade-off that governs every choice

You cannot have long range, high data rate and low power consumption at once. Every
wireless technology picks two and sacrifices the third. Decide which two you need
before comparing products, because this constraint is physics, not marketing.

| Technology | Range | Data rate | Power | Topology | Spectrum |
|---|---|---|---|---|---|
| WirelessHART | 10-200 m/hop, mesh | 250 kbit/s | Years on battery | Mesh | 2.4 GHz ISM |
| ISA100.11a | 10-200 m/hop, mesh | 250 kbit/s | Years | Mesh | 2.4 GHz ISM |
| Zigbee | 10-100 m/hop, mesh | 250 kbit/s | Years | Mesh | 2.4 GHz, 868/915 MHz |
| Thread | 10-100 m/hop, mesh | 250 kbit/s | Years | Mesh, IPv6 | 2.4 GHz |
| BLE | 10-100 m | 125 kbit/s - 2 Mbit/s | Years | Star, mesh | 2.4 GHz |
| Wi-Fi (802.11) | 30-100 m | 10 Mbit/s - 1 Gbit/s+ | Mains or short battery life | Star | 2.4/5/6 GHz |
| LoRaWAN | 2-15 km | 0.3-50 kbit/s | 5-10 years | Star of stars | Sub-GHz ISM |
| NB-IoT | Cellular coverage | 20-250 kbit/s | 5-10 years | Star (cellular) | Licensed |
| LTE-M | Cellular coverage | 300 kbit/s - 1 Mbit/s | 3-8 years | Star (cellular) | Licensed |
| 5G URLLC | Cellular / private | High | Mains | Star | Licensed / CBRS |

## Industrial process wireless

### WirelessHART (IEC 62591)

The established choice for process instrumentation, and the one to reach for when
retrofitting measurement points in a refinery, chemical plant or tank farm.

- **Self-organising, self-healing mesh.** Every mains- or battery-powered field device
  can route for its neighbours. Add a device and the mesh incorporates it; lose one and
  traffic reroutes.
- **TDMA with 10 ms time slots and channel hopping** across 15 channels. This is the
  key reliability mechanism: a narrowband interferer (or a Wi-Fi access point) blocks
  one channel, and the hopping sequence simply avoids it. Field reliability above
  99.9 % is routinely achieved in environments full of metal and RF noise.
- **Blacklisting** permanently excludes channels that conflict with plant Wi-Fi.
- Carries the **same HART command set** as wired HART, so existing asset management
  tools and device descriptions work unchanged — this is the real reason it won in
  process industries.
- Security is mandatory and not optional: AES-128 at both network and session layers,
  with a join key per device and rotating session keys.
- Update rates from 1 s to an hour, configured per device; battery life is driven
  almost entirely by this choice.

### ISA100.11a (IEC 62734)

Technically similar — 2.4 GHz, TDMA, channel hopping, mesh — but built on **6LoWPAN
and IPv6**, making it natively IP-routable, and more flexible in its object model and
slot timing. It supports tunnelling other protocols, including HART and Modbus.

WirelessHART has the larger installed base in process plants; ISA100 appeals where
IPv6 integration or multi-protocol tunnelling matters. Both are credible; the
decision is usually driven by which instrument vendors the site already uses.

## Short-range mesh and personal-area

### Zigbee

IEEE 802.15.4 based mesh with application profiles. Strong in building automation,
lighting control and smart metering. Coordinator, router and end-device roles; end
devices sleep and parent routers buffer for them. Security is AES-128 with a network
key and optional link keys.

Industrially it is less common than WirelessHART because it lacks the mandated channel
hopping and the HART compatibility, but it is inexpensive and well supported.

### Thread

Also 802.15.4, but a **native IPv6 mesh** (6LoWPAN) with no application layer of its
own — Matter and CoAP run on top. Border routers connect it to normal IP networks.
Its appeal is that every node is addressable like any other IP host, so standard
tooling applies. Mostly a building and consumer technology so far, but architecturally
the cleanest of the 802.15.4 family.

### Bluetooth Low Energy

- **Connection-oriented** links for configuration and data exchange, plus
  **advertising** for connectionless broadcast, which is how most asset tags work.
- **GATT** defines services and characteristics — the data model.
- BLE 5.x adds **Coded PHY** (roughly four times the range at reduced rate),
  **2M PHY** (double rate), and **LE Audio**.
- **Direction finding** (AoA/AoD) in BLE 5.1 enables sub-metre indoor positioning,
  which is the basis of most real-time location systems for tools, trolleys and
  people.

Industrial uses: commissioning and configuration via phone or tablet, condition
monitoring sensors on motors and pumps, asset tracking, and operator access control.
Not for control.

### Wi-Fi

Ubiquitous and high bandwidth, with real industrial caveats. Roaming between access
points takes tens to hundreds of milliseconds unless 802.11r/k/v fast transition is
properly configured — fatal for an AGV or crane that must stay connected while moving.
Power consumption rules out battery-powered sensors on anything but a long duty cycle.
The 2.4 GHz band is congested and will collide with Zigbee and WirelessHART unless
channels are planned together.

**Wi-Fi 6/6E** improves determinism meaningfully through OFDMA and scheduled access
(trigger-based uplink), and 6 GHz brings clean spectrum. It is now a reasonable choice
for AGVs and handheld terminals, though still not for closed-loop control.

## LPWAN

### LoRaWAN

- **Chirp spread spectrum** modulation gives an extraordinary link budget: kilometres
  of range, and good penetration into basements, pits and meter cabinets.
- **Star-of-stars**: devices talk to gateways, gateways forward to a network server,
  which routes to an application server. Devices are not addressed individually by
  the radio layer — any gateway that hears an uplink forwards it, and duplicates are
  removed centrally.
- **Device classes**:
  - **Class A** — uplink-initiated, two short downlink windows after each uplink.
    Lowest power; downlink latency is up to the next uplink.
  - **Class B** — scheduled downlink slots synchronised by gateway beacons. Bounded
    downlink latency at moderate power cost.
  - **Class C** — receiver continuously open. Near-instant downlink, mains power
    effectively required.
- **Spreading factor** trades range against airtime: SF12 reaches furthest but
  occupies the channel far longer. **ADR** (Adaptive Data Rate) tunes this per device.
- **Duty cycle limits** are a legal constraint in Europe (typically 1 % per channel in
  EU868). A device cannot simply transmit more often because you want fresher data.
  This is the single most common design mistake in LoRaWAN projects.
- **Security**: AES-128 with two distinct keys — **NwkSKey** for network-layer
  integrity and **AppSKey** for end-to-end payload encryption. The network operator
  cannot read payloads if key management is done properly. **OTAA** (over-the-air
  activation) is strongly preferable to **ABP**, which has replay weaknesses.
- Payloads are a few tens of bytes and **not self-describing**; a decoder per device
  type lives on the application server.

**Good for:** utility metering, tank levels, environmental monitoring, agriculture,
asset presence over a wide campus, anything reporting a few times an hour for years on
a battery.

**Bad for:** anything needing low-latency downlink, firmware updates of meaningful
size, or frequent reporting.

### NB-IoT and LTE-M

Licensed-spectrum cellular, operator-managed, no gateway infrastructure of your own.

- **NB-IoT** — very narrow band, excellent deep-indoor penetration, lowest power, but
  high latency (seconds) and no mobility handover. Best for static meters.
- **LTE-M** (eMTC) — higher rate, lower latency, supports **mobility and voice**, so
  the right pick for moving assets and anything interactive.
- Both use **PSM** (Power Saving Mode) and **eDRX** to sleep for hours while keeping
  their network registration, which is what delivers multi-year battery life.
- Management is typically **LwM2M over CoAP** (see [07](07-coap-amqp-dds.md)).

The practical considerations are commercial rather than technical: carrier coverage at
the exact installation point, module certification per region, roaming agreements for
assets that cross borders, and the fact that 2G/3G sunsets have stranded a generation
of older cellular devices. Verify coverage by survey, not by coverage map.

### Private 5G and URLLC

**5G URLLC** targets 1 ms air latency with very high reliability, and **network
slicing** allows an isolated virtual network for control traffic. With CBRS in the US
or local licences elsewhere, a plant can run its own 5G network.

This is credible and deploying now for AGV fleets, large-area asset tracking,
mobile robots and remote operation of mining and port equipment — applications where
cables are impossible and Wi-Fi roaming is inadequate. It is expensive and requires
genuine RF engineering, so it suits large sites with mobility problems rather than
general sensor connectivity.

## Coexistence: planning the 2.4 GHz band

WirelessHART, ISA100, Zigbee, BLE and Wi-Fi all share 2.4 GHz. Uncoordinated, they
degrade each other.

Practical measures:

- Restrict Wi-Fi to channels 1, 6 and 11 and allocate the remaining spectrum to
  802.15.4 channels that do not overlap (15, 20, 25, 26).
- Blacklist the channels used by plant Wi-Fi in the WirelessHART or ISA100 manager.
- Move high-bandwidth Wi-Fi to 5 GHz or 6 GHz entirely, leaving 2.4 GHz for sensors.
- Survey before and after installation; RF environments change when machinery,
  racking and liquid-filled vessels move.
- Remember that metal structures, dense pipework and full vessels attenuate heavily —
  a link that works on an empty tank may fail when it is full.

## Pitfalls

- **Ignoring LoRaWAN duty cycle limits** and designing a reporting interval that is
  not legal in your region.
- **Choosing NB-IoT for a mobile asset.** It has no handover; the device drops and
  must re-register.
- **Specifying battery life from the datasheet headline.** Real life depends on report
  interval, spreading factor or data rate, retries, and temperature. Cold storage
  roughly halves many chemistries' usable capacity.
- **Deploying 2.4 GHz mesh without a Wi-Fi channel plan.**
- **Assuming a wireless mesh will self-heal around any failure.** Mesh needs
  redundant neighbours; a device at the end of a long chain has no alternative path,
  and WirelessHART managers will report poor path diversity if you look.
- **Forgetting antenna placement is engineering.** Mounting a radio inside a metal
  enclosure, or flat against a steel beam, loses most of the link budget regardless of
  protocol.
- **No plan for key provisioning at scale.** Join keys and device credentials for a
  thousand devices need a managed process, not a spreadsheet.

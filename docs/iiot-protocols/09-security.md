# 09 — Security

## Why OT security is not IT security with different cables

The priorities invert. IT security classically ranks **confidentiality, integrity,
availability**. OT ranks **safety, availability, integrity, confidentiality** — and
safety sits above everything, because the failure mode is not a data breach but an
injured person or a destroyed asset.

Practical consequences that surprise IT teams:

- **You often cannot patch.** A controller running a validated pharmaceutical process
  or a 20-year-old turbine governor may have no vendor patch, and changing it may
  require requalification costing more than the plant earns in a week.
- **You cannot reboot to apply updates.** A continuous process may run for 18 months
  between planned shutdowns.
- **Active scanning can cause outages.** Many embedded devices have fragile network
  stacks; an ordinary Nmap scan has halted PLCs. Use passive monitoring or
  OT-aware scanners with explicit vendor approval.
- **Availability beats confidentiality.** An authentication mechanism that locks out a
  legitimate operator during an emergency is a safety hazard, not a security control.
- **Lifetimes are decades.** Equipment specified today will still be running when the
  cryptography chosen for it is obsolete. Plan for algorithm replacement.

## IEC 62443

**IEC 62443** is the reference standard for industrial automation and control system
security. Its structure is worth knowing because it provides the vocabulary used in
procurement and audit.

| Part group | Covers |
|---|---|
| 62443-1-x | Concepts, terminology, models |
| 62443-2-x | Policies and procedures — security programme, patch management, service providers |
| 62443-3-x | System level — risk assessment, system design, security levels |
| 62443-4-x | Component level — secure development lifecycle and technical requirements for products |

### Zones and conduits

The central design concept. Group assets with common security requirements into a
**zone**; every communication path between zones is a **conduit** that is explicitly
defined and controlled. There are no undeclared paths.

This is how you make a flat, unsegmented plant network tractable: enumerate zones,
enumerate the conduits you actually need, then deny everything else.

### Security Levels

| SL | Protects against |
|---|---|
| SL 1 | Casual or coincidental violation |
| SL 2 | Intentional violation using simple means, low motivation |
| SL 3 | Intentional violation using sophisticated means, moderate resources |
| SL 4 | Intentional violation using sophisticated means, extended resources |

Target SLs are assigned per zone from a risk assessment. Most manufacturing aims at
SL 2, with SL 3 for safety-instrumented or high-consequence zones. Note that
**SL 3-4 is not reachable with the native capability of most protocols in this
collection** — it requires compensating architecture.

## The Purdue model as a segmentation plan

| Level | Contents | Trust |
|---|---|---|
| 5 | Enterprise network, internet | Untrusted |
| 4 | Business / site IT | Low |
| 3.5 | **DMZ** — historian replica, patch server, jump host, broker | Mediation boundary |
| 3 | Site operations: MES, central historian, engineering workstations | Medium |
| 2 | Supervisory: SCADA servers, HMIs | High |
| 1 | Control: PLCs, DCS controllers, safety systems | Critical |
| 0 | Field: sensors, actuators, drives | Critical |

The rule that matters most: **no direct traffic between Level 4 and Levels 0-2.**
Everything crosses through Level 3.5, where it can be brokered, inspected, logged and
rate-limited.

In concrete terms, this is why the standard IIoT pattern is an **edge gateway in the
DMZ** that reads from the control network and publishes outbound to the cloud, rather
than a cloud service reaching into the plant. Outbound-only connections from a
mediated zone are vastly easier to secure than inbound ones.

## Protocol security posture at a glance

| Protocol | AuthN | Integrity | Encryption | Verdict |
|---|---|---|---|---|
| Modbus RTU/TCP | None | CRC only (not cryptographic) | None | Segment it; never expose |
| PROFINET | None for cyclic data | None | None | Rely on segmentation |
| EtherNet/IP | Optional (CIP Security) | With CIP Security | With CIP Security | Enable if supported |
| EtherCAT | None | None | None | Physical security is the control |
| DNP3 | SAv5 available | Yes with SAv5 | TLS variants | Enable SAv5 |
| BACnet | Weak historically | BACnet/SC adds TLS | BACnet/SC | Migrate to BACnet/SC |
| MQTT | TLS + credentials | TLS | TLS | Good when configured; ACLs essential |
| OPC UA | X.509 mutual + user tokens | Per-message signing | Per-message encryption | Strongest native model |
| CoAP | DTLS / OSCORE | Yes | Yes | Good; PSK management is the work |
| AMQP 1.0 | SASL + TLS | TLS | TLS | Good |
| DDS | DDS Security plugins | Yes | Yes | Good but must be enabled |
| LoRaWAN | AES-128, OTAA | Yes | Yes (AppSKey end-to-end) | Good; use OTAA, not ABP |
| WirelessHART | AES-128, mandatory | Yes | Yes | Good by default |

The pattern is clear: **control-layer protocols have essentially no native security,
and IIoT-layer protocols have decent security that is frequently left switched off.**

## TLS and PKI in an OT context

TLS is the workhorse, but industrial deployment has specific traps.

- **Certificate expiry is an availability risk.** An expired certificate stops
  communication exactly as effectively as a cut cable, and it will happen at an
  inconvenient moment. Inventory every certificate with its expiry date, alert 90 days
  ahead, and rehearse rotation. For OPC UA at scale, a GDS automates issuance and
  renewal.
- **Devices with no real-time clock cannot validate expiry.** A device that boots
  thinking it is 1970 will reject a valid certificate. Provide NTP, or accept the
  limitation deliberately.
- **Verify the chain and the hostname.** Disabling verification "temporarily during
  commissioning" is how most MQTT and OPC UA deployments end up with no meaningful
  authentication. If a device cannot validate properly, record it as an accepted risk
  rather than quietly turning the check off.
- **Prefer client certificates over passwords for fixed devices.** They cannot be
  shoulder-surfed, shared or reused across sites, and revocation is centralised.
- **Plan for crypto-agility.** Equipment installed now will outlive current algorithm
  recommendations; favour devices whose firmware can be updated and whose trust stores
  are manageable.

## Secure remote access

Vendor remote access is both operationally necessary and the most common serious
exposure. What works:

- Access brokered through a **jump host in the DMZ**, never a direct tunnel to a
  controller.
- **Multi-factor authentication** for every human.
- **Operator-approved, time-limited sessions** — access enabled on request for a
  window, then disabled. Ideally a physical key switch or an HMI control that an
  operator must actively grant.
- **Session recording** for audit and for understanding what changed.
- **No persistent vendor VPNs** with standing credentials and no monitoring. Cellular
  modems quietly fitted to machines by vendors are a recurring finding in OT
  assessments and bypass the entire network architecture.

## Monitoring that does not break things

- **Passive network monitoring** via a SPAN or mirror port, or a network tap, is the
  default OT-safe approach: full visibility, zero injected traffic.
- **Protocol-aware deep packet inspection** gives real value here, because industrial
  protocols are predictable. A Modbus write function code to a device that has only
  ever been read, or a PROFINET DCP reset command, is a strong signal — far clearer
  than equivalent anomalies in IT traffic.
- **Asset inventory derived from passive observation** is often the single most useful
  early deliverable, because most sites do not know precisely what is connected.
- **Baseline the normal.** OT traffic is far more regular than IT traffic, which makes
  anomaly detection genuinely effective once a baseline exists.

## A pragmatic priority order

If you are starting with a flat plant network and limited budget:

1. **Inventory.** Passively discover what is connected and what talks to what.
2. **Segment.** Separate OT from IT with a firewall and a DMZ. This single step
   removes more risk than everything else combined.
3. **Remove internet exposure.** Search your public IP ranges for exposed Modbus
   (502), OPC UA (4840), BACnet (47808), VNC and RDP. Close them.
4. **Control remote access.** Brokered, MFA, time-limited, recorded.
5. **Harden the IIoT path.** TLS everywhere, per-device credentials, default-deny
   broker ACLs, outbound-only from the DMZ.
6. **Back up and rehearse recovery.** Controller programs, HMI projects, network
   configuration, and a tested restore procedure. Ransomware recovery in OT depends
   almost entirely on this.
7. **Then** consider detection, patching programmes and SL uplift.

## Pitfalls

- **Confusing functional safety with cybersecurity.** PROFIsafe, CIP Safety and FSoE
  protect against random faults and transmission corruption. They do not stop an
  attacker; a valid safety message with a valid CRC is accepted whoever sent it.
- **Relying on an air gap that does not exist.** USB sticks, engineering laptops,
  vendor modems and dual-homed historians are all paths. Verify, do not assume.
- **Allowing a dual-homed host to bridge zones.** A historian with one NIC in Level 3
  and one in Level 4 is a conduit regardless of what the architecture diagram claims.
- **Leaving OPC UA `SecurityPolicy#None` enabled** after commissioning.
- **Shared credentials across a device fleet.** One extracted key compromises
  everything; rotation becomes impossible.
- **Active vulnerability scanning of production OT** without vendor sign-off and a
  maintenance window.
- **Writing a security policy that operators must bypass to do their jobs.** It will
  be bypassed, and you will have lost both the control and the visibility.

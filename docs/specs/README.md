# Specification & Guidance PDFs

Mirrored reference documents for IIoT work. **Every document here is freely
redistributable** — US Government public-domain publications, OASIS Standards whose
licence permits full redistribution, and IETF RFCs, which may be copied and
distributed without restriction.

Retrieved 2026-10-21. Verify integrity with:

```bash
cd docs/specs && sha256sum -c SHA256SUMS
```

Companion material: the originally written guides in
[`../iiot-protocols/`](../iiot-protocols/) explain how these protocols are used in
practice and how to choose between them. Use those to orient, these for the
normative detail.

---

## NIST — OT security and cryptographic guidance

US Government works. Not subject to copyright protection in the United States
(17 U.S.C. §105), so redistribution is unrestricted.

| Document | Topic | Size |
|---|---|---|
| [NIST SP 800-82r3](nist/NIST.SP.800-82r3-OT-Security.pdf) | **Guide to Operational Technology Security** — the single most useful free OT security reference: architecture, risk management, ICS-specific controls | 8.2 MB |
| [NIST CSWP 29](nist/NIST.CSWP.29-Cybersecurity-Framework-2.0.pdf) | **Cybersecurity Framework 2.0** — the Govern/Identify/Protect/Detect/Respond/Recover functions | 1.4 MB |
| [NIST IR 8183](nist/NIST.IR.8183-CSF-Manufacturing-Profile.pdf) | **CSF Manufacturing Profile** — applies the framework specifically to manufacturing | 1.6 MB |
| [NIST SP 800-52r2](nist/NIST.SP.800-52r2-TLS-Guidelines.pdf) | **TLS selection and configuration** — what to actually enable when securing MQTT, OPC UA or HTTPS | 0.8 MB |

Source: <https://csrc.nist.gov/publications>

**Start with SP 800-82r3.** If you read one document in this directory, read that
one — it covers the architecture and segmentation reasoning that everything else in
OT security depends on.

---

## OASIS — MQTT and AMQP standards

Official OASIS Standard PDFs, unmodified. The OASIS document licence permits copying
and distribution of the complete document provided the copyright notice and licence
section are retained, which they are — these are the original files as published.

| Document | Topic | Size |
|---|---|---|
| [MQTT 5.0](oasis/MQTT-v5.0-OASIS-Standard.pdf) | MQTT 5.0 OASIS Standard — reason codes, session/message expiry, topic aliases, shared subscriptions (137 pp) | 1.8 MB |
| [MQTT 3.1.1](oasis/MQTT-v3.1.1-OASIS-Standard.pdf) | MQTT 3.1.1 OASIS Standard — still the most widely deployed version (81 pp) | 2.2 MB |
| [AMQP 1.0](oasis/AMQP-v1.0-OASIS-Standard.pdf) | AMQP 1.0 core, complete — types, transport, messaging, transactions, security (200 pp) | 0.7 MB |

Source: <https://docs.oasis-open.org/>

Note that **AMQP 1.0 is not AMQP 0-9-1**. This is the OASIS/ISO standard implemented
by Azure Service Bus and Qpid, not the protocol RabbitMQ is built around.

---

## IETF — CoAP and constrained-device RFCs

RFCs may be reproduced and distributed in full without restriction under BCP 78
(RFC 5378).

| Document | Topic | Pages | Size |
|---|---|---|---|
| [RFC 7252](ietf-rfc/RFC7252-CoAP.pdf) | **CoAP** — the core protocol | 112 | 353 KB |
| [RFC 7641](ietf-rfc/RFC7641-CoAP-Observe.pdf) | CoAP **Observe** — push notifications without a broker | 30 | 101 KB |
| [RFC 7959](ietf-rfc/RFC7959-CoAP-Blockwise.pdf) | CoAP **block-wise transfer** — payloads larger than one datagram | 37 | 126 KB |
| [RFC 8323](ietf-rfc/RFC8323-CoAP-over-TCP-TLS-WebSockets.pdf) | CoAP over TCP, TLS and WebSockets — for networks that block UDP | 54 | 164 KB |
| [RFC 8613](ietf-rfc/RFC8613-OSCORE.pdf) | **OSCORE** — object security that survives proxying, where DTLS cannot | 94 | 282 KB |
| [RFC 8428](ietf-rfc/RFC8428-SenML.pdf) | **SenML** — a standard way to express sensor value, unit, time and name | 54 | 170 KB |
| [RFC 8949](ietf-rfc/RFC8949-CBOR.pdf) | **CBOR** — compact binary encoding, the usual CoAP payload format | 83 | 686 KB |
| [RFC 7228](ietf-rfc/RFC7228-Constrained-Node-Networks.pdf) | Terminology for constrained-node networks — defines the device classes everyone cites | 17 | 68 KB |
| [RFC 6690](ietf-rfc/RFC6690-CoRE-Link-Format.pdf) | CoRE Link Format — resource discovery via `/.well-known/core` | 22 | 84 KB |

Source: <https://www.rfc-editor.org/>

### How these RFC PDFs were produced — please read

**RFC 8949 is the official IETF-published PDF.**

The other eight RFCs predate the IETF's PDF publishing and **no official PDF exists**
for them. Those files were generated here by re-typesetting the canonical plain-text
RFC in a monospace font, preserving the original line breaks and form-feed page
boundaries. **The content is unaltered**, but the pagination and typography are not
the IETF's.

For citation, implementation or any formal purpose, use the canonical text, which is
authoritative:

```
https://www.rfc-editor.org/rfc/rfc7252.txt
```

The generator is `scripts/txt2html.pl` in this repository, so the rendering is
reproducible and auditable.

---

## What is deliberately not here

Several specifications central to IIoT are **copyrighted and do not permit
redistribution**. Mirroring them would be infringement, so they are not included.
[`../iiot-protocols/references.md`](../iiot-protocols/references.md) links to each
official source and records whether access is free, registration-gated or paid.

| Not mirrored | Body | Why | Access |
|---|---|---|---|
| OPC UA (IEC 62541) parts | OPC Foundation / IEC | Copyright, no redistribution right | Free browsing after registration at <https://reference.opcfoundation.org/> |
| Modbus Application Protocol | Modbus Organization | Redistribution not granted | Free download from <https://www.modbus.org/specs.php> |
| PROFINET / PROFIBUS / PROFIsafe | PI | Copyright; much is member-only | <https://www.profibus.com/> |
| EtherNet/IP, CIP, CIP Safety | ODVA | Member/paid | <https://www.odva.org/> |
| EtherCAT | ETG | Membership required | <https://www.ethercat.org/> |
| DDS, DDSI-RTPS, DDS Security | OMG | Free to download, redistribution restricted | <https://www.omg.org/spec/DDS/> |
| IEC 62443 (all parts) | IEC / ISA | Paid standard | <https://webstore.iec.ch/> |
| IEC 61850, IEC 60870-5 | IEC | Paid standard | <https://webstore.iec.ch/> |
| BACnet (ASHRAE 135) | ASHRAE | Paid standard | <https://www.ashrae.org/> |
| DNP3 (IEEE 1815) | IEEE / DNP UG | Paid standard | <https://www.dnp.org/> |
| LoRaWAN specifications | LoRa Alliance | Free but terms-gated | <https://lora-alliance.org/> |
| Sparkplug 3.x | Eclipse Foundation | Free; under the Eclipse Foundation Specification Licence — read its terms before redistributing | <https://sparkplug.eclipse.org/specification/> |

Most IEEE 802 standards — including the **TSN** amendments (802.1AS, 802.1Qbv,
802.1Qbu, 802.1CB) — are available at no cost through the IEEE GET Program, though
not under a redistribution licence:
<https://standards.ieee.org/products-programs/ieee-get-program/>

If you need any of the above, download it directly from the body concerned. Several
are free; they simply cannot be re-hosted here.

---

## Licence summary

| Group | Basis for redistribution |
|---|---|
| `nist/` | US Government work, public domain in the US (17 U.S.C. §105) |
| `oasis/` | OASIS document licence — full-document copying permitted with notices retained |
| `ietf-rfc/` | BCP 78 / RFC 5378 — unrestricted copying and distribution of RFCs |

The documents remain the work of their respective authors and bodies. Copyright
notices inside each PDF are intact and unmodified. Nothing in this directory is
authored by this repository, and no endorsement by NIST, OASIS or the IETF is implied.

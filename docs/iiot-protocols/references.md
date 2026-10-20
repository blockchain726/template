# References — Official Specifications & Sources

These guides are originally written. This page tells you where to get the **normative
documents** when you need the authoritative text — for implementing a stack,
certifying a device, or settling an argument.

## Why specifications are not mirrored in this repository

Most industrial protocol specifications are **copyrighted** and their licences do not
permit redistribution. OPC Foundation, ODVA, PROFIBUS & PROFINET International, the
EtherCAT Technology Group, IEC and ISO documents all fall into this category; several
require membership or payment. Re-hosting them in a public repository would be
copyright infringement, so this page links to the official sources instead.

Where a document genuinely is freely redistributable — IETF RFCs, for instance — the
link below goes to the canonical source, which is more trustworthy than a copy anyway.

| Access type | Meaning |
|---|---|
| **Free** | Downloadable at no cost, no registration |
| **Registration** | Free but requires an account |
| **Member/paid** | Requires membership or purchase |

## Core IIoT protocols

| Protocol | Document | Body | Access | Where |
|---|---|---|---|---|
| MQTT 3.1.1 | OASIS Standard | OASIS | Free | <https://docs.oasis-open.org/mqtt/mqtt/v3.1.1/> |
| MQTT 5.0 | OASIS Standard | OASIS | Free | <https://docs.oasis-open.org/mqtt/mqtt/v5.0/> |
| Sparkplug B | Sparkplug Specification 3.x | Eclipse Foundation | Free | <https://sparkplug.eclipse.org/specification/> |
| OPC UA | IEC 62541, all parts | OPC Foundation | Registration | <https://reference.opcfoundation.org/> |
| Modbus | Application Protocol Spec; Modbus over Serial Line | Modbus Organization | Free | <https://www.modbus.org/specs.php> |
| CoAP | RFC 7252 | IETF | Free | <https://www.rfc-editor.org/rfc/rfc7252> |
| CoAP Observe | RFC 7641 | IETF | Free | <https://www.rfc-editor.org/rfc/rfc7641> |
| CoAP Block-wise | RFC 7959 | IETF | Free | <https://www.rfc-editor.org/rfc/rfc7959> |
| CoAP over TCP/TLS | RFC 8323 | IETF | Free | <https://www.rfc-editor.org/rfc/rfc8323> |
| OSCORE | RFC 8613 | IETF | Free | <https://www.rfc-editor.org/rfc/rfc8613> |
| CBOR | RFC 8949 | IETF | Free | <https://www.rfc-editor.org/rfc/rfc8949> |
| SenML | RFC 8428 | IETF | Free | <https://www.rfc-editor.org/rfc/rfc8428> |
| AMQP 1.0 | OASIS Standard / ISO-IEC 19464 | OASIS | Free | <https://docs.oasis-open.org/amqp/core/v1.0/> |
| DDS | DDS 1.4, DDSI-RTPS 2.5, IDL, DDS Security | OMG | Free | <https://www.omg.org/spec/DDS/> |
| LwM2M | OMA LwM2M | OMA SpecWorks | Free | <https://openmobilealliance.org/specifications/lwm2m> |

The OPC Foundation's online reference is genuinely good and free to browse after
registration — start there rather than buying the IEC version unless you need the IEC
document for formal reasons.

## Industrial Ethernet & fieldbus

| Protocol | Body | Access | Where |
|---|---|---|---|
| PROFINET / PROFIBUS / PROFIsafe | PI (PROFIBUS & PROFINET International) | Free profiles, member specs | <https://www.profibus.com/technology/profinet> |
| EtherNet/IP, CIP, CIP Safety, CIP Security | ODVA | Member/paid | <https://www.odva.org/technology-standards/> |
| EtherCAT | EtherCAT Technology Group | Membership (free for most users) | <https://www.ethercat.org/> |
| Ethernet POWERLINK | EPSG | Free | <https://www.ethernet-powerlink.org/> |
| Sercos III | Sercos International | Free overviews | <https://www.sercos.org/> |
| IO-Link | IO-Link Community (within PI) | Free | <https://io-link.com/en/Documents/> |
| HART / WirelessHART | FieldComm Group | Registration/member | <https://www.fieldcommgroup.org/> |
| Foundation Fieldbus | FieldComm Group | Member | <https://www.fieldcommgroup.org/> |
| CANopen | CAN in Automation (CiA) | Free for CiA 301 after registration | <https://www.can-cia.org/standardization/specifications/> |
| SAE J1939 | SAE International | Paid | <https://www.sae.org/standards/> |
| AS-Interface | AS-International | Free overviews | <https://www.as-interface.net/> |
| Ethernet-APL | APL project (PI, ODVA, FieldComm, OPC-F) | Free | <https://www.ethernet-apl.org/> |

## Building, utility & substation

| Protocol | Body | Access | Where |
|---|---|---|---|
| BACnet | ASHRAE / BACnet International | Paid (ASHRAE 135) | <https://www.ashrae.org/technical-resources/bookstore> |
| BACnet overview and resources | BACnet International | Free | <http://www.bacnet.org/> |
| DNP3 | IEEE 1815 / DNP Users Group | Paid | <https://www.dnp.org/> |
| IEC 60870-5 | IEC | Paid | <https://webstore.iec.ch/> |
| IEC 61850 | IEC | Paid | <https://webstore.iec.ch/> |

## Wireless

| Technology | Body | Access | Where |
|---|---|---|---|
| LoRaWAN | LoRa Alliance | Free | <https://resources.lora-alliance.org/technical-specifications> |
| Zigbee / Matter / Thread | Connectivity Standards Alliance | Free | <https://csa-iot.org/all-solutions/> |
| Thread | Thread Group | Registration | <https://www.threadgroup.org/support#specifications> |
| Bluetooth / BLE | Bluetooth SIG | Free | <https://www.bluetooth.com/specifications/specs/> |
| IEEE 802.15.4 | IEEE | Paid (some via GET programme) | <https://standards.ieee.org/> |
| NB-IoT / LTE-M | 3GPP | Free | <https://www.3gpp.org/specifications> |
| WirelessHART (IEC 62591) | IEC / FieldComm | Paid / member | <https://webstore.iec.ch/> |
| ISA100.11a (IEC 62734) | ISA / IEC | Paid | <https://www.isa.org/standards-and-publications> |

## Time-Sensitive Networking

| Standard | Topic | Where |
|---|---|---|
| IEEE 802.1AS | Timing and synchronisation (gPTP) | <https://standards.ieee.org/> |
| IEEE 802.1Qbv | Time-aware shaper | <https://standards.ieee.org/> |
| IEEE 802.1Qbu / 802.3br | Frame pre-emption | <https://standards.ieee.org/> |
| IEEE 802.1CB | Frame replication and elimination | <https://standards.ieee.org/> |
| IEEE 1588 | Precision Time Protocol | <https://standards.ieee.org/> |

Many IEEE 802 standards are available at no cost through the **IEEE GET Program** —
check there before purchasing: <https://standards.ieee.org/products-programs/ieee-get-program/>

## Security

| Document | Topic | Body | Access | Where |
|---|---|---|---|---|
| IEC 62443 (all parts) | Industrial automation security | IEC / ISA | Paid | <https://webstore.iec.ch/> |
| ISA/IEC 62443 overview | Free introductory material | ISA | Free | <https://www.isa.org/standards-and-publications/isa-standards/isa-iec-62443-series-of-standards> |
| NIST SP 800-82 Rev 3 | Guide to OT Security | NIST | **Free** | <https://csrc.nist.gov/pubs/sp/800/82/r3/final> |
| NIST Cybersecurity Framework 2.0 | Risk management framework | NIST | **Free** | <https://www.nist.gov/cyberframework> |
| NIST SP 800-52 Rev 2 | TLS configuration guidance | NIST | **Free** | <https://csrc.nist.gov/pubs/sp/800/52/r2/final> |
| CISA ICS advisories | Live vulnerability advisories | CISA | **Free** | <https://www.cisa.gov/news-events/cybersecurity-advisories> |
| MITRE ATT&CK for ICS | Adversary techniques in ICS | MITRE | **Free** | <https://attack.mitre.org/matrices/ics/> |

**NIST SP 800-82** is the single most useful free document in this table. If you read
only one external reference on OT security, read that one.

## Open-source implementations worth studying

Reading a good implementation often teaches more than the specification.

| Project | Protocol | Notes |
|---|---|---|
| Eclipse Mosquitto | MQTT | Small, readable C broker |
| Eclipse Paho | MQTT | Client libraries in many languages |
| EMQX / VerneMQ / HiveMQ CE | MQTT | Clustered brokers |
| open62541 | OPC UA | C99, permissive licence, widely used in embedded work |
| Eclipse Milo | OPC UA | Java client and server |
| node-opcua | OPC UA | Node.js, good for prototyping |
| libmodbus | Modbus | The reference C library |
| pymodbus | Modbus | Python client and server |
| Eclipse California | CoAP | Java CoAP and DTLS |
| libcoap | CoAP | C implementation |
| Eclipse Cyclone DDS | DDS | Permissive licence, used by ROS 2 |
| eProsima Fast DDS | DDS | Default ROS 2 middleware |
| SOEM / SOES | EtherCAT | Simple Open EtherCAT Master and Slave |
| Telegraf | Many | Input plugins for Modbus, MQTT, OPC UA — fast way to prototype a pipeline |

## Tools for diagnosis

| Tool | Use |
|---|---|
| Wireshark | Dissectors for Modbus, PROFINET, EtherCAT, EtherNet/IP, MQTT, DNP3, BACnet and more |
| UaExpert | The de facto OPC UA client for browsing and testing |
| MQTT Explorer / MQTTX | Topic tree visualisation and manual publish/subscribe |
| modpoll / mbpoll | Command-line Modbus clients for quick verification |
| Sparkplug-aware clients (e.g. Ignition, Chariot) | Decoding protobuf Sparkplug payloads |
| nmap with caution | Discovery — **never** against production OT without approval |

## A note on standards versions

Protocol specifications are revised. Before relying on a detail in these guides for
implementation work, check the current version of the relevant document at the links
above — particularly for OPC UA companion specifications, Sparkplug (which moved to
3.0 under Eclipse), and TSN profiles, all of which are actively evolving.

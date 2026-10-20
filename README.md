# Docker image bundle (offline / air-gapped)

Pre-pulled Docker images for **linux/amd64**, ready to `docker load` on a machine
with no registry access.

Each image is archived as its own `.zip`, then split into **≤ 95 MiB parts** so every
file stays under GitHub's hard 100 MiB per-file limit. Parts live in
`images/<name>/<name>.zip.part00`, `…part01`, and so on.

## Contents

| Image | Tag | Parts | Archive size |
|---|---|---|---|
| `ubuntu` | `18.04` | 1 | 23.9 MB |
| `ubuntu` | `20.04` | 1 | 25.6 MB |
| `ubuntu` | `22.04` | 1 | 28.1 MB |
| `portainer/portainer-ce` | `latest` | 1 | 42.6 MB |
| `eclipse-mosquitto` | `latest` | 1 | 12.3 MB |
| `mysql` | `8.0` | 3 | 220.8 MB |
| `node` | `20` | 4 | 378.0 MB |
| `python` | `3.12` | 5 | 390.5 MB |

**Total: 1.10 GB** across 8 images.

## Documentation

[**IIoT Communication Protocols - A Practical Guide**](docs/iiot-protocols/) - originally written
guides to MQTT/Sparkplug, OPC UA, Modbus, industrial Ethernet, fieldbus, CoAP/AMQP/DDS,
wireless and LPWAN, OT security and integration patterns. Also available as a single
[49-page PDF](docs/iiot-protocols/IIoT-Communication-Protocols-Guide.pdf).

## Restore

### Linux / Ubuntu host

```bash
git clone https://github.com/blockchain726/template.git
cd template
sudo apt-get install -y unzip        # if not already present
./restore.sh                         # all images
./restore.sh mysql-8.0               # or just one
```

`restore.sh` verifies `SHA256SUMS`, concatenates the parts, unzips, and runs
`docker load` for each image. Loaded images keep their original names and tags
(`mysql:8.0`, `node:20`, …) — no retagging needed.

### Windows host

```powershell
git clone https://github.com/blockchain726/template.git
cd template
.\restore.ps1                        # all images
.\restore.ps1 -Name mysql-8.0        # or just one
```

### Manual restore (any single image)

```bash
cat images/mysql-8.0/mysql-8.0.zip.part* > mysql-8.0.zip
unzip mysql-8.0.zip
docker load -i mysql-8.0.tar
```

## Which Ubuntu version do these need — 18.04, 20.04 or 22.04?

**Any of them.** A Linux container image ships its own complete userspace, so the
host's Ubuntu release does not have to match anything inside the image. All eight
archives here load and run identically on Ubuntu 18.04, 20.04 and 22.04 hosts; the
only host requirement is a working Docker Engine on `linux/amd64`.

`ubuntu:18.04`, `ubuntu:20.04` and `ubuntu:22.04` are included as **base images** —
use them as the `FROM` line when you build your own application images against a
specific Ubuntu release.

The application images are the upstream official ones (Debian- or Alpine-based
internally — that is an implementation detail of each image and does not affect the
host). Ubuntu-native rebuilds of these do not exist upstream for all three releases:
Canonical publishes no `ubuntu/mosquitto` or Ubuntu-based Portainer at all,
`ubuntu/node` only targets 24.04, `ubuntu/python` only 22.04, and `ubuntu/mysql`
only 20.04/22.04 on beta/edge channels.

## Verifying

```bash
sha256sum -c SHA256SUMS
```

Each `images/<name>/MANIFEST.txt` additionally records the source image reference,
the reassembled zip's size and SHA-256, and a checksum per part.

## Provenance

Pulled 2026-10-19 with [crane](https://github.com/google/go-containerregistry)
v0.22.1, platform `linux/amd64`. Source digests:

| Image | Digest |
|---|---|
| `ubuntu:18.04` | `sha256:dca176c9663a7ba4c1f0e710986f5a25e672842963d95b960191e2d9f7185ebe` |
| `ubuntu:20.04` | `sha256:c664f8f86ed5a386b0a340d981b8f81714e21a8b9c73f658c4bea56aa179d54a` |
| `ubuntu:22.04` | `sha256:98510ac07bb4545e389be502a8918b385c018bfe4ceeb5ac7e0375c782268b04` |
| `portainer/portainer-ce:latest` | `sha256:0dff57819c649dcf0a16a984ee1407aaeb6fa950bc9bd8c9021fa952cc20ed02` |
| `eclipse-mosquitto:latest` | `sha256:12436df85d6b2b91e63c71184da35ec89400a98abdc688a78b1403a11ecf44b4` |
| `mysql:8.0` | `sha256:62fb722c78b24245ddff1796a0fcee4a49cc5b87e0aaaf20c92d1da9e0a2497b` |
| `node:20` | `sha256:cacf10e99285cbbc891452e31249c1b5ec3ba225f40028fae946b75aeaf1b66a` |
| `python:3.12` | `sha256:3d361d7fea344d55ac7a0f51ed7faa99213808ccc96fc9b9170adb95b6570b96` |

Re-pull any of these from source with:

```bash
crane pull --platform linux/amd64 mysql:8.0 mysql-8.0.tar
```

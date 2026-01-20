🛡️ Project: Bare-Metal DNS Security Appliance
A high-availability, network-wide DNS sinkhole and security gateway deployed on repurposed hardware.

📋 Overview
This project involved transforming an "end-of-life" laptop into a dedicated production server. The goal was to implement network-wide ad-blocking,
 telemetry prevention, and DNS encryption for all devices (IoT, Mobile, Desktop) at the router level.

🏗️ Technical Architecture
Host OS: Ubuntu Server 24.04 LTS (Headless)

Virtualization: Docker / Docker Compose

Application: AdGuard Home

Hardware: Legacy Laptop (utilizing integrated battery as a built-in UPS)

Network: Static IP assignment with systemd-resolved bypass.

🛠️ Implementation Highlights
1. Infrastructure as Code (IaC)
Instead of manual installation, the service was deployed using Docker Compose to ensure portability and rapid recovery.

YAML

services:
  adguardhome:
    image: adguard/adguardhome
    container_name: adguardhome
    restart: unless-stopped
    volumes:
      - ./workdir:/opt/adguardhome/work
      - ./confdir:/opt/adguardhome/conf
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "80:80/tcp"
      - "3000:3000/tcp"
2. Linux System Hardening
Power Management: Reconfigured logind.conf to ignore the laptop lid switch, allowing for a "headless" footprint without triggering system suspension.

Network Optimization: Disabled default systemd-resolved listeners to free up Port 53 for high-performance DNS processing.

🧠 Lessons Learned (The "Engineering" Bit)
During deployment, I encountered a DNS Resolution Loop where the Docker daemon could not pull images because the host's DNS was disabled for configuration.

Challenge: "Chicken and the Egg" DNS failure (Temporary failure in name resolution).

Solution: Manually bootstrapped the environment by reconstructing the /etc/resolv.conf file with static upstream providers and configuring 
the Docker daemon.json with independent DNS resolvers. This restored "vision" to the system and allowed the image pull to complete.

🚀 Impact
Telemetry Reduction: Successfully blocked ~25% of outbound tracking requests from "noisy" IoT devices.

Latency Improvement: Leveraged local DNS caching to reduce lookup times for frequently visited domains.

Hardware Lifecycle: Extended the utility of legacy hardware, reducing e-waste while adding a critical security layer to the home network.

---
title: "Static Routing"
date: 2025-09-12
description: "Haha Router go brrr"
authors:
  - "ndrew"
tags: ["multi-vendor", "static-routing"]
---
## Goal
Create and configure a topology that will connect two LANs with a static route.
## Topology Diagram
![Topology Diagram](https://storage-labak.ndrew.sk/materials/labs/static-routing/v1/diagrams/lab-topology.svg)
## IP Address Table
| Device/Interface/Network | Address or Subnet |
| ------------------------ | ----------------- |
| Network 1                | 192.168.1.0/24    |
| Network 2                | 192.168.2.0/24    |
| Network 3                | 10.0.0.0/30       |
| PC1                      | 192.168.1.100     |
| PC2                      | 192.168.2.100     |
| R1 (LAN)                 | 192.168.1.1       |
| R2 (WAN)                 | 192.168.2.1       |
| R1 (LAN)                 | 10.0.0.1          |
| R2 (WAN)                 | 10.0.0.2          |
## Solution
The solution to this lab is simple. After the basic configuration of the devices(hostnames, IP addresses), create a static route between `Network 1` and `Network 2`
### Sample cisco ios configuration
#### Hostname Configuration
```ciscoios
Router(config)#hotstname R1
```
#### Adding an IP address to an interface
```ciscoios
R1(config)#interface GigabitEthernet 0/0/1
R1(config-if)#ip address 192.168.1.1 255.255.255.0
```
#### Creating the static route
```ciscoios
R1(config)#ip route 192.168.2.0 255.255.255.0 10.0.0.2
```
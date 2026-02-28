---
title: "Simulating end devices"
date: 2026-01-07
description: "Simulating end devices using host VLAN subinterfaces and Docker macvlan networks"
authors:
  - "ndrew" 
tags: ["docker","bash"]
---

## Overview
This guide explains how to simulate end devices using Docker containers attached to host VLAN subinterfaces (macvlan networks). It covers the rationale, prerequisites, the common workflow using the `workflow/` scripts from the Git repository, example commands for running end devices, web and DNS services, basic DHCP testing, and cleanup.

## Why 
- Simulating devices with containers is much more resource efficient than full VMs while still allowing realistic networking tests.
- Physical cabling maps to per-VLAN subinterfaces on the host: one cable can represent one or many devices, depending on how many containers you attach to the VLAN.
- Useful for testing DHCP, DNS, web access, routing behaviour, and automation without dedicating physical machines.

## Prerequisites 
- A Linux host with sudo access, Docker (Engine), and iproute2 installed.
- Your own `.ini` config file describing your workspace.
- Helper scripts located in the Git repository under `workflow/`: `create_workspace.sh`, `create_container.sh`, `check_workspaces.sh` and `cleanup_workspace.sh`.
- Container images with the tools you need (e.g., `dhcpcd` for DHCP testing, `nginx` for a web server, `dnsmasq` for DNS). The examples below use those repository scripts and common, lightweight images.

## Workflow 
1. Check which VLANs are taken with `check_workspaces.sh`
2. Create VLAN subinterfaces and Docker macvlan networks with `create_workspace.sh`.
3. Start containers for services (web, dns) and end devices using `create_container.sh`.
4. Test connectivity (ping, curl, domain lookup) and DHCP if required.
5. Cleanup with `cleanup_workspace.sh` when finished.

## How it works (conceptual)
- The host creates per-VLAN subinterfaces (e.g., `ws1-eth0.10`) that tag traffic on the trunk link toward the switch.
- Each subinterface is bound to a Docker macvlan network (e.g., `ws1-vlan10`), so containers on that network send/receive frames as if they were directly cabled to that VLAN.
- The switch sees one physical trunk from the host, carrying multiple VLANs; each container appears as a distinct MAC/IP on its VLAN.
- When tagged frames reach the core switch, it forwards them out the correct access link for that VLAN.

## What it looks like in practice
### Logical topology (what we're simulating)
![Logical Topology](https://storage-labak.ndrew.sk/materials/guides/end-device-sim/v1/diagrams/logical-topology.svg)
### Physical topology (what we're wiring)
![Physical Topology](https://storage-labak.ndrew.sk/materials/guides/end-device-sim/v1/diagrams/physical-topolgy.svg)
### Real Topology (what's actually happening)
![Real Topology](https://storage-labak.ndrew.sk/materials/guides/end-device-sim/v1/diagrams/real-topology.svg)
## Example Usage
### Checking taken VLANs
```bash
sudo ./check_workspaces.sh
```
Sample output:
```
=== VLAN Workspace Status ===

Workspace: ws1
  VLAN 10 [UP]
    Docker Network: ws1-vlan10
  VLAN 20 [UP]
    Docker Network: ws1-vlan20

Workspace: ws2
  VLAN 30 [UP]
    Docker Network: ws2-vlan30
  VLAN 40 [UP]
    Docker Network: ws2-vlan40

=== Summary ===
Total Workspaces: 2
Total VLAN Interfaces: 4
```
That means that we are free to use any workspace number above 2 and any VLANs that aren't VLAN 10,20,30 or 40.
### Creating our .ini file
Let's start with creating a .ini file.
```bash
nano ws3.ini
```
Then we can edit our .ini file based on our needs. For this example let's say we have 2 networks where one is IPv4 only and the other is IPv6 only.
```ini
[workspace]
name=ws3
parent_interface=eno1

[vlan50]
id=50
subnet4=192.168.50.0/24
gateway4=192.168.50.1


[vlan60]
id=60
subnet6=2001:db8:60::/64
gateway6=2001:db8:60::1
```
### Creating the workspace
```bash
sudo ./create_workspace.sh ws3.ini
```
### Checking whether we have created the workspace correctly
```bash
sudo ./check_workspaces.sh
```
The output:
```
=== VLAN Workspace Status ===

Workspace: ws1
  VLAN 10 [UP]
    Docker Network: ws1-vlan10
  VLAN 20 [UP]
    Docker Network: ws1-vlan20

Workspace: ws2
  VLAN 30 [UP]
    Docker Network: ws2-vlan30
  VLAN 40 [UP]
    Docker Network: ws2-vlan40

Workspace: ws3
  VLAN 50 [UP]
    Docker Network: ws3-vlan50
  VLAN 60 [UP]
    Docker Network: ws3-vlan60

=== Summary ===
Total Workspaces: 3
Total VLAN Interfaces: 6
```
This means that our workspace is ready to go.
### Creating Containers
For this example we will create one end device for each network.

For end device attached to VLAN 50:
```bash
sudo ./create_container.sh ws3.ini end 50 dhcp none
```
For end device attached to VLAN 60:
```bash
sudo ./create_container.sh ws3.ini web 60 none 2001:db8:60::100
```
### Cleaning up
Once you're done testing and tinkering arround all you need to do is to remove your workspace using:
```bash
sudo ./cleanup_workspace.sh ws3.ini
```
{{< alert icon="fire" cardColor="#e63946" iconColor="#1d3557" textColor="#f1faee" >}}
Make sure to delete **your** workspace
{{< /alert >}}
#!/bin/bash
set -euo pipefail

echo "=== VLAN Workspace Status ==="
echo

# --------------------------
# GET ALL VLAN INTERFACES
# --------------------------
VLAN_INTERFACES=$(ip link show | grep "@" | awk '{print $2}' | sed 's/:$//' | sed 's/@.*//')

if [ -z "$VLAN_INTERFACES" ]; then
    echo "No VLAN subinterfaces found."
    exit 0
fi

# --------------------------
# CHECK FUNCTIONS
# --------------------------

get_vlan_id() {
    local iface="$1"
    # Extract VLAN ID from interface name (e.g., ws1-eno1.10 -> 10)
    echo "$iface" | grep -oP '\.\K\d+$' || echo "N/A"
}

get_parent_interface() {
    local iface="$1"
    ip link show "$iface" 2>/dev/null | grep "@" | grep -oP '@\K[^:]*' || echo "N/A"
}

get_interface_status() {
    local iface="$1"
    ip link show "$iface" 2>/dev/null | grep -oP "(?<=<)[^>]*" | grep -q "UP" && echo "UP" || echo "DOWN"
}

get_ipv4_addr() {
    local iface="$1"
    local addrs=$(ip addr show "$iface" 2>/dev/null | grep "inet " | awk '{print $2}' | tr '\n' ',')
    if [ -z "$addrs" ]; then
        echo "NONE"
    else
        echo "${addrs%,}"
    fi
}

get_ipv6_addr() {
    local iface="$1"
    local addrs=$(ip addr show "$iface" 2>/dev/null | grep "inet6" | grep -v "fe80" | awk '{print $2}' | tr '\n' ',')
    if [ -z "$addrs" ]; then
        echo "NONE"
    else
        echo "${addrs%,}"
    fi
}

get_docker_networks() {
    local iface="$1"
    local nets=$(docker network ls --format "table {{.Name}}" 2>/dev/null | tail -n +2 | while read net; do
        if docker network inspect "$net" 2>/dev/null | grep -q "$iface"; then
            echo "$net"
        fi
    done | tr '\n' ',')
    if [ -z "$nets" ]; then
        echo "NONE"
    else
        echo "${nets%,}"
    fi
}

extract_workspace() {
    local iface="$1"
    echo "$iface" | sed 's/-.*//'
}

# --------------------------
# BUILD DATA STRUCTURE
# --------------------------
declare -A WORKSPACES
declare -A VLAN_DATA

for iface in $VLAN_INTERFACES; do
    workspace=$(extract_workspace "$iface")
    vlan_id=$(get_vlan_id "$iface")
    status=$(get_interface_status "$iface")
    ipv4=$(get_ipv4_addr "$iface")
    ipv6=$(get_ipv6_addr "$iface")
    docker_nets=$(get_docker_networks "$iface")
    
    # Add to workspaces set
    WORKSPACES["$workspace"]=1
    
    # Store VLAN data
    VLAN_DATA["${workspace}_${vlan_id}"]="$status|$ipv4|$ipv6|$docker_nets"
done

# --------------------------
# OUTPUT ORGANIZED BY WORKSPACE
# --------------------------

for workspace in $(printf '%s\n' "${!WORKSPACES[@]}" | sort); do
    echo "Workspace: $workspace"
    
    # Get unique VLANs for this workspace
    vlans=$(for key in "${!VLAN_DATA[@]}"; do
        if [[ "$key" == "${workspace}_"* ]]; then
            echo "$key" | sed 's/.*_//'
        fi
    done | sort -n)
    
    for vlan_id in $vlans; do
        key="${workspace}_${vlan_id}"
        data="${VLAN_DATA[$key]}"
        status=$(echo "$data" | cut -d'|' -f1)
        ipv4=$(echo "$data" | cut -d'|' -f2)
        ipv6=$(echo "$data" | cut -d'|' -f3)
        docker_nets=$(echo "$data" | cut -d'|' -f4)
        
        echo "  VLAN $vlan_id [$status]"
        echo "    Docker Network: $docker_nets"
    done
    
    echo
done

echo "=== Summary ==="
total_interfaces=$(echo "$VLAN_INTERFACES" | wc -w)
total_workspaces=${#WORKSPACES[@]}
echo "Total Workspaces: $total_workspaces"
echo "Total VLAN Interfaces: $total_interfaces"

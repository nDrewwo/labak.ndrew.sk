#!/bin/bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: sudo $0 <config_file.ini>"
    exit 1
fi

CONFIG_FILE="$1"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file $CONFIG_FILE not found."
    exit 1
fi

# --------------------------
# FUNCTION: Read INI values
# --------------------------
ini_get() {
    local section=$1
    local key=$2
    awk -F '=' -v sec="[$section]" -v k="$key" '
        $0 == sec { in_section=1; next }
        in_section && $1 == k { gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2; exit }
        /^\[/ { in_section=0 }
    ' "$CONFIG_FILE"
}

# --------------------------
# READ WORKSPACE VALUES
# --------------------------
WORKSPACE=$(ini_get "workspace" "name")
PARENT_IFACE=$(ini_get "workspace" "parent_interface")

if [ -z "$WORKSPACE" ] || [ -z "$PARENT_IFACE" ]; then
    echo "Error: workspace.name or workspace.parent_interface missing in config."
    exit 1
fi

echo "=== Creating Workspace: $WORKSPACE ==="
echo

VLAN_SECTIONS=($(awk '/^\[vlan/ {gsub(/[\[\]]/, "", $0); print $0}' "$CONFIG_FILE"))

create_vlan_interface() {
    local vlan_id=$1
    local iface_name="${WORKSPACE}-${PARENT_IFACE}.${vlan_id}"

    if ip link show "$iface_name" >/dev/null 2>&1; then
        echo "[SKIP] VLAN interface $iface_name already exists."
        return
    fi

    echo "[CREATE] VLAN interface $iface_name"
    ip link add link "$PARENT_IFACE" name "$iface_name" type vlan id "$vlan_id"
    ip link set "$iface_name" up
}

create_docker_network() {
    local vlan_id=$1
    local subnet4="$2"
    local gateway4="$3"
    local subnet6="$4"
    local gateway6="$5"

    local net_name="${WORKSPACE}-vlan${vlan_id}"
    local iface_name="${WORKSPACE}-${PARENT_IFACE}.${vlan_id}"

    if docker network inspect "$net_name" >/dev/null 2>&1; then
        echo "[SKIP] Docker network $net_name already exists."
        return
    fi

    echo "[CREATE] Docker macvlan network $net_name"

    cmd=(docker network create -d macvlan -o parent="$iface_name")

    # IPv4
    if [ -n "$subnet4" ]; then
        cmd+=(--subnet="$subnet4" --gateway="$gateway4")
    fi

    # IPv6
    if [ -n "$subnet6" ]; then
        cmd+=(--ipv6 --subnet="$subnet6" --gateway="$gateway6")
    fi

    cmd+=("$net_name")

    "${cmd[@]}"
}

for section in "${VLAN_SECTIONS[@]}"; do
    vlan_id=$(ini_get "$section" "id")
    subnet4=$(ini_get "$section" "subnet4")
    gateway4=$(ini_get "$section" "gateway4")
    subnet6=$(ini_get "$section" "subnet6")
    gateway6=$(ini_get "$section" "gateway6")

    echo "--- Processing VLAN $vlan_id ---"
    create_vlan_interface "$vlan_id"
    create_docker_network "$vlan_id" "$subnet4" "$gateway4" "$subnet6" "$gateway6"
    echo
done

echo "=== Workspace Created ==="

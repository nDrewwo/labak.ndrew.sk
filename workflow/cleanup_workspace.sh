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
    echo "Error: workspace.name or workspace.parent_interface missing."
    exit 1
fi

echo "=== Cleaning Workspace: $WORKSPACE ==="
echo

# --------------------------
# FIND VLAN SECTIONS
# --------------------------
VLAN_SECTIONS=($(awk '/^\[vlan/ {gsub(/[\[\]]/, "", $0); print $0}' "$CONFIG_FILE"))

if [ "${#VLAN_SECTIONS[@]}" -eq 0 ]; then
    echo "Error: No VLAN sections found in config."
    exit 1
fi

# --------------------------
# FUNCTIONS
# --------------------------

remove_containers_on_network() {
    local net_name="$1"

    echo "[INFO] Checking containers on network $net_name..."

    # Get container IDs
    local containers
    containers=$(docker ps -aq --filter "network=$net_name")

    if [ -z "$containers" ]; then
        echo "[SKIP] No containers attached to $net_name"
        return
    fi

    echo "[DELETE] Removing containers on network $net_name"
    docker rm -f $containers
}

remove_docker_network() {
    local net_name="$1"

    if docker network inspect "$net_name" >/dev/null 2>&1; then
        echo "[DELETE] Removing Docker network $net_name"
        docker network rm "$net_name"
    else
        echo "[SKIP] Docker network $net_name does not exist."
    fi
}

remove_vlan_interface() {
    local iface_name="$1"

    if ip link show "$iface_name" >/dev/null 2>&1; then
        echo "[DELETE] Removing VLAN interface $iface_name"
        ip link delete "$iface_name"
    else
        echo "[SKIP] VLAN interface $iface_name does not exist."
    fi
}

# --------------------------
# MAIN CLEANUP LOOP
# --------------------------

for section in "${VLAN_SECTIONS[@]}"; do
    vlan_id=$(ini_get "$section" "id")
    iface_name="${WORKSPACE}-${PARENT_IFACE}.${vlan_id}"
    net_name="${WORKSPACE}-vlan${vlan_id}"

    echo "--- Cleaning VLAN $vlan_id ---"

    # Remove containers
    remove_containers_on_network "$net_name"

    # Remove Docker network
    remove_docker_network "$net_name"

    # Remove VLAN interface
    remove_vlan_interface "$iface_name"

    echo
done

echo "=== Workspace '$WORKSPACE' cleaned successfully ==="

#!/bin/bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
    echo "Usage: sudo $0 <config_file.ini> <container_type> [vlan_id] [ipv4|dhcp|none] [ipv6|dhcpv6|none]"
    exit 1
fi

CONFIG_FILE="$1"
CONTAINER_TYPE="$2"
VLAN_ID="${3:-}"
IPV4="${4:-}"
IPV6="${5:-}"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file $CONFIG_FILE not found."
    exit 1
fi

ini_get() {
    local section=$1
    local key=$2
    awk -F '=' -v sec="[$section]" -v k="$key" '
        $0 == sec { in_section=1; next }
        in_section && $1 == k { gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2; exit }
        /^\[/ { in_section=0 }
    ' "$CONFIG_FILE"
}

WORKSPACE=$(ini_get "workspace" "name")
VLAN_SECTIONS=($(awk '/^\[vlan/ {gsub(/[\[\]]/, "", $0); print $0}' "$CONFIG_FILE"))

if [ -z "$VLAN_ID" ]; then
    echo "Available VLANs:"
    for section in "${VLAN_SECTIONS[@]}"; do
        echo "  - $(ini_get "$section" "id")"
    done
    read -rp "Choose VLAN ID: " VLAN_ID
fi

# Lookup VLAN section
VLAN_SECTION=""
for section in "${VLAN_SECTIONS[@]}"; do
    if [ "$(ini_get "$section" "id")" == "$VLAN_ID" ]; then
        VLAN_SECTION="$section"
    fi
done
if [ -z "$VLAN_SECTION" ]; then
    echo "Error: VLAN $VLAN_ID not found."
    exit 1
fi

SUBNET4=$(ini_get "$VLAN_SECTION" "subnet4")
GATEWAY4=$(ini_get "$VLAN_SECTION" "gateway4")
SUBNET6=$(ini_get "$VLAN_SECTION" "subnet6")
GATEWAY6=$(ini_get "$VLAN_SECTION" "gateway6")
DOCKER_NET="${WORKSPACE}-vlan${VLAN_ID}"

###############################################
# NONE → disable that protocol entirely
###############################################

if [ "$IPV4" = "none" ]; then
    DISABLE_IPV4=1
else
    DISABLE_IPV4=0
fi

if [ "$IPV6" = "none" ]; then
    DISABLE_IPV6=1
else
    DISABLE_IPV6=0
fi

###############################################
# AUTO-ASSIGN only if user left it empty
###############################################

if [ -z "$IPV4" ] && [ "$DISABLE_IPV4" -eq 0 ]; then
    # User left IPv4 empty → leave to Docker (no static or DHCP logic)
    IPV4=""
elif [ -z "$IPV4" ] && [ -n "$SUBNET4" ]; then
    IPV4="auto"
fi

if [ -z "$IPV6" ] && [ "$DISABLE_IPV6" -eq 0 ]; then
    IPV6=""
elif [ -z "$IPV6" ] && [ -n "$SUBNET6" ]; then
    IPV6="auto"
fi

###############################################
# STATIC AUTOGENERATION
###############################################

if [ "$IPV4" = "auto" ] && [ "$DISABLE_IPV4" -eq 0 ]; then
    USED=$(docker network inspect "$DOCKER_NET" --format '{{range .Containers}}{{.IPv4Address}} {{end}}' | cut -d'/' -f1)
    BASE=$(echo "$SUBNET4" | cut -d'.' -f1-3)
    for i in $(seq 2 250); do
        CANDIDATE="${BASE}.${i}"
        if ! grep -q "$CANDIDATE" <<< "$USED"; then
            IPV4="$CANDIDATE"
            break
        fi
    done
    echo "[INFO] Assigned IPv4: $IPV4"
fi

if [ "$IPV6" = "auto" ] && [ "$DISABLE_IPV6" -eq 0 ]; then
    PREFIX6=$(echo "$SUBNET6" | cut -d'/' -f1 | sed 's/::$//; s/:$//')
    USED6=$(docker network inspect "$DOCKER_NET" --format '{{range .Containers}}{{.IPv6Address}} {{end}}' | cut -d'/' -f1)
    for i in $(seq 2 250); do
        CANDIDATE="${PREFIX6}::${i}"
        if ! grep -q "$CANDIDATE" <<< "$USED6"; then
            IPV6="$CANDIDATE"
            break
        fi
    done
    echo "[INFO] Assigned IPv6: $IPV6"
fi


###############################################
# DHCP reminders
###############################################

if [ "$IPV4" = "dhcp" ] || [ "$IPV6" = "dhcpv6" ]; then
    echo "[INFO] To acquire DHCP addresses inside the container, run:"
    [ "$IPV4" = "dhcp" ] && echo "dhcpcd -4 -N eth0"
    [ "$IPV6" = "dhcpv6" ] && echo "dhcpcd -6 -N eth0"
fi


###############################################
# CONTAINER START
###############################################

CONTAINER_NAME="${WORKSPACE}-${CONTAINER_TYPE}-$(date +%s)"
echo "=== Starting Container ==="
echo "Name:  $CONTAINER_NAME"
echo "Net:   $DOCKER_NET"
echo "IPv4:  ${IPV4:-docker-managed}"
echo "IPv6:  ${IPV6:-docker-managed}"
echo

cmd=(
    docker run -it --rm
    --name "$CONTAINER_NAME"
    --network "$DOCKER_NET"
    --cap-add NET_ADMIN --cap-add NET_RAW --privileged
)

###############################################
# APPLYING NONE / STATIC / DHCP CONFIG
###############################################

# ---- NONE = remove all assignment logic ----
if [ "$DISABLE_IPV4" -eq 1 ]; then
    cmd+=(--env DISABLE_IPV4=1)
fi
if [ "$DISABLE_IPV6" -eq 1 ]; then
    cmd+=(--env DISABLE_IPV6=1)
fi

# ---- STATIC ----
if [ -n "$IPV4" ] && [ "$IPV4" != "dhcp" ] && [ "$DISABLE_IPV4" -eq 0 ]; then
    cmd+=(--ip "$IPV4")
fi
if [ -n "$IPV6" ] && [ "$IPV6" != "dhcpv6" ] && [ "$DISABLE_IPV6" -eq 0 ]; then
    cmd+=(--ip6 "$IPV6")
fi

# ---- DHCP: override entrypoint + pass flags ----
if [ "$IPV4" = "dhcp" ] || [ "$IPV6" = "dhcpv6" ]; then
    cmd+=(--entrypoint /usr/local/bin/init-network.sh)
fi

if [ "$IPV4" = "dhcp" ]; then
    cmd+=(--env DHCPV4=1)
fi
if [ "$IPV6" = "dhcpv6" ]; then
    cmd+=(--env DHCPV6=1)
fi

###############################################
# CONTAINER TYPE
###############################################

case "$CONTAINER_TYPE" in
    end)
        cmd+=(test2 sh)
        ;;
    web)
        cmd+=(nginx-ip sh)
        ;;
    dns)
        cmd+=(--entrypoint sh andyshinn/dnsmasq)
        ;;
    *)
        echo "ERROR: Unknown container type."
        exit 1
        ;;
esac

# Run
"${cmd[@]}"

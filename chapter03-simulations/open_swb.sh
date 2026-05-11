#!/usr/bin/env bash
# Launch Sentaurus Workbench (swb) on the EKL server with X11 forwarding.
# Run this from your local Linux terminal — it opens the swb GUI on your screen.
#
# Prerequisites on this machine:
#   - TUDelft VPN is connected
#   - An X server is running (Linux: native; Windows: VcXsrv/Xming; macOS: XQuartz)
#   - sshpass is installed (sudo apt install sshpass) if you want passwordless

set -euo pipefail

# Read credentials from the gitignored file
CRED_FILE="$(dirname "$0")/../.credentials/server.txt"
if [[ ! -f "$CRED_FILE" ]]; then
    echo "Credentials file not found at $CRED_FILE" >&2
    exit 1
fi

USER_NAME=$(grep -E '^account:' "$CRED_FILE" | awk '{print $2}')
PASSWORD=$(grep -E '^password:' "$CRED_FILE" | awk '{print $2}')
HOST="et4icp.ewi.tudelft.nl"

echo "Launching swb GUI on $USER_NAME@$HOST ..."
echo "(close the swb window to end the session)"

# -X enables X11 forwarding so the GUI windows appear locally.
# The remote command sources the Synopsys env and launches swb in the project root.
SSHPASS="$PASSWORD" sshpass -e ssh -X -o StrictHostKeyChecking=accept-new \
    "${USER_NAME}@${HOST}" \
    'source /eda/scripts/flexlm.sh; source /eda/synopsys/2025-26/scripts/SENTAURUS_2025.09_RHELx86.sh; cd ~/STDB && swb &
     wait'

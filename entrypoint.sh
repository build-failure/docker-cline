#!/bin/bash

# Entrypoint script for Cline CLI Docker container
# This script runs the cline-config setup and then executes cline with provided parameters

set -e

echo "🚀 Starting Cline CLI Docker container..."

echo "🔧 Running Cline configuration setup..."

CLINE_AWS_REGION="${CLINE_AWS_REGION:-eu-central-1}"
CLINE_AWS_MODEL_ID="${CLINE_AWS_MODEL_ID}"
GS="$HOME/.cline/data/globalState.json"

# Ensure directory exists and create globalState.json if it doesn't exist
mkdir -p "$(dirname "$GS")"
[[ -f "$GS" ]] || echo '{}' > "$GS"

# Backup existing config
cp "$GS" "$GS.bak.$(date +%s)" 2>/dev/null || true

# Update configuration using jq
jq --arg m "$CLINE_AWS_MODEL_ID" --arg r "$CLINE_AWS_REGION" '
    .planModeApiProvider = "bedrock" |
    .actModeApiProvider  = "bedrock" |
    .planModeApiModelId  = $m |
    .actModeApiModelId   = $m |
    .awsAuthentication   = "credentials" |
    .awsUseProfile       = false |
    .awsRegion           = $r |
    .awsUseGlobalInference = true |
    .awsUseCrossRegionInference = true
' "$GS" > "$GS.tmp" && mv "$GS.tmp" "$GS"

echo "✅ Cline configuration completed"

# If no arguments provided, start interactive bash
if [ $# -eq 0 ]; then
    echo "💬 No arguments provided, starting interactive bash shell..."
    echo "💡 You can run 'cline --help' to see available commands"
    exec /bin/bash
fi

# If first argument is not a cline command, assume it's meant for cline
if [[ "$1" != "cline" ]] && [[ "$1" != "/bin/bash" ]] && [[ "$1" != "bash" ]] && [[ "$1" != "sh" ]]; then
    echo "🤖 Executing: cline $@"
    exec cline "$@"
else
    echo "🤖 Executing: $@"
    exec "$@"
fi

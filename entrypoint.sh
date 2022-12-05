#!/usr/bin/env ash
# shellcheck shell=dash

set -euo pipefail

: "${HCLOUD_TOKEN?HCLOUD_TOKEN environment variable must be set}"

# Run and preserve output for consumption by downstream actions
/hcloud "$@" >"${GITHUB_WORKSPACE}/hcloud.output"

# Write output to STDOUT
cat "${GITHUB_WORKSPACE}/hcloud.output"

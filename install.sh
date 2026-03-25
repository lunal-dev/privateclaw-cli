#!/bin/bash
set -e

# PrivateClaw CLI installer
# Downloads privateclaw CLI and attestation-cli to /usr/local/bin/

VERSION="${PRIVATECLAW_VERSION:-v1.0.0}"
ATTEST_VERSION="${ATTESTATION_CLI_VERSION:-v0.4.0}"

echo "Installing PrivateClaw CLI ${VERSION}..."

curl -fsSL "https://github.com/lunal-dev/privateclaw-cli/releases/download/${VERSION}/privateclaw" \
  -o /usr/local/bin/privateclaw

curl -fsSL "https://github.com/lunal-dev/attestation-rs/releases/download/${ATTEST_VERSION}/attestation-cli" \
  -o /usr/local/bin/attestation-cli

chmod +x /usr/local/bin/privateclaw /usr/local/bin/attestation-cli

echo "Installed:"
echo "  /usr/local/bin/privateclaw (${VERSION})"
echo "  /usr/local/bin/attestation-cli (${ATTEST_VERSION})"

# privateclaw-cli

TEE verification and management CLI for [PrivateClaw](https://privateclaw.dev) CVMs.

## Install

```bash
curl -fsSL https://github.com/lunal-dev/privateclaw-cli/releases/download/v1.0.0/install.sh | bash
```

This installs two binaries to `/usr/local/bin/`:
- `privateclaw` — shell script CLI with `verify`, `attest`, and `assign` subcommands
- `attestation-cli` — pre-built binary from [attestation-rs](https://github.com/lunal-dev/attestation-rs) for cryptographic TEE attestation

## Commands

### `privateclaw verify`

User-facing command. Cryptographically verifies your CVM is running in a genuine TEE:

1. **TEE Attestation** — validates AMD SEV-SNP attestation evidence via `attestation-cli`, confirms SSH host key is bound to the TEE
2. **Inference Provider** — shows configured Lunal inference endpoint
3. **External Access Lockout** — audits SSH authorized keys and firewall

### `privateclaw attest`

Boot-time command (called by cloud-init). Generates attestation evidence binding the SSH host key to the TEE hardware.

### `privateclaw assign`

Internal command (called by systemd timer). Polls Azure IMDS for user configuration and applies it.

## Independent Verification

You can verify a CVM's attestation evidence from any machine:

```bash
# Copy evidence from CVM
scp user@cvm:/etc/privateclaw/evidence.json .

# Verify locally (install attestation-cli first)
attestation-cli verify -e evidence.json --expected-report-data <host_key_hash_hex>
```

## Auditing

This repo contains everything that runs on your CVM. The `privateclaw` script is a single shell file — read it directly to see exactly what it does.

The only binary dependency is [`attestation-cli`](https://github.com/lunal-dev/attestation-rs), which is also open source.

# privateclaw-cli

TEE verification and management CLI for [PrivateClaw](https://privateclaw.dev) CVMs.

PrivateClaw runs your inference workloads inside fully encrypted confidential VMs. This CLI lets you cryptographically confirm that a CVM really is a genuine TEE — and inspect its state.

For background on TEEs and remote attestation, see [confidential.ai/docs](https://confidential.ai/docs).

## Install

```bash
curl -fsSL https://github.com/lunal-dev/privateclaw-cli/releases/latest/download/install.sh | bash
```

This installs two binaries to `/usr/local/bin/`:

- `privateclaw` — the CLI shell script (this repo)
- `attestation-cli` — pre-built binary from [lunal-dev/attestation-rs](https://github.com/lunal-dev/attestation-rs) that performs the cryptographic SEV-SNP and TPM attestation

## Commands

```
privateclaw <command> [flags]
```

| Command | Description |
|---|---|
| `verify [-v\|--verbose]` | Run the full 5-check TEE verification |
| `info` | Print component versions, hostname, gateway IP, install date |
| `attest` | Generate attestation evidence (boot-time; run by cloud-init) |
| `assign` | Apply user configuration from IMDS (internal; run by systemd) |

### `privateclaw verify`

User-facing command. Runs five checks and prints a pass/fail summary:

1. **SEV-SNP Hardware** — requests a fresh AMD SEV-SNP attestation report bound to the current SSH host key hash and validates the full cert chain via `attestation-cli`.
2. **TPM Attestation** — validates the vTPM quote and AK cert chain.
3. **Host Key Binding** — confirms the live SSH host key matches the key baked into the attestation evidence (so MITM is impossible).
4. **Inference Provider** — shows the configured Lunal inference endpoint.
5. **External Access Lockout** — audits `authorized_keys`, firewall rules, and cloud-provider access paths (waagent / VM extensions) to confirm no operator backdoor.

Add `-v` / `--verbose` for full cert-chain, VCEK, and endpoint diagnostics.

### `privateclaw info`

Prints a compact status block — useful for bug reports and quick sanity checks:

```
privateclaw:       v1.5.7
attestation-cli:   v0.4.1
openclaw:          <version>
Hostname:          <fqdn>
Gateway IP:        <gateway>
Installed:         <date>
```

### `privateclaw attest`

Boot-time command invoked by cloud-init. Generates SEV-SNP + TPM attestation evidence binding the SSH host key to the TEE hardware and writes it to `/etc/privateclaw/evidence.json`.

### `privateclaw assign`

Internal command invoked by a systemd timer. Polls Azure IMDS for user configuration (SSH keys, inference endpoint) and applies it to the CVM.

## Independent verification

You can verify a CVM's attestation evidence from any machine — you don't need to trust this CLI:

```bash
# Copy evidence off the CVM
scp user@cvm:/etc/privateclaw/evidence.json .

# Verify locally with attestation-cli
attestation-cli verify -e evidence.json --expected-report-data <host_key_hash_hex>
```

## Auditing

Everything that runs on your CVM lives in this repo. `privateclaw` is a single bash script — read it top to bottom to see exactly what it does. The only binary dependency is [`attestation-cli`](https://github.com/lunal-dev/attestation-rs), which is also open source.

## License

[MIT](./LICENSE)

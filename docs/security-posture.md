# Security Posture

## Scope

This is a public repository using synthetic dbt seed data and a local
DuckDB profile. All committed files must be safe for public review. The project
must not contain real warehouse credentials, client data, employer data, private
source extracts, or internal system names.

## Current Controls

- GitHub Actions CI uses read only repository contents permission.
- Python dependency checks target Python 3.11 or newer so fixed tooling
  versions are installable.
- Python/dbt dependencies are audited in CI with `pip-audit`.
- CodeQL scans the Python support scripts.
- OpenSSF Scorecard runs on the public repository and uploads SARIF results.
- Dependabot version updates are configured for Python and GitHub Actions.
- Security reporting instructions are documented in `SECURITY.md`.
- Generated dbt folders such as `target/`, `logs/`, and local profile files are ignored.

## Data and Credential Boundary

The committed profile runs locally and writes to DuckDB under `target/`. The
sample data is synthetic. Production credentials belong in environment variables
or a secret manager and must not be committed.

Do not commit:

- real warehouse credentials or service account keys;
- production `profiles.yml` files;
- private extracts, customer data, or employer data;
- generated `target/`, `logs/`, compiled SQL artifacts, or local databases;
- API tokens, passwords, certificates, or private keys.

## GitHub Settings To Keep Enabled

These controls live in GitHub repository settings rather than source files:

- secret scanning and push protection;
- Dependabot alerts and Dependabot security updates;
- branch protection or repository rulesets for `main`;
- required CI checks before merging;
- blocked force pushes and branch deletion;
- default workflow token permission set to read only.

## Residual Risk

The controls cover the public code and local build. They do not cover warehouse
identity, production access control, row level security, or deployment hardening.
Those controls belong to the target platform and need separate evidence.

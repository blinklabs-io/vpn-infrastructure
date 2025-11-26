# Security Guidelines

This document outlines the security measures and guidelines for the VPN infrastructure repository.

## Reporting Vulnerabilities

If you discover a security vulnerability, please report it responsibly:
- Email: security@blinklabs.io
- Do not create public issues for security vulnerabilities.

## Security Features

### VPN Configuration
- TLS 1.3 with strong ciphers (ChaCha20-Poly1305, AES-256-GCM).
- Certificate validation with `tls-cert-profile preferred`.
- Client connections limited to 20.
- IPv6 routing disabled.
- Management interface disabled.
- Verbosity set to 0 for minimal logging.

### Infrastructure Security
- EKS cluster with encrypted secrets and storage.
- IAM policies follow least privilege.
- S3 buckets encrypted with AES256.
- Access keys secured with SOPS.

### CI/CD Security
- Trivy vulnerability scanning integrated.
- Dependabot for automated dependency updates.
- Signed commits required on protected branches.
- Least privilege permissions in workflows.

## Best Practices

- Rotate secrets regularly.
- Use multi-factor authentication for AWS accounts.
- Monitor for security alerts in GitHub.
- Keep dependencies updated.

## Compliance

This setup aligns with privacy-focused standards, minimizing data collection and ensuring encrypted communications.
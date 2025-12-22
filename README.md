# Terraform Enterprise CI/CD with GitHub Actions & AWS OIDC

## Overview

This repository demonstrates a **secure, enterprise-grade Terraform CI/CD pipeline**
using **GitHub Actions** and **AWS OIDC authentication**, eliminating the need for
long-lived AWS access keys.

The project intentionally focuses on **CI/CD security, identity, and workflow design** —
not application infrastructure. Real infrastructure (VPCs, EC2, RDS, EKS, etc.) would be
deployed in downstream repositories that reuse this same CI/CD pattern.

This mirrors how enterprise platform teams design reusable, security-first pipelines.

---

## Architecture Summary

### Core components

- **GitHub Actions** – CI/CD runner
- **Terraform** – Infrastructure as Code
- **AWS IAM OIDC Provider** – Federated authentication
- **AWS IAM Role & Policy** – Least-privilege execution role
- **Remote Terraform State** – S3 backend with DynamoDB locking

### High-level flow

1. GitHub Actions workflow starts
2. GitHub issues an OIDC token at runtime
3. AWS STS validates the token
4. GitHub Actions assumes an IAM role **without static credentials**
5. Terraform executes using short-lived AWS credentials

---

## Why OIDC (No Static AWS Keys)

This pipeline uses **OIDC-based authentication** instead of AWS access keys to follow
modern cloud security best practices:

- No credentials stored in GitHub secrets
- No manual key rotation
- Short-lived, automatically scoped credentials
- Reduced blast radius if CI is compromised

This reflects how **enterprise AWS environments** secure CI/CD pipelines today.

---

## Terraform CI Workflow (CI-Only by Design)

### Continuous Integration (CI)

Triggered on:

- `push` to `main`
- `pull_request` to `main`
- manual `workflow_dispatch`

CI performs **read-only validation**:

- `terraform init`
- `terraform fmt -check`
- `terraform validate`
- `terraform plan`

### Purpose

- Catch formatting, syntax, and logic issues early
- Validate Terraform execution using OIDC-based credentials
- Ensure infrastructure changes are reviewed before any apply stage
- Prove secure identity federation between GitHub Actions and AWS

---

## Apply Strategy (Intentionally Out of Scope)

This repository **does not perform `terraform apply`**.

Its purpose is to validate:

- GitHub Actions → AWS OIDC authentication
- Secure Terraform execution in CI
- Workflow structure suitable for enterprise environments

Production applies, environment gating, and approval workflows are expected to exist in
**downstream infrastructure repositories** that consume this CI/CD pattern.

This separation mirrors real-world platform engineering practices, where CI/CD pipelines
are centralized and reused across multiple infrastructure projects.

---

## Repository Structure

```text
.
├── .github/workflows/
│   └── terraform.yml        # GitHub Actions CI workflow (OIDC-based)
│
├── infra/
│   └── oidc/                # AWS OIDC + IAM role configuration
│       ├── github-oidc-provider.tf
│       ├── github-actions-role.tf
│       ├── github-actions-policy.tf
│       └── backend.tf
│
└── README.md

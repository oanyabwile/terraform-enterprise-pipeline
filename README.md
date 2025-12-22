# Terraform Enterprise CI/CD with GitHub Actions & AWS OIDC

## Overview

This repository demonstrates a **secure, enterprise-grade Terraform CI/CD pipeline** using **GitHub Actions** and **AWS OIDC authentication**, eliminating the need for long-lived AWS access keys.

The project intentionally focuses on **CI/CD security, identity, and workflow design**, not application infrastructure. Real infrastructure (VPCs, EC2, RDS, etc.) would be deployed in downstream repositories using this same pipeline pattern.

---

## Architecture Summary

**Core components:**

- GitHub Actions – CI/CD runner
- Terraform – Infrastructure as Code
- AWS IAM OIDC Provider – Federated authentication
- AWS IAM Role & Policy – Least-privilege execution role
- Remote Terraform State – S3 backend with DynamoDB locking

**High-level flow:**

1. GitHub Actions workflow runs
2. GitHub issues an OIDC token at runtime
3. AWS STS validates the token
4. GitHub Actions assumes an IAM role **without static credentials**
5. Terraform executes using temporary credentials

---

## Why OIDC (No Static AWS Keys)

This pipeline uses **OIDC-based authentication** instead of AWS access keys to follow modern cloud security best practices:

- No credentials stored in GitHub secrets
- No key rotation required
- Short-lived, automatically scoped credentials
- Reduced blast radius if CI is compromised

This mirrors how **enterprise AWS environments** secure CI/CD pipelines.

---

## Terraform CI/CD Workflow

### Continuous Integration (CI)

Triggered on:

- `push` to `main`
- `pull_request` to `main`

CI performs:

- `terraform init`
- `terraform fmt -check`
- `terraform validate`
- `terraform plan`

Purpose:

- Catch formatting, syntax, and logic issues early
- Ensure infrastructure changes are reviewed before apply
- Prevent broken Terraform from reaching production

---

### Controlled Apply (Manual Approval)

- Terraform **apply is not automatic**
- Apply is triggered **only via `workflow_dispatch`**
- Production apply is gated behind a **GitHub Environment**
- Environment approval can require manual reviewers

This prevents:

- Accidental production changes
- Unreviewed destructive actions
- CI pipelines from auto-applying infrastructure changes

---

## Repository Structure

```text
.
├── .github/workflows/
│   └── terraform.yml        # GitHub Actions CI/CD pipeline
│
├── infra/
│   └── oidc/                # OIDC + IAM role configuration
│       ├── github-oidc-provider.tf
│       ├── github-actions-role.tf
│       ├── github-actions-policy.tf
│       └── backend.tf
│
└── README.md

# Terraform-Based Azure Network & Compute Architecture – Phase 1

## 📌 Objective

Design and implement a secure Azure infrastructure using Terraform with:

- Remote backend configuration
- Segmented subnets
- Network Security Groups (NSGs)
- Jump server architecture
- Private database tier preparation
- Multi-machine Terraform workflow

---

# 🌐 1. Network Architecture

## Virtual Network

| Property | Value |
|----------|--------|
| Name | vnet-tf-dev |
| Address Space | 10.0.0.0/16 |
| Purpose | Core network boundary |

### Why /16?

- Allows future subnet expansion
- Supports multi-tier architecture
- Clean CIDR planning for scaling

---

# 🧩 2. Subnet Design

## 2.1 Database Subnet

| Property | Value |
|----------|--------|
| Name | snet-db-dev |
| CIDR | 10.0.1.0/24 |
| Purpose | Database Tier |

### Security Rules

- Allow TCP 1433 from VirtualNetwork
- Allow TCP 5432 from VirtualNetwork
- Block all public internet inbound

### Design Principle

- Private database tier
- East-West traffic allowed
- North-South traffic restricted

---

## 2.2 Jump Subnet

| Property | Value |
|----------|--------|
| Name | snet-jump-dev |
| CIDR | 10.0.2.0/24 |
| Purpose | Secure access tier |

### Security Rules

- Allow TCP 3389 (RDP) from home public IP only
- Deny all other inbound traffic

### Design Principle

- Controlled entry point
- Reduced attack surface
- Segmentation from DB subnet

---

# 🔐 3. Security Model

## East-West Traffic

Traffic within the VNet:

- App → DB allowed
- Jump → DB allowed (future configuration)
- Controlled by subnet-specific NSGs

## North-South Traffic

Traffic from Internet:

- DB subnet: fully blocked
- Jump subnet: restricted to specific IP and port

---

# 🖥 4. Compute Layer

## VM Resource Group

| Property | Value |
|----------|--------|
| Name | rg-tf-vm-dev |
| Purpose | Isolated compute lifecycle |

### Design Rationale

- Separate network and compute resource groups
- Cleaner RBAC management
- Independent deployment lifecycle

---

# 🗄 5. Terraform Remote Backend

## Backend Infrastructure

- Azure Storage Account
- Private container: `tfstate`
- Separate state files:
  - `network.tfstate`
  - `vmcreation.tfstate`

## Benefits

- Multi-machine safe
- Centralized state management
- Enterprise-ready collaboration
- Prevents state drift

---

# 🧠 6. Key Concepts Learned

- CIDR math (/24, /27, /28)
- Azure reserves 5 IPs per subnet
- NSG rule priority evaluation
- Micro-segmentation principles
- East-West vs North-South traffic
- Terraform remote backend migration
- Multi-module Terraform architecture
- `data` block vs `resource` block
- Handling Azure SKU capacity restrictions

---

# 🏛 7. Current Logical Architecture

## Phase 2 – Private Endpoint Architecture

![Private Endpoint Architecture](docs/architecture-phase2-private-endpoint.png)
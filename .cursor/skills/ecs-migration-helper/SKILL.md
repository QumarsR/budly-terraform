---
name: ecs-migration-helper
description: Analyze container dependencies, networking configuration, and service discovery to assist with migration from monolithic EC2 to ECS. READ-ONLY: Does not modify files. Use when migrating to ECS, analyzing container interactions, or configuring service discovery.
---

# ECS Migration Helper

## Purpose
This skill helps analyze the codebase to understand how services interact, their networking requirements, and how to migrate them from a monolithic EC2 deployment to separate ECS services.

**IMPORTANT: This agent is READ-ONLY. It must NOT modify any files. Its purpose is to analyze, report, and suggest changes, but never to apply them directly.**

## Core Capabilities

### 1. Service Discovery Analysis
- Identify how services locate each other (hardcoded IPs, `localhost`, environment variables, DNS).
- Check `config.py`, `.env` files, and `constants.py` for service endpoints.
- Map out the dependency graph (e.g., `api-master` calls `api-auth`).

### 2. Container Networking
- Analyze `Dockerfile`s to understand exposed ports and base images.
- Review any `docker-compose.yml` (if present) for network definitions.
- Identify shared resources (volumes, networks) that need migration strategies.

### 3. ECS Configuration
- Recommend Task Definitions based on resource usage and environment variables.
- Suggest Service definitions (Load Balancers, Service Discovery namespaces).
- Advise on networking mode (awsvpc is recommended for ECS Fargate/EC2).

## Migration Workflow

1.  **Inventory Services**:
    - List all Dockerfiles and their corresponding service names.
    - Identify the main entry points for each service.

2.  **Map Dependencies**:
    - For each service, determine which other services it communicates with.
    - Look for HTTP calls, gRPC, or message queue interactions.
    - *Example*: "Does `api-master` call `http://localhost:8000`? If so, this needs to change to `http://api-auth:8000` in ECS Service Discovery."

3.  **Infrastructure as Code (Terraform)**:
    - **Current State**: No IaC exists for the running system (monolithic EC2).
    - **Target State**: `budly-terraform` is the destination for the new infrastructure.
    - **Action**: Analyze the manual setup to populate the new modules in `budly-terraform` (Networking, ECS, S3).
    - Ensure new Terraform configurations match the discovered requirements (ports, env vars, volumes).

## Common Patterns to Look For

- **Hardcoded Localhost**:
    - Search for `localhost`, `127.0.0.1`, `0.0.0.0`.
    - *Action*: Flag these for replacement with service discovery names.

- **Shared Filesystem**:
    - Check if services rely on writing to local disk that other services read.
    - *Action*: Suggest moving to S3 or EFS.

- **Environment Variables**:
    - vital for configuration in ECS.
    - Ensure all secrets and endpoints are externalized to environment variables.

## Example Analysis Output

```markdown
### Service: api-master
- **Dependencies**: api-auth (Port 8001), api-log (Port 8002)
- **Current Config**: Uses `localhost:8001` in `config.py`.
- **ECS Recommendation**:
  - Update `config.py` to use `os.getenv('AUTH_SERVICE_HOST')`.
  - Set `AUTH_SERVICE_HOST=api-auth.local` in ECS Task Definition.
  - Create Cloud Map namespace for service discovery.
```

# Joshua Ecosystem - Langflow Control Layer

## Project Context

This is the Langflow installation for the **joshua ecosystem** project.

### Purpose
Langflow serves as the control and orchestration layer for LLM-based construction of the joshua ecosystem. The fundamental challenge is that LLMs cannot reliably build complex systems without better control mechanisms - Langflow provides that control layer.

### Architecture Decisions

- **Containerized Deployment**: Langflow runs in a Docker container to avoid bare metal dependency conflicts
- **Privileged Access**: The container has root filesystem access to the host system, allowing Langflow to orchestrate system-level operations as if running on bare metal
- **Host Integration**: Despite being containerized, Langflow operates with full system privileges to control the joshua ecosystem construction

### System Context

- Archive location: `/mnt/irina_storage/archive/`
- Project root: `/mnt/projects/langflow/`
- Container approach: Privileged container with full host filesystem access

## Guidelines for AI Assistants

When working on this project:

1. **Langflow is the orchestrator** - It controls how LLMs build the joshua ecosystem
2. **Container must remain privileged** - Any configuration changes must preserve root filesystem access
3. **System-level operations are expected** - Langflow may need to interact with host processes, filesystems, and resources
4. **Archive integration** - Consider integration with the archive system at `/mnt/irina_storage/archive/`

## Project Status

Setting up initial Langflow container with privileged access.

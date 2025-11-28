# Overview

Labak is a community-operated networking laboratory for students. It provides:
- A mix of physical and virtual networking resources.
- Reproducible lab exercises with standardized topologies.
- An open platform for sharing exercises, topologies, and configuration snippets.

## Core principles
- Openness: exercises and resources are version controlled and open for improvement.
- Reproducibility: labs include documented topologies and scripts to provision devices.
- Learning-first: content is tailored to help learners progress from fundamentals to advanced topics.

## Repository layout (high level)
- `api/` — lightweight local API server: `api/index.js`
- `docker/` — Dockerfiles for images used by labs: `docker/end_device/Dockerfile`
- `workflow/` — automation scripts to create/tear down lab workspaces and containers:
  - `workflow/create_workspace.sh`
  - `workflow/create_container.sh`
  - `workflow/cleanup_workspace.sh`
- `docs/` — this documentation.

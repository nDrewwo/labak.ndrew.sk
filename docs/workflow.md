# Workflow — automation for lab end devices

## Purpose
- Automate creation and teardown of lab end devices using Docker containers to make labs reproducible and easy to provision.

## Key scripts
- `workflow/create_workspace.sh` — sets up workspace directories and initial files.
- `workflow/create_container.sh` — builds/starts Docker-based end devices (uses `docker/end_device/Dockerfile`).
- `workflow/cleanup_workspace.sh` — removes containers and temp files.

## How it works (high level)
1. The workspace script prepares configuration files and directories.
2. The container script builds a Docker image from `docker/end_device/Dockerfile` and runs containers representing end devices.
3. Containers are networked according to lab topology scripts or docker network settings included in the workflow scripts.
4. The cleanup script stops and removes containers and resets state.

## Extending
- Add new end-device images in `docker/`.
- Add topology orchestration (docker-compose, or a small orchestration layer) if you need multi-container topologies.
- Consider adding a lightweight API hook in `api/index.js` to report status or orchestrate runs.

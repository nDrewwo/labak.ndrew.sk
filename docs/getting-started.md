# Getting started

## Prerequisites
- Docker (Engine)
- Git
- Bash shell (or compatible)

### 1) Clone repo
```sh
git clone <repo-url>
cd <repo-directory>
```

### 2) Prepare workspace
Run the workspace creation script which sets up folders and any initial configuration:
```sh
./workflow/create_workspace.sh
```

### 3) Review configuration
- Example config: `workflow/ws1.ini.sample`
- Edit as needed before provisioning devices.

### 4) Create an end-device container
The project automates end device creation using Docker containers built from:
- `docker/end_device/Dockerfile`

Run:
```sh
./workflow/create_container.sh
```

### 5) Interact with local API (if applicable)
A small API helper lives at `api/index.js`. Use it for automation hooks or status queries.

### 6) Cleanup
Tear down containers and temporary files:
```sh
./workflow/cleanup_workspace.sh
```

If you hit issues: open an issue or follow the contribution guidelines in `docs/contributing.md`.

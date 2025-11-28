# Labak

Labak is a student-driven initiative to create a dedicated space for learning, experimenting, and collaborating in the field of computer networking. The project combines hands-on infrastructure (physical and virtual networking devices) with a community-driven knowledge base where learners and contributors can design, share, and improve networking exercises.

## Goals
- Provide access to diverse networking platforms beyond vendor-specific curricula.
- Offer structured lab exercises with standardized topologies, configurations, and documentation.
- Encourage collaboration through open contribution standards and version-controlled resources.
- Serve as a long-term, evolving hub for networking enthusiasts within the school community.

## Quick links
- Project docs: `docs/overview.md`
- Automation scripts: `workflow/create_workspace.sh`, `workflow/create_container.sh`, `workflow/cleanup_workspace.sh`
- Docker end device image: `docker/end_device/Dockerfile`
- Local API entry: `api/index.js`
- License: `LICENSE`

## Quickstart (minimal)
1. Install Docker and Git.
2. Clone the repo and open it:
   - `git clone <repo-url>`
3. Prepare workspace (creates folders / initial files):
   - `./workflow/create_workspace.sh`
4. Create an end-device container (automated):
   - `./workflow/create_container.sh`
5. Clean up workspace:
   - `./workflow/cleanup_workspace.sh`

See `docs/getting-started.md` for a more detailed onboarding and `docs/workflow.md` for how the automation works.

## Contributing
- See `docs/contributing.md`.
- This repository is licensed; see `LICENSE` for details.
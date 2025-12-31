---
title: "Naming Conventions"
date: 2025-11-12
authors:
  - "ndrew"
series: ["Standards"]
tags: ["naming"]
series_order: 2
---
## Purpose
Guidance for consistent, machine-friendly naming across content, assets and branches used by the platform. The goal is predictable, searchable and URL-safe names. Prefer **kebab-case** (lowercase words separated by hyphens) for slugs and filenames.

## Content Naming
Keep the descriptive part kebab-cased.

### Labs
- File pattern: `content/labs/LAB-XXXX-descriptive-name.md`
  - Example: `content/labs/LAB-0001-static-routing.md`
  - Notes: Keep the `LAB-XXXX` prefix (uppercase as a convention) and use kebab-case for the descriptive name.

### Theory
- File pattern: `content/theory/THEORY-XXXX-descriptive-topic.md`
  - Example: `content/theory/THEORY-0001-osi-model.md`

### Guides
- File pattern: `content/guides/GUIDE-descriptive-name.md`
  - Example: `content/guides/GUIDE-docker-setup.md`

### Projects
- File pattern: `content/projects/PROJECT-YYYY-author-shortname.md`
  - Example: `content/projects/PROJECT-2024-ndrew-network-simulator.md`

### Blog posts
- File pattern: `content/blog/YYYY-MM-DD-slug.md`
  - Example: `content/blog/2024-01-15-new-year-announcement.md`

### Standards
- File pattern: `content/standards/STANDARD-XXXX-descriptive-name.md` (or `STANDARD-descriptive-name.md`)
  - Example: `content/standards/STANDARD-0001-topology-diagrams.md`

## Asset Naming (images, diagrams, machine files)
- See [Asset Managment](/standards/standard-0003-asset-managment/) for full asset naming, versioning and CDN guidance.

## Filenames & Directory rules
- Use kebab-case for directories and filenames except where a formal uppercase prefix is required (e.g., `LAB-0001-...`, `THEORY-...`).
- Keep filenames short but descriptive; prefer clarity over brevity.
- Avoid punctuation, underscores, and spaces in filenames.

## Correct vs Incorrect examples
Correct:
```
LAB-0001-static-routing.md
GUIDE-docker-setup.md
content/blog/2024-01-01-site-launch.md
materials/labs/LAB-0001-static-routing/v1/diagrams/topology.svg
```
Incorrect:
```
lab_0001_static_routing.md
LAB 0001 static routing.md
GuideDockerSetup.md
content/blog/site Launch.md
```

## Front matter
- Follow the platform front matter template and keep `title`, `date`, `authors`, `tags`, and `description` consistent.

## See also
- [Git Workflow](/standards/standard-0005-git-worklow/) — for branches, commit and PR naming conventions
- [Topology Diagrams](/standards/standard-0004-topology-diagrams/) - for diagram export and style guidelines
- [Asset Managment](/standards/standard-0003-asset-managment/)— for asset naming, versioning and CDN guidance

## Quick reference
- Preferred: **kebab-case** for descriptive names
- Keep formal prefixes (LAB/THEORY/GUIDE/PROJECT) as required, then kebab-case


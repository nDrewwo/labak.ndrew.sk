---
title: "Asset Management"
date: 2025-11-12
authors:
  - "ndrew"
tags: ["assets", "filebrowser"]
series: ["Standards"]
series_order: 3
---

## Purpose
Guidance for storing, naming, versioning and referencing assets (diagrams, images, machine files).

## Structure
Keep assets under a versioned directory alongside content or projects; examples:

```
materials/
└── labs/
    └── LAB-static-routing/
        └── v1/
            └── diagrams/
                ├── topology.drawio
                └── topology.svg
```

## Naming
- Asset filenames: `kebab-case.ext` (e.g., `topology.drawio`, `topology.svg`, `device-configs.tar.gz`).
- Use only lowercase letters, digits and hyphens in filenames. Avoid spaces, underscores and punctuation.

## Versioning & Sources
- Use `v1`, `v2`, ... for major versions of a lab/project and keep source files (e.g., `.drawio`) next to exports (`.svg`, `.png`).
- Keep original editable sources committed or stored alongside exported assets to allow updates and provenance.

## CDN & Referencing
- Upload final exports to the CDN and reference them by stable CDN URLs in content to avoid breakage when files move.
- Prefer referencing assets from CDN/filebrowser rather than embedding large binaries in content files.

## Examples
Correct:
```
materials/labs/LAB-static-routing/v1/diagrams/topology.svg
materials/projects/PRJ-example/v2/assets/device-configs.tar.gz
```
Incorrect:
```
Lab-static-routing/topology.svg
topology_final (2).svg
image 1.png
```

## See also
- [Naming Convetnions](/standards/standard-naming-conventions/) — for general naming rules
- [Topology Diagrams](/standards/standard-topology-diagrams/) — for diagram export and style guidelines
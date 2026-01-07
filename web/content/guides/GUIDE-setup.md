---
title: "Setting up your environment for contributing"
date: 2026-01-03
description: ""
authors:
  - "ndrew"
tags: ["git","docker","hugo","blowfish"]
---

## Overview
This guide explains how to prepare your machine to contribute to the repository: installing and verifying Git, installing Hugo for building the site, and installing the project utility package (Blowfish Tools).

## Git

### Install
- Linux: follow installation for your distro [here](https://git-scm.com/install/linux)
- macOS (Homebrew): `brew install git`
- Windows: download and run the installer from [here](https://git-scm.com/install/windows)

### Configure
Set your name and email used for commits:
```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

### Verify
```bash
git --version
git config --list
```

## Hugo

Hugo is used to build the static site in the `web/` folder.

### Install
- Linux: follow the instructions [here](https://gohugo.io/installation/linux/)
- macOS: follow the instructions [here](https://gohugo.io/installation/macos/)
- Windows: follow the instructions [here](https://gohugo.io/installation/windows/)

### Verify
```bash
hugo version
```

## Blowfish Tools

Blowfish Tools is an official CLI that helps you initialise and configure a Blowfish-based Hugo site. It can create a new Hugo project, install the Blowfish theme, and configure the theme files for you.

### Prerequisites
- Node.js and npm (the CLI is distributed via npm)
- Hugo installed for commands that build or run the site (see the Hugo section above)

### Install
- Run without installing globally (recommended for one-off runs):
```bash
npx blowfish-tools
```
- Install globally using npm:
```bash
npm install -g blowfish-tools
```
### Verify
Start the interactive setup (recommended):
```bash
blowfish-tools
```
This launches an interactive prompt that guides you through creating or configuring a site.
Non-interactive / CI usage and help:
```bash
blowfish-tools --help
```

## Docker

Docker is used in this repository for building and running components (see the `docker/` folder). For installation and platform-specific instructions, follow the official Docker documentation:

### Install
- Linux - [here](https://docs.docker.com/desktop/setup/install/linux/)
- MacOS - [here](https://docs.docker.com/desktop/setup/install/mac-install/)
- Windows - [here](https://docs.docker.com/desktop/setup/install/windows-install/)

### Verify
```bash
docker --version
docker run --rm hello-world
```
If `hello-world` runs successfully your Docker installation is functional.

---

## Verify your setup

- Run `git --version`, `hugo version` and `blowfish-tools` to confirm everything is accessible from your shell.


## See Also

- [Git](https://git-scm.com/)
- [Hugo](https://gohugo.io/)
- [Blowfish Theme](https://blowfish.page/)
- [Docker](https://docs.docker.com/)

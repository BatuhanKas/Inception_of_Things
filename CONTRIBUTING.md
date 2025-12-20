# Contributing to IoT Project

Thank you for your interest in contributing to this IoT project! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)

## Code of Conduct

This project adheres to a code of conduct that all contributors are expected to follow. Please be respectful and constructive in your interactions.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/iot.git`
3. Add upstream remote: `git remote add upstream https://github.com/BatuhanKas/iot.git`
4. Create a new branch: `git checkout -b feature/your-feature-name`

## Development Setup

### Prerequisites

- [Vagrant](https://www.vagrantup.com/) (latest version)
- [VirtualBox](https://www.virtualbox.org/) or another Vagrant provider
- [kubectl](https://kubernetes.io/docs/tasks/tools/) for Kubernetes management
- Git

### Project Structure

- `p1/` - Part 1: K3s cluster setup with server and worker nodes
- `p2/` - Part 2: K3s with application deployments and services
- Each part contains:
  - `Vagrantfile` - VM configuration
  - `scripts/` - Installation scripts
  - `manifests/` - Kubernetes manifest files (p2)

### Setting Up Development Environment

```bash
# Navigate to the project directory
cd p1  # or p2, depending on what you're working on

# Start the Vagrant environment
vagrant up

# SSH into the server
vagrant ssh <machine-name>

# Check cluster status
kubectl get nodes
```

## How to Contribute

### Reporting Bugs

- Use the GitHub issue tracker
- Describe the bug in detail
- Include steps to reproduce
- Mention your environment (OS, Vagrant version, etc.)
- Include relevant logs or error messages

### Suggesting Enhancements

- Open an issue with the label "enhancement"
- Clearly describe the feature and its benefits
- Provide examples or use cases

### Contributing Code

1. Check existing issues and pull requests
2. Open an issue to discuss major changes
3. Follow the coding standards
4. Write clear commit messages
5. Submit a pull request

## Coding Standards

### Shell Scripts

- Use `#!/bin/bash` or `#!/bin/sh` shebang
- Add comments for complex logic
- Use meaningful variable names
- Handle errors appropriately
- Make scripts idempotent when possible

### Kubernetes Manifests

- Use proper YAML formatting (2 spaces for indentation)
- Include descriptive labels and annotations
- Add comments for complex configurations
- Follow Kubernetes best practices
- Specify resource limits when applicable

### Vagrantfile

- Keep configurations clean and organized
- Comment non-obvious settings
- Use variables for repeated values
- Document required plugins or providers

## Commit Guidelines

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Formatting, missing semicolons, etc.
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

### Examples

```
feat(p2): add app2 deployment with ingress routing

Add a second application deployment with service and update
ingress configuration to route traffic based on hostname.

Closes #123
```

```
fix(p1): resolve k3s token synchronization issue

Fix timing issue where worker node starts before server token
is fully available.
```

## Pull Request Process

1. **Update your branch**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Ensure your code works**
   - Test your changes locally
   - Run `vagrant up` to verify VM setup
   - Check Kubernetes deployments with `kubectl`

3. **Create a Pull Request**
   - Use the PR template
   - Provide a clear title and description
   - Reference related issues
   - Add screenshots or logs if relevant

4. **Code Review**
   - Address review comments
   - Keep the discussion focused and professional
   - Update your PR as needed

5. **Merge Requirements**
   - All CI checks must pass
   - At least one approval from maintainers
   - No merge conflicts
   - Branch up to date with main

## Testing

### Manual Testing

Before submitting a PR, test your changes:

```bash
# Clean up existing environment
vagrant destroy -f

# Start fresh
vagrant up

# Verify functionality
vagrant ssh <machine-name>
kubectl get all -A
```

### Testing Checklist

- [ ] VMs start successfully
- [ ] K3s cluster initializes properly
- [ ] All pods are running
- [ ] Services are accessible
- [ ] Ingress routing works (p2)
- [ ] No error messages in logs

## Questions?

If you have questions or need help:

- Open an issue with the "question" label
- Check existing documentation
- Review closed issues for similar questions

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to this project! 🚀

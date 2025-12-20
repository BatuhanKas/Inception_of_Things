## Description

<!-- Provide a brief description of the changes in this PR -->

## Type of Change

<!-- Mark the relevant option with an "x" -->

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Configuration change
- [ ] Refactoring (no functional changes)
- [ ] Performance improvement

## Related Issue

<!-- Link to the issue this PR addresses -->
Fixes #(issue number)

## Changes Made

<!-- List the specific changes made in this PR -->

- 
- 
- 

## Project Part

<!-- Mark which part of the project this affects -->

- [ ] p1 (K3s cluster setup)
- [ ] p2 (K3s with applications)
- [ ] General/Both
- [ ] Documentation only

## Testing Performed

<!-- Describe the testing you performed to verify your changes -->

### Test Environment

- OS: <!-- e.g., macOS, Linux, Windows -->
- Vagrant Version: <!-- e.g., 2.4.0 -->
- Provider: <!-- e.g., VirtualBox 7.0 -->

### Test Steps

<!-- List the steps you followed to test -->

1. 
2. 
3. 

### Test Results

```
# Paste relevant output here (kubectl get nodes, kubectl get pods, etc.)

```

## Checklist

<!-- Mark completed items with an "x" -->

- [ ] My code follows the project's coding standards
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings or errors
- [ ] I have tested my changes in a clean environment (`vagrant destroy -f && vagrant up`)
- [ ] All VMs start successfully
- [ ] K3s cluster initializes properly
- [ ] All pods are in Running state
- [ ] Services are accessible as expected
- [ ] Ingress routing works correctly (if applicable)
- [ ] I have checked logs for errors

## Screenshots / Logs

<!-- If applicable, add screenshots or relevant log outputs -->

<details>
<summary>Click to expand</summary>

```
# Paste logs or add screenshots here

```

</details>

## Breaking Changes

<!-- If this PR introduces breaking changes, describe them and the migration path -->

N/A

## Additional Notes

<!-- Any additional information that reviewers should know -->

## Reviewers

<!-- Tag specific reviewers if needed -->
@BatuhanKas

---

<!-- Thank you for your contribution! -->

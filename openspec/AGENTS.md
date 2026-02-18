# OpenSpec Workflow

OpenSpec is a spec-driven development framework for managing infrastructure changes with AI assistance.

## Three-Stage Workflow

### Stage 1: Create (Proposal)
**Trigger**: New infrastructure change request

1. Create change directory: `openspec/changes/[change-id]/`
2. Write `proposal.md` - why, what, and impact assessment
3. Write `tasks.md` - implementation checklist
4. Write `design.md` - technical decisions

### Stage 2: Implement
**Trigger**: Proposal approved

1. Create feature branch: `openspec/[change-id]`
2. Implement changes following tasks.md
3. Create PR with OpenSpec reference

### Stage 3: Archive
**Trigger**: Changes deployed and verified

1. Move specs to canonical location
2. Archive the change proposal
3. Close related issues

## Change Directory Structure

```
openspec/changes/[change-id]/
├── proposal.md         # Why and what
├── tasks.md            # Implementation checklist
└── design.md           # Technical decisions
```

## Integration with GitHub

1. **Issues**: Create GitHub issue for each change
2. **PRs**: Reference OpenSpec change-id in PR description
3. **Labels**: Use `openspec` label for related issues/PRs

## Related Resources

- [EHA Cloud DevOps - OpenSpec Guide](https://github.com/eHealthAfrica/eha-cloud-devops/blob/main/openspec/AGENTS.md)

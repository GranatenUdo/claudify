# Claudify Versioning Strategy

## Overview

Claudify follows [Semantic Versioning](https://semver.org/) (SemVer) to ensure clear communication about changes and compatibility.

## Version Format

**MAJOR.MINOR.PATCH** (e.g., 1.2.3)

- **MAJOR**: Incompatible API changes or breaking changes
- **MINOR**: New functionality in a backwards compatible manner
- **PATCH**: Backwards compatible bug fixes

## Version Guidelines

### When to increment MAJOR (X.0.0)
- Breaking changes to command structure or behavior
- Removal of existing components
- Changes requiring manual migration
- Incompatible changes to component manifest structure

### When to increment MINOR (1.X.0)
- Adding new commands or agents
- Adding new features to existing components
- Enhancing functionality without breaking existing usage
- Adding new optional parameters

### When to increment PATCH (1.0.X)
- Bug fixes
- Documentation updates
- Performance improvements
- Security patches that don't break compatibility

## Release Process

### 1. Pre-release Checklist
- [ ] All tests pass
- [ ] Documentation is updated
- [ ] CHANGELOG.md is updated
- [ ] No breaking changes in patch/minor releases

### 2. Version Update Steps
1. **Update VERSION file**
   ```bash
   echo "1.1.0" > VERSION
   ```

2. **Update CHANGELOG.md**
   - Move items from [Unreleased] to new version section
   - Add release date
   - Summarize key changes

3. **Commit version changes**
   ```bash
   git add VERSION CHANGELOG.md
   git commit -m "chore: Release version 1.1.0"
   ```

5. **Tag the release**
   ```bash
   git tag -a v1.1.0 -m "Release version 1.1.0"
   git push origin v1.1.0
   ```

6. **Create GitHub Release**
   - Use the tag created above
   - Copy relevant section from CHANGELOG.md
   - Attach any release artifacts if needed

## Version Checking

### In setup.ps1
The setup script automatically displays the current version from the VERSION file.

### In init-claudify
The initialization command checks and displays:
- Current Claudify version
- Components manifest version
- Last update date

## Compatibility Considerations

### Backwards Compatibility
- Minor and patch releases MUST maintain backwards compatibility
- Existing commands and parameters must continue to work
- Deprecation warnings should be added before removal

### Future Compatibility
- Design changes with extensibility in mind
- Use configuration files rather than hardcoded values
- Document any assumptions about Claude Code versions

## Version History Tracking

### CHANGELOG.md Structure
```markdown
## [Unreleased]
### Added
- New features not yet released

## [1.1.0] - 2025-07-28
### Added
- New command X
### Changed
- Enhanced feature Y
### Fixed
- Bug in component Z
```

### Components Tracking
Each component can optionally include its own version:
```json
{
  "name": "code-reviewer",
  "version": "1.0.0",
  "lastUpdated": "2025-07-27"
}
```

## Best Practices

1. **Frequent Releases**: Release often with smaller changes
2. **Clear Communication**: Use descriptive commit messages and changelog entries
3. **Testing**: Ensure all components work together before release
4. **Documentation**: Update docs with every feature change
5. **User Notice**: Consider how users will discover updates

## Version Deprecation

When deprecating features:
1. Add deprecation notice in current version
2. Provide migration path in documentation
3. Support deprecated feature for at least one minor version
4. Remove in next major version

## Questions?

For questions about versioning or the release process, please open an issue in the Claudify repository.
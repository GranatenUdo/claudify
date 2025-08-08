---
description: Update CHANGELOG.md with recent changes following Keep a Changelog format
allowed-tools: [Read, Write, Edit, MultiEdit, Grep, TodoWrite]
argument-hint: change description (e.g., "Added user authentication module" or "Fixed critical bug in payment processing")
complexity: low
estimated-time: 2-5 minutes
category: documentation
---

# Update Changelog

I'll update the CHANGELOG.md file with your recent changes following the [Keep a Changelog](https://keepachangelog.com/) format.

## Understanding Your Change

Let me analyze your change request: **$ARGUMENTS**

<think about the type of change and which section it belongs to>

Based on your description, I'll categorize this change and update the appropriate section.

## Checking Current Changelog

First, let me read the current CHANGELOG.md to understand its structure:

@Read(file_path="CHANGELOG.md", limit=100)

## Determining Change Category

<think about which category this change belongs to>

Your change appears to be:
- **Added**: New features or capabilities
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Vulnerability fixes

## Updating Changelog

I'll add your change to the appropriate section under [Unreleased]:

@Edit(file_path="CHANGELOG.md", old_string="[SECTION_MARKER]", new_string="[SECTION_MARKER]
- $FORMATTED_CHANGE_DESCRIPTION")

### Formatting Guidelines

I follow these conventions:
- Start with a verb (Added, Fixed, Changed, etc.)
- Use present tense
- Capitalize first letter
- No period at the end
- Include component name when relevant
- Group related changes together

### Change Entry Format

For complex changes, I'll use sub-items:
```markdown
- **Component Name**
  - Specific change 1
  - Specific change 2
  - Impact or technical details
```

## Verification

Let me verify the update was successful:

@Read(file_path="CHANGELOG.md", offset=[UPDATED_LINE], limit=10)

## Best Practices Applied

✅ **Categorized correctly** under the appropriate section
✅ **Formatted consistently** with existing entries
✅ **Descriptive yet concise** change description
✅ **Chronologically ordered** (newest first in each section)
✅ **User-focused** language (what changed, not how)

## Next Steps

1. When ready to release, move items from [Unreleased] to a new version section
2. Add the version number and date: `## [1.2.0] - 2024-01-27`
3. Keep [Unreleased] section at the top for ongoing work
4. Consider using semantic versioning:
   - MAJOR: Breaking changes
   - MINOR: New features (Added)
   - PATCH: Bug fixes (Fixed)

## Automation Tip

To ensure changelog updates aren't forgotten:
1. Update after each significant change
2. Include in your PR checklist
3. Use git hooks for reminders
4. Review during sprint retrospectives

Your CHANGELOG.md has been updated successfully! This helps users and developers track the evolution of your project.
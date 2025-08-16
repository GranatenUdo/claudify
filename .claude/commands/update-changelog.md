---
description: Smart changelog update with git analysis
allowed-tools: [Task, Read, Edit, Bash]
estimated-time: 30 seconds (parallel)
complexity: simple
category: documentation
---

# 📝 Update Changelog: $ARGUMENTS

## Parallel Analysis & Update (30 seconds)

@Task(
  description="Analyze changes",
  prompt="Analyze '$ARGUMENTS' for changelog:
  
  DETERMINE:
  1. Category (Added/Changed/Fixed/Security/Removed)
  2. Impact level (Major/Minor/Patch)
  3. Related files changed
  4. Breaking changes if any
  
  FORMAT: Concise, verb-first entry
  OUTPUT: Properly categorized changelog entry",
  subagent_type="technical-documentation-writer"
)

@Bash(command="git diff --name-status HEAD~1", description="Recent changes")
@Bash(command="git log --oneline -5", description="Recent commits")

@Edit(
  file_path="CHANGELOG.md",
  old_string="## [Unreleased]",
  new_string="## [Unreleased]\n\n### [CATEGORY]\n- $ARGUMENTS"
)

## ✅ Complete
Changelog updated with proper categorization.
---
name: update-comprehensive-feature
model: opus
think-mode: think_hard
description: Update existing feature across entire stack with comprehensive analysis, testing, and validation
allowed-tools: [Task, Read, Write, Edit, MultiEdit, Grep, Glob, LS, TodoWrite, Bash]
argument-hint: feature update description (e.g., "update authentication to support OAuth 2.0")
---

# 🔄 Update Comprehensive Feature: $ARGUMENTS

## Optimization Features
- **Multi-Agent Orchestration**: Parallel analysis by specialized Frontend, Backend, and Security agents
- **Backward Compatibility**: Careful preservation of existing functionality during updates
- **Impact Analysis**: Deep assessment of all affected components and integrations
- **Progressive Enhancement**: Incremental updates with feature flags and gradual rollout
- **Comprehensive Testing**: 100% test coverage with unit, integration, and end-to-end validation
- **Risk Mitigation**: Multiple validation checkpoints and rollback strategies

## 🧠 OPUS 4 ENHANCED THINKING MODE


### Cognitive Enhancement Triggers
- **Impact Analysis**: Deep understanding of all affected components
- **Backward Compatibility**: Maintaining existing functionality while adding new
- **Test Coverage**: Ensuring 100% success rate with comprehensive testing
- **Cloud Optimization**: No performance monitoring, cloud-native approach

## Phase 0: Comprehensive Discovery & Planning



### Initial Impact Analysis
I'll perform a comprehensive analysis to understand the full scope of changes needed.

```bash
# Parallel discovery operations
Searching for pattern: $FEATURE_PATTERN
Finding files matching: **/*$FEATURE*.*
Finding files matching: **/*.test.*
Finding files matching: **/*.spec.*
```

### TodoWrite Planning
Creating comprehensive task list for systematic updates:

I'll update the task list to track our progress.

## Phase 1: Parallel Multi-Agent Analysis



### Comprehensive Feature Analysis
Launching all specialized agents in parallel for maximum efficiency:

I'll have the general-purpose agent Architecture impact analysis.

I'll have the Frontend Developer agent Frontend update analysis.

I'll have the general-purpose agent Security validation.

I'll have the general-purpose agent Code quality assessment.

I'll have the general-purpose agent Test strategy planning.

## Phase 2: Implementation Strategy



### Implementation Sequence
Based on agent analyses, I'll implement updates in this order:

1. **Shared/Common Components** (Foundation)
   - Update shared models and interfaces
   - Modify utility functions
   - Update configuration files

2. **Backend Updates** (Core Logic)
   - Update domain models
   - Modify business logic
   - Update repository layer
   - Modify service layer
   - Update API endpoints

3. **Frontend Updates** (User Interface)
   - Update services and models
   - Modify components
   - Update templates
   - Enhance styling

4. **Integration Updates** (Connections)
   - Update API contracts
   - Modify integration points
   - Update message formats

## Phase 3: Backward Compatibility Enforcement



### Compatibility Strategies

#### API Versioning
```typescript
// Maintain both versions temporarily
Using Controller tool for this operation. // Existing
class FeatureV1Controller { }

Using Controller tool for this operation. // Updated
class FeatureV2Controller { }
```

#### Database Migrations
```sql
-- Add new columns as nullable
ALTER TABLE features ADD COLUMN new_field VARCHAR(255) NULL;

-- Populate with defaults
UPDATE features SET new_field = COALESCE(old_field, 'default');

-- Mark deprecated in next release
-- ALTER TABLE features DROP COLUMN old_field; -- Future
```

#### Feature Flags
```typescript
if (featureFlags.useNewImplementation) {
    return this.newFeatureImplementation();
} else {
    return this.legacyFeatureImplementation();
}
```

## Phase 4: Comprehensive Test Generation



### Test Implementation Strategy

#### Unit Test Generation
```typescript
describe('Updated Feature', () => {
    // Backward compatibility tests
    describe('Legacy Behavior', () => {
        it('should maintain existing functionality', async () => {
            // Test old behavior still works
        });
    });
    
    // New functionality tests
    describe('New Behavior', () => {
        it('should implement new requirements', async () => {
            // Test new features
        });
    });
    
    // Edge cases
    describe('Edge Cases', () => {
        it('should handle null values gracefully', async () => {});
        it('should handle boundary conditions', async () => {});
        it('should handle concurrent updates', async () => {});
    });
    
    // Error scenarios
    describe('Error Handling', () => {
        it('should handle network failures', async () => {});
        it('should handle validation errors', async () => {});
        it('should handle authorization failures', async () => {});
    });
});
```

#### Integration Test Generation
```typescript
describe('Feature Integration', () => {
    describe('API Integration', () => {
        it('should work with v1 API', async () => {});
        it('should work with v2 API', async () => {});
        it('should handle version negotiation', async () => {});
    });
    
    describe('Database Integration', () => {
        it('should read legacy data', async () => {});
        it('should write new format', async () => {});
        it('should migrate data correctly', async () => {});
    });
    
    describe('Service Integration', () => {
        it('should integrate with auth service', async () => {});
        it('should integrate with notification service', async () => {});
        it('should handle service failures gracefully', async () => {});
    });
});
```

## Phase 5: Implementation Execution

### Step-by-step Implementation

For each component identified in Phase 1:

1. **Read Current Implementation**
   ```bash
   Reading file: [component_path]
   ```

2. **Create Backup Branch**
   ```bash
   Running command: `git checkout -b update-$ARGUMENTS-backup`
   ```

3. **Apply Updates with MultiEdit**
   ```typescript
   Making multiple edits to the file.
   ```

4. **Generate Tests**
   ```bash
   Creating/updating file: [test_path]
   ```

5. **Run Tests Until Success**
   ```bash
   while (testResult.success < 100%) {
       Running command: `npm test [test_file]`
       // Fix any failures
       Editing the file with the necessary changes.
   }
   ```

## Phase 6: Validation & Completion

### Success Criteria Validation

```yaml
Completion Checklist:
  ✓ All components updated successfully
  ✓ Backward compatibility maintained
  ✓ All unit tests passing (100%)
  ✓ All integration tests passing (100%)
  ✓ Security scan passed
  ✓ Code quality metrics improved
  ✓ Documentation updated
  ✓ No performance monitoring added
  ✓ Cloud-ready implementation
```

### Confidence Score Calculation
```markdown

## Documentation Updates

<think about what documentation needs updating based on the changes made>

### Update Checklist
Based on the changes made, update these files:

1. **CHANGELOG.md** (Confidence: 95%)
   - Add entry under `[Unreleased]` section
   - Use appropriate section: Added/Changed/Fixed/Removed
   - Include technical details and user impact

2. **FEATURES.md** (If capabilities changed)
   - Document new or modified features
   - Update technical implementation details
   - Include usage examples

3. **CLAUDE.md** (If patterns/conventions introduced)
   - Document new code patterns
   - Update architectural decisions
   - Add domain-specific rules

### Quick Update Commands
```bash
# Automated changelog update
/update-changelog "$ARGUMENTS"

# Manual update template
### [Section]
- Description of change
  - Technical implementation details
  - User-facing impact
  - Breaking changes (if any)
```

### Parallel Documentation Check
Check all documentation files simultaneously for existing references:
```bash
Searching for pattern: $ARGUMENTS
Searching for pattern: $ARGUMENTS
Searching for pattern: $ARGUMENTS
```

## Final Confidence Score: [X]%

Factors:
- Component coverage: [100%]
- Test success rate: [100%]
- Backward compatibility: [Verified]
- Security validation: [Passed]
- Code quality: [Improved]

✅ Feature update completed with ≥99% confidence
```

## Phase 7: Continuous Validation Loop



### Iterative Refinement
```bash
do {
    runAllTests();
    if (failures.exist()) {
        analyzeFailures();
        fixIssues();
        updateTests();
    }
    calculateConfidence();
} while (confidence < 99% || testSuccess < 100%);
```

### Final Verification
- Run full test suite one more time
- Verify no regressions introduced
- Confirm all new features working
- Validate backward compatibility
- Check cloud readiness (no monitoring)

## Interactive Checkpoints

### Checkpoint 1: Discovery Complete
```markdown
Components identified: [X]
Impact assessment: [Complete]
Risk level: [Low|Medium|High]
Proceed? (yes/no/modify)
```

### Checkpoint 2: Implementation Progress
```markdown
Backend updates: [X/Y completed]
Frontend updates: [X/Y completed]
Tests generated: [X/Y completed]
Current confidence: [X%]
```

### Checkpoint 3: Final Validation
```markdown
All tests passing: [Yes/No]
Backward compatibility: [Verified]
Security validated: [Passed]
Ready for deployment: [Yes/No]
```

## Completion Guarantee

This command will not conclude until:
1. All identified components are successfully updated
2. 100% of tests are passing
3. Backward compatibility is verified
4. Security validation passes
5. Confidence score ≥99%

The command uses continuous validation loops and iterative refinement to ensure complete success before terminating.
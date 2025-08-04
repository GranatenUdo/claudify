---
description: Update existing feature across entire stack with comprehensive analysis, testing, and validation
allowed-tools: [Task, Read, Write, Edit, MultiEdit, Grep, Glob, LS, TodoWrite, Bash]
argument-hint: feature update description (e.g., "update authentication to support OAuth 2.0")
agent-dependencies: [Tech Lead, Frontend Developer, Security Reviewer, Code Reviewer, Test Quality Analyst]
complexity: high
estimated-time: 30-45 minutes
category: development
---

# 🔄 Update Comprehensive Feature: $ARGUMENTS

## 🧠 OPUS 4 ENHANCED THINKING MODE
<think harder about the complete impact of updating this feature across all layers while maintaining system stability and ensuring 100% test success>

### Cognitive Enhancement Triggers
- **Impact Analysis**: Deep understanding of all affected components
- **Backward Compatibility**: Maintaining existing functionality while adding new
- **Test Coverage**: Ensuring 100% success rate with comprehensive testing
- **Cloud Optimization**: No performance monitoring, cloud-native approach

## Phase 0: Comprehensive Discovery & Planning

<think step-by-step about identifying all components that need updating>

### Initial Impact Analysis
I'll perform a comprehensive analysis to understand the full scope of changes needed.

```bash
# Parallel discovery operations
@Grep(pattern="$FEATURE_PATTERN", output_mode="files_with_matches")
@Glob(pattern="**/*$FEATURE*.*")
@Glob(pattern="**/*.test.*")
@Glob(pattern="**/*.spec.*")
```

### TodoWrite Planning
Creating comprehensive task list for systematic updates:

@TodoWrite(todos=[
  {id: "1", content: "Analyze current feature implementation", status: "pending", priority: "high"},
  {id: "2", content: "Identify all affected components", status: "pending", priority: "high"},
  {id: "3", content: "Design backward-compatible updates", status: "pending", priority: "high"},
  {id: "4", content: "Update backend components", status: "pending", priority: "high"},
  {id: "5", content: "Update frontend components", status: "pending", priority: "high"},
  {id: "6", content: "Update shared/common components", status: "pending", priority: "high"},
  {id: "7", content: "Generate comprehensive unit tests", status: "pending", priority: "high"},
  {id: "8", content: "Generate integration tests", status: "pending", priority: "high"},
  {id: "9", content: "Run all tests until 100% pass", status: "pending", priority: "high"},
  {id: "10", content: "Validate backward compatibility", status: "pending", priority: "high"}
])

## Phase 1: Parallel Multi-Agent Analysis

<think harder about orchestrating multiple agents for comprehensive analysis>

### Comprehensive Feature Analysis
Launching all specialized agents in parallel for maximum efficiency:

@Task(description="Architecture impact analysis", prompt="Analyze the architectural impact of updating $ARGUMENTS:
1. Identify all system boundaries affected
2. Map data flow changes required
3. Assess scalability implications
4. Define transaction boundary updates
5. Evaluate caching strategy changes
6. Identify integration point modifications
7. Assess database schema impacts
8. Plan migration strategy for existing data
9. Define rollback procedures
10. Calculate technical debt impact
Provide detailed technical blueprint with risk assessment", subagent_type="Tech Lead")

@Task(description="Frontend update analysis", prompt="Analyze frontend updates needed for $ARGUMENTS:
1. Component hierarchy changes
2. State management updates
3. Route modifications required
4. UI/UX improvements needed
5. Accessibility enhancements
6. Form validation updates
7. API integration changes
8. Error handling improvements
9. Loading state optimizations
10. Responsive design updates
Provide implementation plan with Angular 19 best practices", subagent_type="Frontend Developer")

@Task(description="Security validation", prompt="Perform security analysis for updating $ARGUMENTS:
1. Authentication/authorization changes
2. Data validation updates required
3. Input sanitization improvements
4. OWASP compliance verification
5. Multi-tenant isolation validation
6. Audit trail requirements
7. Encryption needs assessment
8. Token management updates
9. Session handling changes
10. Vulnerability assessment
Classify all findings by severity and provide mitigation strategies", subagent_type="Security Reviewer")

@Task(description="Code quality assessment", prompt="Review code quality for $ARGUMENTS update:
1. Current code complexity metrics
2. Refactoring opportunities
3. Design pattern improvements
4. SOLID principle adherence
5. Dependency management
6. Error handling patterns
7. Logging strategy updates
8. Configuration management
9. Documentation requirements
10. Naming convention compliance
Provide prioritized improvement recommendations", subagent_type="Code Reviewer")

@Task(description="Test strategy planning", prompt="Design comprehensive test strategy for $ARGUMENTS update:
1. Unit test coverage gaps
2. Integration test scenarios
3. E2E test requirements
4. Performance test needs
5. Security test scenarios
6. Regression test suite
7. Mock/stub requirements
8. Test data management
9. CI/CD pipeline updates
10. Quality gate definitions
Provide test implementation plan with 100% success criteria", subagent_type="Test Quality Analyst")

## Phase 2: Implementation Strategy

<think step-by-step about implementation order to minimize risk>

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

<think harder about maintaining backward compatibility while adding new features>

### Compatibility Strategies

#### API Versioning
```typescript
// Maintain both versions temporarily
@Controller('api/v1/feature') // Existing
class FeatureV1Controller { }

@Controller('api/v2/feature') // Updated
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

<think step-by-step about achieving 100% test success>

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
   @Read(file_path="[component_path]")
   ```

2. **Create Backup Branch**
   ```bash
   @Bash(command="git checkout -b update-$ARGUMENTS-backup")
   ```

3. **Apply Updates with MultiEdit**
   ```typescript
   @MultiEdit(file_path="[component_path]", edits=[
       {old_string: "existing code", new_string: "updated code"},
       // Multiple edits in single operation
   ])
   ```

4. **Generate Tests**
   ```bash
   @Write(file_path="[test_path]", content="[generated_tests]")
   ```

5. **Run Tests Until Success**
   ```bash
   while (testResult.success < 100%) {
       @Bash(command="npm test [test_file]")
       // Fix any failures
       @Edit(file_path="[component_path]", ...)
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

<think harder about ensuring sustained 100% success>

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
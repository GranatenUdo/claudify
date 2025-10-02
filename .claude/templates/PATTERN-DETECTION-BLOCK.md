# Reusable Pattern Detection Block

This block can be included in any command that generates code.

## Pattern Detection Instructions

```markdown
## Step 1: Detect Project Conventions

### Check for Cached Analysis
Look for `.claude/config/project-knowledge.json`

IF project-knowledge.json EXISTS:
- Read the cached conventions
- Apply these patterns for code generation:
  - Constructors: Use detected pattern ({{patterns.entityConstructors}})
  - Properties: Use detected pattern ({{naming.properties}})
  - Collections: Use detected types ({{patterns.collectionProperties}})
  - Date fields: Use detected suffix ({{naming.dateFields}})
  - Error handling: Use detected approach ({{patterns.errorHandling}})
  - Validation: Use detected pattern ({{patterns.validation}})
- SKIP to code generation (Step 2)

IF project-knowledge.json DOES NOT EXIST (Adaptive Mode):
- Proceed to on-demand pattern detection below

### On-Demand Pattern Detection (Adaptive Fallback)

**ACTIVE EXAMINATION REQUIRED:**

1. **Find Similar Files**:
   Use Glob to find 2-3 existing files similar to what you'll generate:
   - For entities: `**/*Domain*/Models/Entities/*.cs` OR `**/Models/Entities/*.cs`
   - For services: `**/*Application*/**/*Service.cs` OR `**/Services/*.cs`
   - For controllers: `**/Controllers/*Controller.cs` OR `**/*WebApp*/Controllers/*.cs`
   - For components: `**/src/app/**/*.component.ts`

2. **Read and Analyze Files**:
   Read the 2-3 files found and note:
   - **Constructor patterns**: Public/private/factory methods/none?
   - **Property patterns**: `{ get; set; }` / `{ get; init; }` / readonly?
   - **Collection types**: List<T> / IReadOnlyList<T> / IList<T> / IEnumerable<T>?
   - **Date field naming**: CreatedAt / CreatedAtDateTime / CreatedOn suffix?
   - **Error handling**: Exceptions / Result<T> pattern / custom?
   - **Validation**: Constructor validation / FluentValidation / DataAnnotations / none?

3. **Apply Observed Patterns**:
   - Generate new code matching the patterns you observed
   - If patterns are mixed, use the most common one
   - If no files found (new/empty project), use **simple production-ready defaults**:
     * Public parameterless constructors
     * Public `{ get; set; }` properties
     * `List<T>` for collections
     * `CreatedAt`/`UpdatedAt` for date fields
     * Exceptions for error handling
     * Constructor validation for critical rules

4. **Document Detection**:
   State what you detected:
   ```
   DETECTED PATTERNS (from examination of files: [list files]):
   - Constructors: [what you observed]
   - Properties: [what you observed]
   - Collections: [what you observed]
   - Date fields: [what you observed]
   - Error handling: [what you observed]
   - Validation: [what you observed]
   ```

## Step 2: Generate Code

Apply the patterns from Step 1 consistently across all generated code.
```

## Usage in Commands

In any command that generates code, include:

```markdown
@Task(
  description="Implementation",
  prompt="Implement '$ARGUMENTS':

[... existing requirements ...]

## PATTERN DETECTION (Required)

Follow the pattern detection instructions in .claude/templates/PATTERN-DETECTION-BLOCK.md:
1. Check for project-knowledge.json (Smart Mode cache)
2. If not found, examine 2-3 similar files on-demand (Adaptive Mode)
3. Apply detected patterns to generated code

[... rest of implementation instructions ...]",
  subagent_type="tech-lead-engineer"
)
```

## Benefits

- **Works in both modes**: Smart (cached) and Adaptive (on-demand)
- **Consistent behavior**: All commands follow same pattern detection logic
- **Graceful degradation**: Falls back to examination if cache missing
- **Clear documentation**: Developers understand what commands are doing

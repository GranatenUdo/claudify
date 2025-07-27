# Generate Documentation Command - Quick Reference

## 🚀 Quick Start

Generate API documentation:
```bash
/generate-docs --type=api --scope=fields
```

Generate feature documentation:
```bash
/generate-docs --type=feature --name="Field Import" --interactive
```

## 📋 Command Options

| Option | Description | Values | Example |
|--------|-------------|---------|---------|
| `--type` | Documentation type | `api`, `feature`, `guide`, `reference` | `--type=api` |
| `--scope` | Resource scope | Any resource name | `--scope=warehouses` |
| `--name` | Feature/topic name | Any string | `--name="Multi-Tenancy"` |
| `--interactive` | Enable review mode | Flag | `--interactive` |
| `--update-existing` | Update existing docs | Flag | `--update-existing` |
| `--audience` | Target audience | `developers`, `users`, `architects` | `--audience=developers` |

## 🤖 Multi-Agent System

The command orchestrates 4 specialized agents:

1. **Technical Accuracy Agent** (Dr. Elena Precision)
   - Validates technical correctness
   - Checks API signatures
   - Ensures security patterns

2. **Readability & Clarity Agent** (Sarah Clarity)
   - Improves documentation clarity
   - Creates progressive examples
   - Optimizes for developer experience

3. **Consistency Checker Agent** (Marcus Standard)
   - Enforces documentation patterns
   - Maintains terminology consistency
   - Validates cross-references

4. **Code Example Generator Agent** (Alex Demo)
   - Creates working code examples
   - Shows error handling
   - Demonstrates best practices

## 🪝 Validation Hooks

Two hooks ensure quality:

1. **validate-documentation-quality.ps1**
   - Checks required sections
   - Validates code examples
   - Scores documentation quality

2. **enhance-documentation-metadata.ps1**
   - Adds metadata and timestamps
   - Creates cross-references
   - Enhances formatting

## 📝 Documentation Templates

Three templates available:
- `api-reference.template.md` - For API documentation
- `feature-documentation.template.md` - For feature docs
- `developer-guide.template.md` - For how-to guides

## 💡 Usage Examples

### Generate Complete API Documentation
```bash
/generate-docs --type=api --scope=fields --interactive
```
Creates comprehensive API reference with endpoints, models, and examples.

### Update Feature Documentation
```bash
/generate-docs --type=feature --name="Field Import" --update-existing
```
Updates existing feature documentation in FEATURES.md.

### Create Developer Guide
```bash
/generate-docs --type=guide --topic="Setting Up Multi-Tenancy" --audience=developers
```
Generates a step-by-step developer guide with examples.

### Generate Quick Reference
```bash
/generate-docs --type=reference --scope=cli-commands
```
Creates a quick reference card for CLI commands.

## ✅ Quality Standards

Documentation must meet:
- **Completeness**: >95% required sections
- **Readability**: Flesch score >60
- **Accuracy**: 100% technical validation
- **Examples**: >80% use case coverage
- **Consistency**: >90% pattern adherence

## 🔧 Advanced Features

### Interactive Review Mode
With `--interactive`, you can:
- Review generated sections
- Accept/reject suggestions
- Make manual edits
- See confidence scores

### Smart Context Gathering
Automatically analyzes:
- Existing code implementation
- API endpoints and models
- Current documentation
- Test coverage
- Recent changes

### Multi-Format Output
Generates documentation in:
- Markdown (default)
- API spec formats (OpenAPI)
- Interactive HTML (with --format=html)
- PDF (with --format=pdf)

## 🚨 Common Issues

**Missing sections error**:
The template requires certain sections. Add them or use a different template.

**Low readability score**:
Sentences too long or complex. The Readability Agent will suggest improvements.

**Inconsistent terminology**:
Using multiple terms for the same concept. The Consistency Agent will standardize.

## 📊 Success Metrics

Track documentation quality:
- Generation time: <30 seconds
- Quality score: >85/100
- Agent consensus: >90%
- User satisfaction: >4.5/5

---

**Pro tip**: Use `--interactive` mode for your first generation to understand how the agents collaborate!
---
description: Extract, categorize, and analyze feature sets to reveal competitive advantages and market positioning
allowed-tools: [Task, Read, Edit, MultiEdit, Grep, Glob, LS, TodoWrite, Bash, WebSearch]
argument-hint: target for analysis (e.g., "current project", "competitor analysis", "feature comparison")
agent-dependencies: [Feature Analyzer, Tech Lead, Business Domain Analyst, Customer Value Translator]
complexity: moderate
estimated-time: 15-25 minutes
category: analysis
---

# 🔍 Feature Analysis: $ARGUMENTS

<think harder about feature extraction, categorization, and competitive positioning>

## Quick Context
Use this command to comprehensively analyze feature sets, identify competitive advantages, and understand market positioning through systematic feature extraction and categorization.

## Execution Flow
1. **Discovery** - Extract all features from codebase/documentation
2. **Categorization** - Group features by type, value, and maturity
3. **Analysis** - Evaluate competitive positioning and differentiation
4. **Recommendations** - Identify gaps and opportunities

## Phase 1: Feature Extraction

### Comprehensive Feature Discovery

I'll begin by extracting all features from your codebase and documentation.

@TodoWrite(todos=[{"content": "Extract features from codebase", "status": "in_progress", "priority": "high", "id": "feat-1"}, {"content": "Categorize features by type", "status": "pending", "priority": "high", "id": "feat-2"}, {"content": "Analyze competitive positioning", "status": "pending", "priority": "high", "id": "feat-3"}, {"content": "Generate feature matrix", "status": "pending", "priority": "high", "id": "feat-4"}])

#### Codebase Feature Extraction

```bash
# Search for feature-related patterns
@Grep(pattern="Feature|feature|FEATURE", path=".", output_mode="files_with_matches", head_limit=20)

# Look for API endpoints (features exposed)
@Grep(pattern="@(Get|Post|Put|Delete|Patch)Mapping|@Route|app\.(get|post|put|delete)", path=".", output_mode="files_with_matches", head_limit=20)

# Find service methods (business features)
@Grep(pattern="public.*async.*Task|def.*async|func.*\(|export.*function", path=".", output_mode="files_with_matches", head_limit=20)
```

#### Documentation Analysis

```bash
# Check for feature documentation
@Glob(pattern="**/FEATURES.md", path=".")
@Glob(pattern="**/README.md", path=".")
@Glob(pattern="**/*feature*.md", path=".")
```

## Phase 2: Deep Feature Analysis

### Expert Feature Extraction

@Task(description="Extract and categorize all features", prompt="Analyze $ARGUMENTS for comprehensive feature extraction:

1. **Feature Discovery**
   - Core functionality features
   - Supporting features
   - Infrastructure features
   - Integration capabilities
   - Hidden/undocumented features

2. **Feature Categorization**
   - By user persona (who uses it)
   - By business value (why it matters)
   - By technical capability (what it does)
   - By maturity level (how complete)
   - By uniqueness (market differentiation)

3. **Feature Metadata**
   - Implementation status
   - Performance characteristics
   - Scalability limits
   - Dependencies
   - Technical debt

4. **Competitive Intelligence**
   - Industry-standard features
   - Unique differentiators
   - Missing table-stakes features
   - Innovation opportunities

Return structured feature inventory with categorization and competitive analysis.", subagent_type="Feature Analyzer")

### Technical Architecture Assessment

@Task(description="Analyze technical feature capabilities", prompt="Evaluate the technical architecture supporting features in $ARGUMENTS:

1. **Architectural Capabilities**
   - Scalability features
   - Performance features
   - Security features
   - Reliability features
   - Extensibility features

2. **Platform Features**
   - Multi-tenancy support
   - API capabilities
   - Integration points
   - Deployment options
   - Monitoring/observability

3. **Technical Differentiators**
   - Unique architectural advantages
   - Performance benchmarks
   - Scale capabilities
   - Technology stack benefits

Rate technical feature maturity 1-10 with justification.", subagent_type="general-purpose")

### Business Domain Analysis

@Task(description="Analyze business value of features", prompt="Evaluate business domain aspects of features in $ARGUMENTS:

1. **Business Capability Mapping**
   - Core business processes supported
   - Value chain coverage
   - Workflow automation features
   - Decision support features

2. **Domain-Specific Features**
   - Industry-specific functionality
   - Regulatory compliance features
   - Best practice implementations
   - Domain expertise embedded

3. **Business Value Assessment**
   - Revenue-generating features
   - Cost-saving features
   - Risk-reduction features
   - Efficiency features

4. **Market Fit Analysis**
   - Target market alignment
   - Persona coverage
   - Use case completeness
   - Industry requirements met

Provide business value score for each feature category.", subagent_type="Business Domain Analyst")

### Customer Value Translation

@Task(description="Translate features to customer value", prompt="Convert technical features in $ARGUMENTS to customer value propositions:

1. **Value Proposition Mapping**
   - Feature → Benefit translation
   - Pain point → Solution mapping
   - ROI calculations
   - Time-to-value estimates

2. **Customer Impact Analysis**
   - Productivity improvements
   - Cost reductions
   - Risk mitigation
   - Quality improvements

3. **Competitive Advantages**
   - Unique value propositions
   - Superior implementations
   - Better together features
   - Network effects

4. **Success Metrics**
   - KPIs improved
   - Measurable outcomes
   - Success stories potential
   - Reference-ability

Provide customer-centric feature value assessment.", subagent_type="Customer Value Translator")

@TodoWrite(todos=[{"content": "Extract features from codebase", "status": "completed", "priority": "high", "id": "feat-1"}, {"content": "Categorize features by type", "status": "in_progress", "priority": "high", "id": "feat-2"}, {"content": "Analyze competitive positioning", "status": "pending", "priority": "high", "id": "feat-3"}, {"content": "Generate feature matrix", "status": "pending", "priority": "high", "id": "feat-4"}])

## Phase 3: Feature Categorization Matrix

<think about creating comprehensive feature categorization>

### Feature Inventory Structure

```markdown
## 📊 Feature Categorization Matrix

### Core Features (Must-Have)
| Feature | Category | Maturity | Value | Differentiator |
|---------|----------|----------|-------|----------------|
| [Name] | [Type] | [1-10] | [High/Med/Low] | [Yes/No] |

### Supporting Features (Should-Have)
| Feature | Category | Maturity | Value | Differentiator |
|---------|----------|----------|-------|----------------|
| [Name] | [Type] | [1-10] | [High/Med/Low] | [Yes/No] |

### Differentiating Features (Unique)
| Feature | Category | Maturity | Value | Competitive Advantage |
|---------|----------|----------|-------|----------------------|
| [Name] | [Type] | [1-10] | [High/Med/Low] | [Description] |

### Missing Features (Gaps)
| Feature | Priority | Effort | Business Impact | Competitive Risk |
|---------|----------|--------|-----------------|------------------|
| [Name] | [P0-P3] | [S/M/L] | [Description] | [High/Med/Low] |
```

## Phase 4: Competitive Analysis

@TodoWrite(todos=[{"content": "Extract features from codebase", "status": "completed", "priority": "high", "id": "feat-1"}, {"content": "Categorize features by type", "status": "completed", "priority": "high", "id": "feat-2"}, {"content": "Analyze competitive positioning", "status": "in_progress", "priority": "high", "id": "feat-3"}, {"content": "Generate feature matrix", "status": "pending", "priority": "high", "id": "feat-4"}])

### Market Positioning Assessment

```markdown
## 🎯 Competitive Positioning

### Strengths (What we do better)
- **[Feature Category]**: [Advantage description]
- **[Feature Category]**: [Advantage description]

### Parity (What we match)
- **[Feature Category]**: Meeting industry standards
- **[Feature Category]**: Table stakes features

### Gaps (What we're missing)
- **[Feature Category]**: [Gap description and impact]
- **[Feature Category]**: [Gap description and impact]

### Opportunities (What we could innovate)
- **[Feature Category]**: [Innovation opportunity]
- **[Feature Category]**: [Innovation opportunity]
```

## Phase 5: Strategic Recommendations

### Feature Roadmap Priorities

Based on the comprehensive analysis:

#### P0 - Critical Gaps (This Quarter)
1. **[Feature Name]**
   - Business Impact: [Description]
   - Effort: [S/M/L]
   - Risk if not done: [Description]

#### P1 - Competitive Parity (Next Quarter)
1. **[Feature Name]**
   - Business Impact: [Description]
   - Effort: [S/M/L]
   - Market expectation: [Description]

#### P2 - Differentiators (This Year)
1. **[Feature Name]**
   - Competitive Advantage: [Description]
   - Effort: [S/M/L]
   - Market impact: [Description]

#### P3 - Innovation Opportunities (Future)
1. **[Feature Name]**
   - Innovation potential: [Description]
   - Effort: [S/M/L]
   - First-mover advantage: [Description]

@TodoWrite(todos=[{"content": "Extract features from codebase", "status": "completed", "priority": "high", "id": "feat-1"}, {"content": "Categorize features by type", "status": "completed", "priority": "high", "id": "feat-2"}, {"content": "Analyze competitive positioning", "status": "completed", "priority": "high", "id": "feat-3"}, {"content": "Generate feature matrix", "status": "completed", "priority": "high", "id": "feat-4"}])

## Final Deliverables

### 1. Feature Inventory Report
- Complete list of all features
- Categorization by multiple dimensions
- Maturity and completeness assessment
- Technical implementation status

### 2. Competitive Analysis
- Market positioning assessment
- Competitive advantages identified
- Gap analysis with priorities
- Innovation opportunities

### 3. Value Mapping
- Feature to value translation
- Customer impact assessment
- ROI potential for each feature
- Success metrics defined

### 4. Strategic Roadmap
- Prioritized feature development
- Resource requirements
- Timeline recommendations
- Risk assessment

## Success Metrics

### Feature Coverage
- ✅ All features documented
- ✅ 100% categorization complete
- ✅ Value propositions defined
- ✅ Competitive position clear

### Analysis Quality
- ✅ Multi-dimensional categorization
- ✅ Technical and business alignment
- ✅ Customer value articulated
- ✅ Strategic priorities set

## Example Usage

```bash
# Analyze current project features
/analyze-features current project

# Compare with competitor
/analyze-features competitor comparison with [competitor]

# Focus on specific domain
/analyze-features API capabilities

# Generate feature roadmap
/analyze-features roadmap planning
```

## Summary

This comprehensive feature analysis provides:

1. **Complete Feature Inventory** - Every capability catalogued
2. **Multi-Dimensional Categorization** - Technical, business, and customer views
3. **Competitive Intelligence** - Market positioning and gaps
4. **Strategic Roadmap** - Prioritized development plan
5. **Value Articulation** - Clear value propositions for each feature

The analysis enables data-driven product decisions and strategic planning based on comprehensive feature intelligence.
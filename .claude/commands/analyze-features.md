---
name: analyze-features
think-mode: think_harder
description: Extract, categorize, and analyze feature sets to reveal competitive advantages and market positioning
allowed-tools: [Task, Read, Edit, MultiEdit, Grep, Glob, LS, TodoWrite, Bash, WebSearch]
argument-hint: target for analysis (e.g., "current project", "competitor analysis", "feature comparison")
---

# 🔍 Feature Analysis: $ARGUMENTS

## Optimization Features

- **Parallel execution**: Yes - Feature Analyzer, Business Domain Analyst, and Customer Value Translator execute simultaneously to discover features, categorize by business value, and assess competitive positioning, reducing analysis time by 45-55%
- **Extended thinking**: Yes - Feature analysis demands complex reasoning to understand implicit capabilities, competitive differentiation, market positioning, and strategic value across multiple business dimensions
- **Confidence scoring**: Yes - Feature completeness (95% for documented, 80% for inferred), competitive advantage assessment (85% for unique features, 70% for market gaps), value quantification (75% accuracy with validation checkpoints)
- **Subagent coordination**: Yes - Feature Analyzer extracts capabilities → Business Domain Analyst categorizes by value → Customer Value Translator maps to user benefits → Competitive Intelligence synthesizes positioning

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

I'll update the task list to track our progress.

#### Codebase Feature Extraction

```bash
# Search for feature-related patterns
Searching for pattern: Feature|feature|FEATURE

# Look for API endpoints (features exposed)
Searching for pattern: @(Get|Post|Put|Delete|Patch)Mapping|@Route|app\.(get|post|put|delete)

# Find service methods (business features)
Searching for pattern: public.*async.*Task|def.*async|func.*\(|export.*function
```

#### Documentation Analysis

```bash
# Check for feature documentation
Finding files matching: **/FEATURES.md
Finding files matching: **/README.md
Finding files matching: **/*feature*.md
```

## Phase 2: Deep Feature Analysis

### Expert Feature Extraction

Using the Feature Analyzer agent to: Analyze $ARGUMENTS for comprehensive feature extraction:

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

Return structured feature inventory with categorization and competitive analysis.

### Technical Architecture Assessment

I'll have the general-purpose agent Analyze technical feature capabilities.

### Business Domain Analysis

I'll have the Business Domain Analyst agent Analyze business value of features.

### Customer Value Translation

I'll have the Customer Value Translator agent Translate features to customer value.

I'll update the task list to track our progress.

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

I'll update the task list to track our progress.

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

I'll update the task list to track our progress.

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
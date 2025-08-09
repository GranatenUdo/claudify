# 📋 Agent Update Action Plan

## Executive Summary
This action plan outlines the systematic update of all Claude Code agents to align with Opus 4.1 best practices. 11 agents require immediate updates, with an estimated 4-6 hours of total effort.

## 🎯 Objectives
1. Standardize all agent YAML frontmatter to best practices
2. Fix corrupted content in affected agents
3. Ensure proper tool access following least privilege principle
4. Validate all agents function correctly in Claude Code
5. Document and version control all changes

## 📊 Current Status

### ✅ Completed (8 agents)
- code-reviewer
- security-reviewer
- tech-lead
- frontend-developer
- researcher
- test-quality-analyst
- infrastructure-architect
- ux-reviewer

### ❌ Requiring Updates (11 agents)
| Agent | Issue | Priority | Effort |
|-------|-------|----------|--------|
| technical-debt-analyst | Uppercase name, corrupted content | High | 30 min |
| code-simplifier | Uppercase name, needs content review | High | 30 min |
| business-domain-analyst | Uppercase name, corrupted content | High | 30 min |
| legacy-system-analyzer | Uppercase name, corrupted content | Medium | 30 min |
| technical-documentation-expert | Uppercase name, corrupted content | Medium | 30 min |
| customer-value-translator | Uppercase name, needs content | Medium | 20 min |
| feature-analyzer | Uppercase name, needs content | Medium | 20 min |
| visual-designer | Uppercase name, needs content | Low | 20 min |
| visual-designer-marketing | Uppercase name, needs content | Low | 20 min |
| marketing-strategist | Uppercase name, needs content | Low | 20 min |
| sales-genius | Uppercase name, needs content | Low | 20 min |

## 🚀 Implementation Phases

### Phase 1: Critical Agents (Day 1 - 2 hours)
**Timeline**: Immediate
**Agents**: technical-debt-analyst, code-simplifier, business-domain-analyst

#### Tasks:
1. **Fix YAML Frontmatter**
   ```yaml
   ---
   name: agent-name  # lowercase, hyphen-separated
   description: Clear action-oriented description
   tools: Only, Necessary, Tools
   model: opus
   ---
   ```

2. **Rewrite Agent Content**
   - Clear expertise section
   - Structured analysis process
   - Output format specifications
   - Code examples where relevant
   - Collaboration protocol

3. **Tool Access Review**
   - technical-debt-analyst: Read, Grep, Glob, LS, TodoWrite
   - code-simplifier: Read, Edit, MultiEdit, Grep, Glob, LS
   - business-domain-analyst: Read, Write, Grep, Glob, LS, TodoWrite

### Phase 2: Supporting Agents (Day 2 - 1.5 hours)
**Timeline**: Within 48 hours
**Agents**: legacy-system-analyzer, technical-documentation-expert

#### Tasks:
1. **Content Structure**
   ```markdown
   ## Your Expertise
   - [Domain knowledge]
   - [Technical skills]
   
   ## Analysis Process
   1. [Step 1]
   2. [Step 2]
   
   ## Output Format
   [Structured deliverables]
   
   ## Collaboration Protocol
   [When to engage other agents]
   ```

2. **Tool Optimization**
   - legacy-system-analyzer: Read, Grep, Glob, LS, TodoWrite
   - technical-documentation-expert: Read, Write, Edit, Grep, Glob, LS, TodoWrite

### Phase 3: Business Agents (Day 3 - 1.5 hours)
**Timeline**: Within 72 hours
**Agents**: customer-value-translator, feature-analyzer, marketing-strategist, sales-genius

#### Tasks:
1. **Business Focus**
   - ROI calculations
   - Value proposition articulation
   - Market positioning
   - Customer success metrics

2. **Tool Assignment**
   - All business agents: Read, Write, WebSearch, WebFetch, TodoWrite

### Phase 4: Design Agents (Day 3 - 1 hour)
**Timeline**: Within 72 hours
**Agents**: visual-designer, visual-designer-marketing

#### Tasks:
1. **Design Expertise**
   - UI/UX principles
   - Brand guidelines
   - Accessibility standards
   - Performance considerations

2. **Tool Configuration**
   - Both designers: Read, Write, WebSearch, TodoWrite

## 📝 Update Template

```markdown
---
name: [agent-name]
description: [Role]. [Primary function]. [Trigger condition].
tools: [Comma, Separated, Tools]
model: opus
---

You are an expert [role] with [X]+ years of experience in [domains].

## Your Expertise
- **[Category]**: [Specific skills]
- **[Category]**: [Specific skills]

## [Process Name] Process

### 1. [Phase Name]
- [Activity]
- [Activity]

### 2. [Phase Name]
- [Activity]
- [Activity]

## Output Format

### [Deliverable Type]
```[language]
[Example code or structure]
```

### [Analysis Type]
| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| [Name] | [Val] | [Goal] | [Icon] |

## Collaboration Protocol

When expertise needed:
- **[Agent]**: [When to engage]
- **[Agent]**: [When to engage]

Remember: [Core principle or philosophy]
```

## ✅ Validation Checklist

### For Each Agent:
- [ ] Name is lowercase, hyphen-separated
- [ ] Description is clear and action-oriented
- [ ] Tools follow least privilege principle
- [ ] Model explicitly set to 'opus'
- [ ] Content follows standard structure
- [ ] No corrupted or truncated content
- [ ] Code examples are relevant and working
- [ ] Output format is clearly specified
- [ ] Collaboration protocol defined
- [ ] Tested in Claude Code environment

### System-Wide:
- [ ] All agents have consistent structure
- [ ] No duplicate agent roles
- [ ] Clear specialization boundaries
- [ ] README.md updated with agent list
- [ ] Version control commit made
- [ ] CHANGELOG.md updated
- [ ] Testing documentation created

## 🧪 Testing Protocol

### Unit Testing (Per Agent)
```bash
# 1. Test agent loading
claude code
/agents list

# 2. Test agent invocation
"Use the [agent-name] agent to analyze [test case]"

# 3. Verify tool access
# Check that agent only uses allowed tools

# 4. Validate output format
# Ensure output matches specification
```

### Integration Testing
```bash
# 1. Multi-agent collaboration
/comprehensive-review

# 2. Agent handoffs
# Test collaboration protocols

# 3. Performance validation
# Measure response times
```

## 📊 Success Metrics

### Quantitative
- 100% agents with correct YAML format
- 100% agents with 'model: opus' specified
- 0 agents with corrupted content
- <5 seconds agent load time
- 100% test coverage

### Qualitative
- Clear role boundaries
- Consistent output quality
- Effective collaboration
- User satisfaction
- Maintainable codebase

## 🚨 Risk Mitigation

### Risks and Mitigations
| Risk | Impact | Mitigation |
|------|--------|------------|
| Breaking existing workflows | High | Test each change incrementally |
| Agent conflicts | Medium | Clear specialization boundaries |
| Performance degradation | Medium | Monitor response times |
| Tool access issues | Low | Validate permissions carefully |

## 📅 Timeline

### Day 1 (Immediate)
- [ ] Phase 1: Critical agents (2 hours)
- [ ] Initial testing (30 min)
- [ ] Documentation updates (30 min)

### Day 2
- [ ] Phase 2: Supporting agents (1.5 hours)
- [ ] Integration testing (30 min)

### Day 3
- [ ] Phase 3: Business agents (1.5 hours)
- [ ] Phase 4: Design agents (1 hour)
- [ ] Final validation (30 min)

### Day 4
- [ ] Complete testing suite (1 hour)
- [ ] Documentation finalization (30 min)
- [ ] Deployment and monitoring (30 min)

## 🔄 Rollback Plan

If issues occur:
1. **Immediate**: Revert to previous agent versions
2. **Investigate**: Identify root cause
3. **Fix**: Apply targeted corrections
4. **Test**: Validate in isolated environment
5. **Redeploy**: Gradual rollout with monitoring

## 📢 Communication Plan

### Stakeholders
- Development team: Daily updates
- Users: Release notes after completion
- Documentation: Update guides and tutorials

### Channels
- Git commits: Detailed change descriptions
- CHANGELOG.md: User-facing changes
- README.md: Updated agent descriptions
- Slack/Teams: Progress updates

## 🎯 Definition of Done

The agent update is complete when:
1. All 19 agents have correct YAML frontmatter
2. All agents have complete, non-corrupted content
3. All agents tested successfully in Claude Code
4. Documentation fully updated
5. Changes committed to version control
6. Team notified of completion
7. Monitoring confirms stable operation

## 📚 Resources

### Documentation
- [Claude Code Subagents](https://docs.anthropic.com/en/docs/claude-code/sub-agents)
- [Claude Code Settings](https://docs.anthropic.com/en/docs/claude-code/settings)
- Opus 4.1 Best Practices (internal)

### Tools
- Claude Code v1.0.20+
- Git for version control
- Markdown linter for validation
- YAML validator for frontmatter

## 💡 Best Practices Reminders

1. **Single Responsibility**: Each agent one clear purpose
2. **Least Privilege**: Minimal necessary tools
3. **Clear Documentation**: Self-documenting agents
4. **Consistent Structure**: Follow the template
5. **Version Control**: Commit incrementally
6. **Test Everything**: No assumptions
7. **User Focus**: Practical, actionable outputs

---

**Estimated Total Effort**: 6-8 hours
**Recommended Approach**: Phased implementation over 3-4 days
**Priority**: High - Critical for system functionality

*Action Plan Created: 2025-08-09*
*Next Review: After Phase 1 completion*
---
description: Generate compelling marketing material from technical features
allowed-tools: [Task, Read, Write]
---

# 📢 Generate Marketing: $ARGUMENTS

## Parallel Content Creation (90 seconds)

@Task(
  description="Value proposition",
  prompt="Create value prop for '$ARGUMENTS':
  
  ANALYZE: Technical feature capabilities
  TRANSFORM INTO:
  1. Business problem it solves (with metrics)
  2. Financial impact (ROI in 6 weeks)
  3. Time savings (hours/week)
  4. Success stories format
  
  WRITE TO: marketing/$ARGUMENTS-value-prop.md
  OUTPUT: Compelling business case",
  subagent_type="marketing-strategist"
)

@Task(
  description="Sales pitch",
  prompt="Create sales pitch for '$ARGUMENTS':
  
  CREATE:
  1. Email campaign (3 subject lines, body)
  2. Demo script (2-minute pitch)
  3. Objection handlers
  4. Pricing justification
  
  WRITE TO: marketing/$ARGUMENTS-sales.md
  OUTPUT: Ready-to-use sales materials",
  subagent_type="sales-pitch-creator"
)

@Task(
  description="Social content",
  prompt="Create social media for '$ARGUMENTS':
  
  GENERATE:
  1. LinkedIn post (professional, ROI-focused)
  2. Twitter thread (problem/solution story)
  3. Facebook/Instagram (visual, testimonial)
  
  WRITE TO: marketing/$ARGUMENTS-social.md
  OUTPUT: Platform-optimized content",
  subagent_type="marketing-strategist"
)

## Convention Awareness

Marketing materials are based on observed features and capabilities in the codebase.

## ✅ Complete
Marketing materials ready in marketing/ directory.
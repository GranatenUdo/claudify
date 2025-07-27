---
description: Transform current Figma selection into production-ready code led by Frontend Developer expertise with multi-agent support
allowed-tools: [Task, WebFetch, WebSearch, TodoWrite, Read, Write, Edit, MultiEdit, Bash, Grep, Glob, LS]
argument-hint: Optional framework/requirements (e.g., "with Angular 20 and Material Design" or defaults to project's detected framework)
agent-dependencies: [Frontend Developer, Visual Designer, Tech Lead, Code Reviewer]
complexity: high
estimated-time: 15-20 minutes
category: development
---

# 🎨 Figma to Production Implementation

## OPUS 4 ACTIVATION - COMPREHENSIVE DESIGN IMPLEMENTATION
<think harder about design intent, user experience, accessibility, performance, and code quality>

**Implementation Directive**: Transform the current Figma selection into production-ready code that prioritizes user experience, accessibility, and maintainability while leveraging multi-agent expertise.

## Phase 1: Design Extraction & Analysis

### Extract Current Selection
```
@mcp__figma__get_code
Extract the selected Figma design with full context.
Preserve all design decisions, interactions, and states.
```

### Extract Design System Context
```
@mcp__figma__get_variable_defs
Extract all design tokens from the selection.
Understand the broader design system context.
```

### Capture Visual Reference
```
@mcp__figma__get_image
Capture high-fidelity visual reference for validation.
Document all interactive states and responsive behavior.
```

## Phase 2: Frontend Developer-Led Implementation Analysis

<think step-by-step about leveraging Frontend Developer expertise to guide implementation>

### Frontend Technical Analysis & Implementation Planning
I'll have the Frontend Developer lead the technical implementation planning based on the Figma design.

```
@Task(description="Frontend implementation architecture from Figma", prompt="As an elite Frontend Developer, analyze the Figma design and create comprehensive implementation plan for $ARGUMENTS:

TECHNICAL ANALYSIS:
1. **Component Architecture**
   - Component breakdown and hierarchy
   - Reusable component identification
   - State management requirements
   - Data flow architecture
   - Smart vs presentational components
2. **Framework Implementation** 
   - Angular 20 component structure
   - Signal-based state management
   - Standalone component approach
   - Dependency injection needs
   - Route configuration if applicable
3. **Responsive Strategy**
   - Breakpoint implementation
   - Mobile-first approach
   - Touch interactions
   - Viewport considerations
   - Performance on devices
4. **Animation & Interactions**
   - Micro-interaction implementation
   - Animation performance
   - Transition strategies
   - Gesture handling
   - Loading states
5. **Accessibility Implementation**
   - ARIA attributes needed
   - Keyboard navigation plan
   - Screen reader support
   - Focus management
   - Color contrast verification
6. **Performance Optimization**
   - Bundle size estimates
   - Lazy loading opportunities
   - Image optimization needs
   - Code splitting points
   - Render optimization

FIGMA TO CODE MAPPING:
1. Extract design tokens programmatically
2. Map Figma components to Angular components
3. Identify shared styles and mixins
4. Plan responsive behavior
5. Document interaction states

Provide detailed implementation blueprint with code structure, patterns, and specific Angular implementation details.

[Design context from Phase 1]", subagent_type="Frontend Developer")
```

### Visual Design System Enhancement
Following the Frontend Developer's technical analysis, enhance the visual design.

```
@Task(description="Design system enhancement for implementation", prompt="As Visual Designer, enhance the Figma design for optimal implementation:

VISUAL DESIGN ENHANCEMENT:
1. Generate cohesive color palette with semantic meanings
2. Define typography scale and font pairings
3. Create spacing rhythm based on mathematical harmony
4. Design elevation and shadow system
5. Suggest micro-interactions and animation patterns
6. Ensure visual hierarchy and focal points
7. Apply emotional design principles
8. Validate accessibility standards (WCAG 2.1 AA)

UX ANALYSIS:
1. Evaluate interaction patterns and user flow
2. Assess mobile responsiveness requirements
3. Analyze cognitive load and usability
4. Identify accessibility features needed
5. Map user journey through the interface
6. Design error and loading states
7. Create keyboard navigation strategy

Provide integrated design system with UX specifications, including all design tokens, patterns, and implementation guidelines.

[Design context from Phase 1]", subagent_type="Visual Designer")
```

### Technical Architecture & Implementation Planning (OPTIMIZED)
I'll have the Tech Lead provide comprehensive technical guidance.

```
@Task(description="Technical architecture and implementation planning", prompt="As Tech Lead with full-stack expertise, design the complete technical approach for implementing this Figma component:

ARCHITECTURE PLANNING:
1. Component hierarchy and composition strategy
2. State management approach (signals, stores, context)
3. Performance optimization strategies
4. Scalability considerations
5. Integration patterns with existing systems

IMPLEMENTATION RESEARCH:
1. Framework-specific best practices for: [Framework: $ARGUMENTS]
2. Similar implementation patterns in the ecosystem
3. Potential technical challenges and solutions
4. Performance benchmarks to target
5. Alternative approaches with trade-offs

FRONTEND ARCHITECTURE:
1. Component structure with proper separation of concerns
2. Type definitions and interfaces (TypeScript)
3. Accessibility implementation approach
4. Testing strategy (unit, integration, visual)
5. Error handling and recovery patterns
6. Code organization and file structure
7. Bundle optimization and code splitting
8. Development workflow and tooling

Provide unified technical blueprint covering architecture, research insights, and implementation details.

[Design context from Phase 1]
[Enhanced design from previous task]", subagent_type="Tech Lead")
```

## Phase 3: Frontend Developer-Driven Implementation

<use extended thinking to implement based on Frontend Developer's technical blueprint>

Based on the Frontend Developer's leadership and multi-agent insights, I'll create production-ready implementation that:

1. **Follows Frontend Developer's Architecture**
   - Component hierarchy and composition
   - Signal-based state management
   - TypeScript interfaces and types
   - Angular 20 best practices
   - Performance optimizations

2. **Applies Visual Design System**
   - Design tokens from Visual Designer
   - Color palette and semantics
   - Typography rhythm and scale
   - Spacing system implementation
   - Animation personalities

3. **Incorporates Tech Lead's Guidance**
   - System integration patterns
   - Scalability considerations
   - API design alignment
   - Monitoring approach
   - Security requirements

4. **Implements Accessibility Excellence**
   - WCAG 2.1 AA compliance
   - Keyboard navigation from Frontend Developer's plan
   - Screen reader optimization
   - Focus management strategy
   - High contrast support

5. **Ensures Code Quality**
   - Clean code principles
   - Comprehensive testing
   - Documentation standards
   - Performance budgets
   - Bundle optimization

## Phase 4: Code Generation with Visual Excellence

### Enhanced Component Architecture
Based on the framework detected or specified ($ARGUMENTS), I'll generate beautiful, performant code:

```[framework]
// Component with visual excellence and clean architecture
import { useEffect, useRef, useState, useMemo } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import type { ComponentProps } from './types';

// Animation variants from Visual Designer
const motionVariants = {
  initial: { opacity: 0, y: 20 },
  animate: { 
    opacity: 1, 
    y: 0,
    transition: {
      duration: 0.4,
      ease: [0.4, 0, 0.2, 1] // Material easing
    }
  },
  exit: { 
    opacity: 0, 
    y: -10,
    transition: { duration: 0.2 }
  }
};

export const Component = ({ 
  variant = 'primary',
  size = 'medium',
  children,
  ...props 
}: ComponentProps) => {
  // State management from Frontend Developer
  const [state, setState] = useState<ComponentState>('idle');
  const containerRef = useRef<HTMLDivElement>(null);
  
  // Performance optimization with memoization
  const computedStyles = useMemo(() => ({
    ...getVariantStyles(variant),
    ...getSizeStyles(size),
    ...getStateStyles(state)
  }), [variant, size, state]);
  
  // Accessibility from UX Reviewer
  const ariaProps = useAriaProps(props);
  
  // Visual effects from Visual Designer
  useEffect(() => {
    if (state === 'success') {
      // Trigger success animation
      animateSuccess(containerRef.current);
    }
  }, [state]);
  
  return (
    <motion.div
      ref={containerRef}
      className={clsx(
        'component',
        `component--${variant}`,
        `component--${size}`,
        `component--${state}`
      )}
      style={computedStyles}
      variants={motionVariants}
      initial="initial"
      animate="animate"
      exit="exit"
      whileHover={{ scale: 1.02 }}
      whileTap={{ scale: 0.98 }}
      {...ariaProps}
      {...props}
    >
      <AnimatePresence mode="wait">
        {children}
      </AnimatePresence>
    </motion.div>
  );
};
```

### Styling Implementation
```[css/scss]
/* Design tokens from Visual Designer */
:root {
  /* Color System */
  --color-primary: [from color harmony analysis];
  --color-secondary: [from color harmony analysis];
  --color-accent: [from emotional palette];
  
  /* Typography Scale (golden ratio) */
  --font-size-xs: 0.694rem;
  --font-size-sm: 0.833rem;
  --font-size-base: 1rem;
  --font-size-md: 1.2rem;
  --font-size-lg: 1.44rem;
  --font-size-xl: 1.728rem;
  
  /* Spacing (Fibonacci) */
  --space-1: 0.125rem;
  --space-2: 0.25rem;
  --space-3: 0.5rem;
  --space-5: 0.813rem;
  --space-8: 1.313rem;
  
  /* Motion (from personality) */
  --motion-duration: [from motion personality];
  --motion-easing: [from motion personality];
  
  /* Elevation */
  --shadow-subtle: 0 1px 2px rgba(0, 0, 0, 0.05);
  --shadow-moderate: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  --shadow-dramatic: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
}

/* Component styles with visual harmony */
.component {
  /* Apply design system */
  color: var(--color-text);
  font-size: var(--font-size-base);
  line-height: var(--line-height-normal);
  padding: var(--space-5);
  border-radius: var(--radius-moderate);
  box-shadow: var(--shadow-subtle);
  transition: all var(--motion-duration) var(--motion-easing);
}
```

### Supporting Infrastructure

#### Type Definitions (Frontend Developer)
```typescript
// Comprehensive type safety
export interface ComponentProps {
  variant?: 'primary' | 'secondary' | 'accent' | 'ghost';
  size?: 'small' | 'medium' | 'large';
  state?: ComponentState;
  children: React.ReactNode;
  onStateChange?: (state: ComponentState) => void;
  className?: string;
  style?: React.CSSProperties;
}

type ComponentState = 'idle' | 'loading' | 'success' | 'error';

// Design token types
interface DesignTokens {
  colors: ColorPalette;
  typography: TypographyScale;
  spacing: SpacingScale;
  motion: MotionConfig;
  elevation: ElevationScale;
}
```

#### Visual Helper Functions
```typescript
// Color manipulation from Visual Designer
const adjustColorForState = (baseColor: string, state: ComponentState): string => {
  switch (state) {
    case 'loading':
      return adjustAlpha(baseColor, 0.7);
    case 'error':
      return mix(baseColor, '#ef4444', 0.2);
    case 'success':
      return mix(baseColor, '#10b981', 0.2);
    default:
      return baseColor;
  }
};

// Animation helpers
const animateSuccess = (element: HTMLElement | null) => {
  if (!element) return;
  
  element.animate([
    { transform: 'scale(1)', filter: 'brightness(1)' },
    { transform: 'scale(1.05)', filter: 'brightness(1.2)' },
    { transform: 'scale(1)', filter: 'brightness(1)' }
  ], {
    duration: 600,
    easing: 'cubic-bezier(0.34, 1.56, 0.64, 1)'
  });
};
```

#### Testing Strategy
```typescript
// Visual regression tests
describe('Component Visual Tests', () => {
  it('should match design specs', async () => {
    const { container } = render(<Component variant="primary" />);
    
    // Check computed styles match design tokens
    const styles = window.getComputedStyle(container.firstChild);
    expect(styles.getPropertyValue('--color-primary')).toBe('#0066CC');
    expect(styles.getPropertyValue('font-size')).toBe('16px');
    
    // Visual snapshot
    await expect(container).toMatchSnapshot();
  });
  
  it('should handle all animation states smoothly', async () => {
    const { rerender } = render(<Component state="idle" />);
    
    // Test state transitions
    for (const state of ['loading', 'success', 'error']) {
      rerender(<Component state={state} />);
      await waitForAnimation();
      expect(performance.now()).toBeLessThan(16); // One frame
    }
  });
});
```

#### Storybook Documentation
```typescript
export default {
  title: 'Design System/Component',
  component: Component,
  parameters: {
    design: {
      type: 'figma',
      url: '[Figma URL]'
    }
  }
};

// Visual variants showcase
export const VisualShowcase = () => (
  <div className="grid grid-cols-4 gap-8 p-8">
    {(['primary', 'secondary', 'accent', 'ghost'] as const).map(variant => (
      <div key={variant}>
        <h3>{variant}</h3>
        <Component variant={variant}>Content</Component>
      </div>
    ))}
  </div>
);
```

## Phase 5: Comprehensive Quality Assurance

### Comprehensive Quality & Implementation Review (OPTIMIZED)
I'll have the Frontend Developer perform complete quality validation.

```
@Task(description="Implementation and quality validation", prompt="As Frontend Developer with design sensibility, validate the complete implementation:

CODE IMPLEMENTATION REVIEW:
1. Component architecture and patterns
2. State management effectiveness
3. Type safety and error handling
4. Performance optimizations applied
5. Accessibility implementation (ARIA, keyboard)
6. Testing coverage and quality
7. Bundle size and optimization
8. Security best practices
9. Code maintainability and documentation

VISUAL IMPLEMENTATION VALIDATION:
1. Design fidelity to Figma source
2. Color implementation and contrast (4.5:1)
3. Typography rhythm and readability
4. Spacing consistency and grid alignment
5. Animation performance and smoothness
6. Responsive behavior across devices
7. Cross-browser visual consistency
8. Brand guidelines adherence

Provide integrated quality assessment with:
- Visual fidelity score (0-100)
- Code quality score (0-100)
- Performance metrics
- Accessibility compliance
- Specific improvements needed
- Overall implementation excellence rating", subagent_type="Frontend Developer")
```

### Automated Validation
```bash
# Visual regression testing
npm run test:visual

# Accessibility audit
npm run test:a11y -- --coverage

# Performance profiling
npm run lighthouse -- --budget-path=./budgets.json

# Bundle analysis
npm run analyze:bundle

# Animation performance
npm run test:animations -- --fps-threshold=60

# Cross-browser testing
npm run test:browsers -- --browsers=chrome,firefox,safari,edge
```

### Enhanced Manual Review Checklist

#### Visual Excellence
- [ ] **Design Fidelity**: Pixel-perfect match to Figma design
- [ ] **Color System**: All colors from approved palette
- [ ] **Typography**: Follows scale and vertical rhythm
- [ ] **Spacing**: Consistent use of spacing tokens
- [ ] **Elevation**: Shadows create proper depth
- [ ] **Icons**: Consistent style and sizing
- [ ] **Imagery**: Optimized and responsive

#### Interaction & Animation
- [ ] **Micro-interactions**: Enhance usability
- [ ] **State Transitions**: Smooth and purposeful
- [ ] **Loading States**: Skeleton screens match layout
- [ ] **Error States**: Clear and helpful
- [ ] **Success Feedback**: Celebratory but professional
- [ ] **Hover Effects**: Subtle and consistent
- [ ] **Focus States**: Visible and accessible

#### Technical Excellence
- [ ] **Performance**: FCP < 1.5s, TTI < 3s
- [ ] **Accessibility**: WCAG 2.1 AA compliant
- [ ] **Responsive**: Works on all devices
- [ ] **Cross-browser**: Consistent experience
- [ ] **SEO**: Proper meta tags and structure
- [ ] **Security**: No XSS vulnerabilities
- [ ] **Code Quality**: Clean and maintainable

## Phase 6: Documentation & Handoff

### Component Documentation
```markdown
## Component: [Generated Component Name]

### Overview
[Description based on design intent]

### Props
[Comprehensive prop documentation]

### Usage Examples
[Common use cases with code]

### Accessibility Notes
[Keyboard shortcuts, ARIA patterns]

### Design Decisions
[Key implementation choices and rationale]
```

### Update CHANGELOG.md
If this is a significant new UI component or feature:
```markdown
### Added
- [Component/Feature Name] from Figma design
  - Key functionality implemented
  - Accessibility features (WCAG 2.1 AA)
  - Responsive breakpoints supported
  - Design system integration
```
Use `/update-changelog` command for automated updates

### Update FEATURES.md
Document the new component/feature location and capabilities

### Integration Guide
1. **Installation**: Required dependencies
2. **Configuration**: Theme/token setup
3. **Usage**: Implementation examples
4. **Customization**: Extension points
5. **Testing**: Test coverage approach

## Phase 7: Continuous Improvement

### Feedback Loop
After implementation, I'll:
1. Compare output with original design
2. Run comprehensive quality checks
3. Suggest optimizations if needed
4. Document any design-to-code gaps

### Future Enhancements
- Progressive enhancement opportunities
- A/B testing possibilities
- Performance optimization paths
- Accessibility improvements

## Phase 6.5: Beauty & Excellence Metrics (NEW)

### Visual Quality Score
```typescript
interface VisualQualityMetrics {
  colorHarmony: number;        // 0-100 (from Visual Designer)
  typographicRhythm: number;   // 0-100
  spatialBalance: number;      // 0-100
  animationFluidity: number;   // 0-100
  emotionalResonance: number;  // 0-100
  brandConsistency: number;    // 0-100
  overallBeauty: number;       // Weighted average
}

// Example output
const metrics: VisualQualityMetrics = {
  colorHarmony: 95,
  typographicRhythm: 92,
  spatialBalance: 88,
  animationFluidity: 94,
  emotionalResonance: 90,
  brandConsistency: 93,
  overallBeauty: 92
};
```

### Code Quality Metrics
```typescript
interface CodeQualityMetrics {
  typeScriptCoverage: number;  // Percentage
  testCoverage: number;        // Percentage
  performanceScore: number;    // 0-100 (Lighthouse)
  accessibilityScore: number;  // 0-100 (axe)
  maintainabilityIndex: number;// 0-100
  bundleSizeKB: number;        // Size in KB
  complexityScore: number;     // Cyclomatic complexity
}
```

## OPUS 4 SYNTHESIS

### Implementation Summary
**Design Source**: Current Figma selection
**Target Framework**: $ARGUMENTS or auto-detected
**Visual Designer**: Enhanced with complete design system
**Frontend Developer**: Optimized for performance and maintainability

### Quality Metrics Dashboard
```
┌─────────────────────────────────────┐
│  VISUAL EXCELLENCE         ████ 92% │
│  CODE QUALITY              ████ 94% │
│  ACCESSIBILITY             ████ 100%│
│  PERFORMANCE              ████ 96% │
│  USER EXPERIENCE          ████ 91% │
│  MAINTAINABILITY          ████ 89% │
└─────────────────────────────────────┘
```

### Key Achievements
1. **Visual Beauty**: 
   - Harmonious color system with emotional resonance
   - Mathematical spacing creating visual rhythm
   - Thoughtful animations enhancing usability
   
2. **Technical Excellence**: 
   - Type-safe, testable architecture
   - Performance-optimized rendering
   - Comprehensive error handling
   
3. **Accessibility Leadership**: 
   - WCAG 2.1 AA compliance
   - Keyboard navigation excellence
   - Screen reader optimization
   
4. **Developer Experience**: 
   - Self-documenting code
   - Comprehensive test suite
   - Clear component APIs
   
5. **User Delight**: 
   - Instant feedback for all actions
   - Smooth, purposeful animations
   - Clear visual hierarchy

### Next Steps
1. Review generated implementation
2. Test across devices and browsers
3. Gather user feedback
4. Iterate based on metrics
5. Document learnings

---

**Remember**: This command leverages the full power of Opus 4's multi-agent system to ensure your Figma designs become not just functional code, but exceptional user experiences that are accessible, performant, and maintainable.
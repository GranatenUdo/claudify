---
name: figma-implement-current-selection
model: opus
think-mode: think_hard
description: Transform current Figma selection into production-ready code led by Frontend Developer expertise with multi-agent support
allowed-tools: [Task, WebFetch, WebSearch, TodoWrite, Read, Write, Edit, MultiEdit, Bash, Grep, Glob, LS]
argument-hint: Optional framework/requirements (e.g., "with Angular 20 and Material Design" or defaults to project's detected framework)
---

# 🎨 Figma to Production Implementation

## Optimization Features

- **Parallel execution**: Yes - Frontend Developer, Visual Designer, and Tech Lead agents analyze simultaneously for comprehensive implementation planning
- **Extended thinking**: Yes - Complex design-to-code translation requires deep analysis of responsive behavior, accessibility patterns, and component architecture
- **Confidence scoring**: Yes - Visual fidelity and implementation decisions include quality scores and validation metrics
- **Subagent coordination**: Yes - Multi-agent system coordinates Frontend, Visual Design, and Technical Architecture expertise for optimal results

**Implementation Directive**: Transform the current Figma selection into production-ready code that prioritizes user experience, accessibility, and maintainability while leveraging multi-agent expertise.

## Phase 1: Design Extraction & Analysis

### Extract Current Selection with Responsive Context
```
@mcp__figma__get_code
Extract the selected Figma design with full responsive context.
Preserve all design decisions including:
- Auto Layout properties (direction, spacing, padding)
- Constraints (horizontal/vertical scaling behavior)
- Grid layouts and column configurations
- Breakpoint-specific variations
- Alignment and distribution settings
Note: Break down large selections into smaller components for optimal results.
```

### Extract Design System Context
```
@mcp__figma__get_variable_defs
Extract all design tokens from the selection:
- Spacing values (ensure 8-point grid alignment)
- Typography scales (responsive font sizes)
- Color system (including responsive color modes)
- Breakpoint definitions
- Component variants for different screen sizes
```

### Capture Visual Reference
```
@mcp__figma__get_image
Capture high-fidelity visual reference for validation:
- Multiple viewport sizes (mobile, tablet, desktop)
- Interactive states (hover, active, focus)
- Responsive behavior documentation
- Touch target sizes for mobile
```

## Phase 2: Frontend Developer-Led Implementation Analysis



### Frontend Technical Analysis & Implementation Planning
I'll have the Frontend Developer lead the technical implementation planning based on the Figma design.

```
Using the Frontend Developer agent to: As an elite Frontend Developer with deep expertise in responsive design and Figma-to-code workflows, analyze the Figma design and create comprehensive implementation plan for $ARGUMENTS:

TECHNICAL ANALYSIS:
1. **Component Architecture**
   - Component breakdown and hierarchy
   - Reusable component identification
   - State management requirements
   - Data flow architecture
   - Smart vs presentational components
2. **Responsive Layout Strategy**
   - Auto Layout to Flexbox/Grid mapping
   - Constraint-based responsive behavior
   - 8-point grid system implementation
   - Breakpoint strategy (mobile: 375px, tablet: 768px, desktop: 1440px)
   - Fluid typography and spacing scales
   - Container queries for component-level responsiveness
3. **Alignment & Spacing System**
   - Extract Figma spacing tokens to CSS custom properties
   - Implement mathematical spacing rhythm (8pt base unit)
   - Ensure consistent padding/margin across breakpoints
   - Map Figma Auto Layout to CSS Gap property
   - Preserve visual hierarchy through spacing
4. **Framework Implementation** 
   - Angular 20 component structure
   - Signal-based state management
   - Standalone component approach
   - Responsive directives and services
   - Breakpoint-aware components
5. **Animation & Interactions**
   - Micro-interaction implementation
   - Animation performance
   - Transition strategies
   - Gesture handling
   - Loading states
   - Responsive animation timing
6. **Accessibility Implementation**
   - ARIA attributes needed
   - Keyboard navigation plan
   - Screen reader support
   - Focus management
   - Color contrast verification
   - Touch target sizing (44px minimum on mobile)
7. **Performance Optimization**
   - Bundle size estimates
   - Lazy loading opportunities
   - Image optimization needs
   - Code splitting points
   - Render optimization
   - Responsive image strategies

FIGMA TO CODE MAPPING:
1. Extract design tokens programmatically
2. Map Figma components to Angular components
3. Identify shared styles and mixins
4. Plan responsive behavior
5. Document interaction states

Provide detailed implementation blueprint with code structure, patterns, and specific Angular implementation details.

[Design context from Phase 1]
```

### Visual Design System Enhancement
Following the Frontend Developer's technical analysis, enhance the visual design.

```
Using the Visual Designer agent to: As Visual Designer, enhance the Figma design for optimal implementation:

VISUAL DESIGN ENHANCEMENT:
1. Generate cohesive color palette with semantic meanings
2. Define responsive typography scale (mobile to desktop)
3. Create 8-point grid spacing rhythm for perfect alignment
4. Design elevation and shadow system
5. Suggest micro-interactions and animation patterns
6. Ensure visual hierarchy across all breakpoints
7. Apply emotional design principles
8. Validate accessibility standards (WCAG 2.1 AA)

RESPONSIVE DESIGN ANALYSIS:
1. Analyze Figma Auto Layout for responsive behavior
2. Map constraints to CSS Grid/Flexbox patterns
3. Define breakpoint-specific layouts
4. Ensure touch-friendly interactions on mobile
5. Create fluid typography system
6. Design adaptive spacing that scales with viewport
7. Plan image optimization strategy

ALIGNMENT & GRID SYSTEM:
1. Implement consistent 8-point grid across all elements
2. Define column grid for each breakpoint
3. Create mathematical spacing relationships
4. Ensure optical alignment for visual balance
5. Map Figma frame guides to CSS Grid lines
6. Design flexible gutters that adapt to screen size
7. Create alignment tokens for consistent implementation

Provide integrated design system with UX specifications, including all design tokens, patterns, and implementation guidelines.

[Design context from Phase 1]
```

### Technical Architecture & Implementation Planning (OPTIMIZED)
I'll have the Tech Lead provide comprehensive technical guidance.

```
Using the general-purpose agent to: As Tech Lead with full-stack expertise, design the complete technical approach for implementing this Figma component:

ARCHITECTURE PLANNING:
1. Component hierarchy and composition strategy
2. State management approach (signals, stores, context)
3. Responsive component architecture
4. Performance optimization strategies
5. Scalability considerations
6. Integration patterns with existing systems

RESPONSIVE IMPLEMENTATION RESEARCH:
1. Framework-specific responsive patterns for: [Framework: $ARGUMENTS]
2. CSS Grid vs Flexbox decision matrix
3. Container query support and polyfills
4. Responsive image optimization techniques
5. Performance impact of responsive features
6. Cross-browser compatibility for modern CSS

FRONTEND ARCHITECTURE:
1. Component structure with responsive considerations
2. Type definitions for responsive props and breakpoints
3. Responsive design system implementation
4. Accessibility across all screen sizes
5. Testing strategy (unit, integration, visual regression, responsive)
6. Error handling and recovery patterns
7. Code organization with responsive utilities
8. Bundle optimization per device category
9. Development workflow with device preview

FIGMA TO CODE MAPPING:
1. Auto Layout to CSS Flexbox/Grid conversion
2. Constraints to responsive behavior mapping
3. Design token extraction and implementation
4. Breakpoint strategy from Figma frames
5. Component variant handling for screen sizes
6. Spacing token implementation with 8pt grid
7. Typography scale preservation across devices

Provide unified technical blueprint covering architecture, research insights, and implementation details.

[Design context from Phase 1]
[Enhanced design from previous task]
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
   - Responsive component patterns

2. **Implements Responsive Design Excellence**
   - Mobile-first CSS architecture
   - Flexible Grid and Flexbox layouts
   - Fluid typography with clamp() functions
   - Breakpoint-aware components
   - Container queries for component responsiveness
   - Touch-optimized interactions

3. **Applies Visual Design System**
   - Design tokens from Visual Designer
   - 8-point grid spacing system
   - Responsive color schemes
   - Typography scale across devices
   - Mathematical spacing relationships
   - Device-appropriate animations

4. **Ensures Perfect Alignment**
   - Figma Auto Layout to CSS mapping
   - Constraint-based responsive behavior
   - Optical alignment adjustments
   - Grid-based component placement
   - Consistent spacing tokens
   - Visual rhythm preservation

5. **Incorporates Tech Lead's Guidance**
   - System integration patterns
   - Scalability considerations
   - API design alignment
   - Monitoring approach
   - Security requirements

6. **Implements Accessibility Excellence**
   - WCAG 2.1 AA compliance
   - Responsive keyboard navigation
   - Screen reader optimization
   - Focus management across breakpoints
   - Touch target sizing (44px minimum)
   - High contrast support

7. **Ensures Code Quality**
   - Clean, maintainable code
   - Responsive testing strategies
   - Visual regression testing
   - Performance budgets per device
   - Progressive enhancement

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
/* Design tokens from Figma with responsive considerations */
:root {
  /* 8-Point Grid Base Unit */
  --grid-unit: 8px;
  
  /* Color System */
  --color-primary: [from Figma variables];
  --color-secondary: [from Figma variables];
  --color-accent: [from Figma variables];
  
  /* Responsive Typography Scale */
  --font-size-xs: clamp(0.75rem, 0.7rem + 0.25vw, 0.875rem);
  --font-size-sm: clamp(0.875rem, 0.8rem + 0.375vw, 1rem);
  --font-size-base: clamp(1rem, 0.95rem + 0.25vw, 1.125rem);
  --font-size-md: clamp(1.125rem, 1.05rem + 0.375vw, 1.25rem);
  --font-size-lg: clamp(1.25rem, 1.15rem + 0.5vw, 1.5rem);
  --font-size-xl: clamp(1.5rem, 1.35rem + 0.75vw, 2rem);
  --font-size-2xl: clamp(2rem, 1.75rem + 1.25vw, 3rem);
  
  /* 8-Point Grid Spacing System */
  --space-0: 0;
  --space-1: calc(var(--grid-unit) * 0.5);   /* 4px */
  --space-2: var(--grid-unit);               /* 8px */
  --space-3: calc(var(--grid-unit) * 2);     /* 16px */
  --space-4: calc(var(--grid-unit) * 3);     /* 24px */
  --space-5: calc(var(--grid-unit) * 4);     /* 32px */
  --space-6: calc(var(--grid-unit) * 5);     /* 40px */
  --space-7: calc(var(--grid-unit) * 6);     /* 48px */
  --space-8: calc(var(--grid-unit) * 8);     /* 64px */
  --space-10: calc(var(--grid-unit) * 10);   /* 80px */
  --space-12: calc(var(--grid-unit) * 12);   /* 96px */
  
  /* Responsive Container Padding */
  --container-padding: clamp(var(--space-3), 4vw, var(--space-6));
  
  /* Motion (responsive duration) */
  --motion-duration: [from Figma animation settings];
  --motion-duration-mobile: calc(var(--motion-duration) * 0.8);
  --motion-easing: cubic-bezier(0.4, 0, 0.2, 1);
  
  /* Elevation */
  --shadow-subtle: 0 1px 2px rgba(0, 0, 0, 0.05);
  --shadow-moderate: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  --shadow-dramatic: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
  
  /* Breakpoints from Figma */
  --breakpoint-mobile: 375px;
  --breakpoint-tablet: 768px;
  --breakpoint-desktop: 1440px;
  --breakpoint-wide: 1920px;
}

/* Component styles with responsive design and alignment */
.component {
  /* Apply responsive design system */
  color: var(--color-text);
  font-size: var(--font-size-base);
  line-height: 1.5;
  
  /* Responsive padding aligned to 8pt grid */
  padding: var(--space-3) var(--space-4);
  
  /* Container query for component-level responsiveness */
  container-type: inline-size;
  
  /* Flexbox for internal alignment */
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
  align-items: flex-start;
  
  /* Visual properties */
  border-radius: var(--radius-moderate);
  box-shadow: var(--shadow-subtle);
  transition: all var(--motion-duration) var(--motion-easing);
  
  /* Mobile-specific adjustments */
  @media (max-width: 767px) {
    padding: var(--space-2) var(--space-3);
    gap: var(--space-2);
    font-size: var(--font-size-sm);
  }
  
  /* Tablet and up */
  @media (min-width: 768px) {
    padding: var(--space-4) var(--space-5);
    gap: var(--space-4);
  }
  
  /* Desktop optimization */
  @media (min-width: 1440px) {
    padding: var(--space-5) var(--space-6);
  }
  
  /* Container queries for component adaptability */
  @container (max-width: 400px) {
    flex-direction: column;
    align-items: stretch;
  }
  
  @container (min-width: 401px) {
    flex-direction: row;
    align-items: center;
  }
}

/* Grid layout with responsive columns */
.grid-container {
  display: grid;
  gap: var(--space-4);
  padding: var(--container-padding);
  
  /* Mobile: Single column */
  grid-template-columns: 1fr;
  
  /* Tablet: 2 columns */
  @media (min-width: 768px) {
    grid-template-columns: repeat(2, 1fr);
  }
  
  /* Desktop: Auto-fit with minimum size */
  @media (min-width: 1024px) {
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  }
  
  /* Ensure alignment to 8pt grid */
  > * {
    align-self: start;
  }
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
Using the Frontend Developer agent to: As Frontend Developer with design sensibility, validate the complete implementation:

CODE IMPLEMENTATION REVIEW:
1. Component architecture and patterns
2. State management effectiveness
3. Type safety and error handling
4. Performance optimizations applied
5. Accessibility implementation (ARIA, keyboard, touch)
6. Testing coverage and quality
7. Bundle size and optimization
8. Security best practices
9. Code maintainability and documentation
10. Responsive component patterns

VISUAL IMPLEMENTATION VALIDATION:
1. Design fidelity to Figma source
2. Auto Layout to CSS accuracy
3. Constraint behavior preservation
4. 8-point grid alignment verification
5. Color implementation and contrast (4.5:1)
6. Typography scale consistency
7. Spacing token implementation
8. Responsive breakpoint accuracy
9. Touch target sizing (44px minimum)
10. Animation performance across devices
11. Cross-browser visual consistency
12. Brand guidelines adherence

RESPONSIVE DESIGN VALIDATION:
1. Mobile-first implementation
2. Breakpoint transition smoothness
3. Content reflow logic
4. Image optimization per device
5. Performance on slow networks
6. Viewport meta tag configuration
7. Container query support
8. Fluid typography scaling
9. Grid/Flexbox responsiveness
10. Landscape orientation handling

Provide integrated quality assessment with:
- Visual fidelity score (0-100)
- Code quality score (0-100)
- Performance metrics
- Accessibility compliance
- Specific improvements needed
- Overall implementation excellence rating
```

### Automated Validation
```bash
# Visual regression testing across breakpoints
npm run test:visual -- --viewports=mobile,tablet,desktop

# Responsive design testing
npm run test:responsive -- --breakpoints=375,768,1024,1440

# Accessibility audit with mobile considerations
npm run test:a11y -- --coverage --touch-targets

# Performance profiling per device category
npm run lighthouse -- --budget-path=./budgets.json --emulated-device="Pixel 5"
npm run lighthouse -- --budget-path=./budgets.json --emulated-device="iPad"
npm run lighthouse -- --budget-path=./budgets.json --emulated-device="Desktop"

# Bundle analysis with device-specific chunks
npm run analyze:bundle -- --chunks=mobile,tablet,desktop

# Grid alignment validation
npm run test:alignment -- --grid-unit=8

# Animation performance across devices
npm run test:animations -- --fps-threshold=60 --devices=all

# Cross-browser testing with responsive viewports
npm run test:browsers -- --browsers=chrome,firefox,safari,edge --responsive

# Figma design fidelity check
npm run test:figma-fidelity -- --tolerance=2px
```

### Enhanced Manual Review Checklist

#### Visual Excellence
- [ ] **Design Fidelity**: Pixel-perfect match to Figma design
- [ ] **Auto Layout Accuracy**: CSS faithfully reproduces Figma Auto Layout
- [ ] **Constraint Behavior**: Responsive constraints work as designed
- [ ] **8-Point Grid**: All spacing aligns to 8px grid
- [ ] **Color System**: All colors from Figma variables
- [ ] **Typography**: Responsive scale matches design
- [ ] **Spacing**: Consistent use of spacing tokens
- [ ] **Elevation**: Shadows create proper depth
- [ ] **Icons**: Consistent style and sizing
- [ ] **Imagery**: Optimized and responsive

#### Responsive Design
- [ ] **Mobile-First**: Base styles for smallest viewport
- [ ] **Breakpoints**: Smooth transitions at 375px, 768px, 1024px, 1440px
- [ ] **Touch Targets**: Minimum 44px on mobile devices
- [ ] **Content Reflow**: Logical reorganization across breakpoints
- [ ] **Typography Scaling**: Fluid font sizes with clamp()
- [ ] **Image Optimization**: Responsive images with srcset
- [ ] **Grid Adaptation**: Column count adjusts to viewport
- [ ] **Flexbox Wrapping**: Components wrap gracefully
- [ ] **Container Queries**: Component-level responsiveness
- [ ] **Landscape Mode**: Proper handling of orientation

#### Alignment & Layout
- [ ] **Grid System**: Consistent column grid implementation
- [ ] **Optical Alignment**: Visual balance beyond mathematical
- [ ] **Spacing Rhythm**: Mathematical relationships preserved
- [ ] **Component Alignment**: Elements align to grid lines
- [ ] **Gutter Consistency**: Responsive gutters scale properly
- [ ] **Baseline Grid**: Text aligns to vertical rhythm
- [ ] **Edge Alignment**: Content aligns to container edges

#### Interaction & Animation
- [ ] **Micro-interactions**: Enhance usability
- [ ] **State Transitions**: Smooth and purposeful
- [ ] **Loading States**: Skeleton screens match layout
- [ ] **Error States**: Clear and helpful
- [ ] **Success Feedback**: Celebratory but professional
- [ ] **Hover Effects**: Subtle and consistent (desktop only)
- [ ] **Touch Feedback**: Appropriate for mobile
- [ ] **Focus States**: Visible and accessible
- [ ] **Gesture Support**: Swipe, pinch where appropriate

#### Technical Excellence
- [ ] **Performance**: FCP < 1.5s, TTI < 3s on 3G
- [ ] **Accessibility**: WCAG 2.1 AA compliant
- [ ] **Responsive**: Works on all devices and orientations
- [ ] **Cross-browser**: Consistent experience
- [ ] **Progressive Enhancement**: Core functionality without JS
- [ ] **SEO**: Proper meta tags and structure
- [ ] **Security**: No XSS vulnerabilities
- [ ] **Code Quality**: Clean and maintainable
- [ ] **Bundle Optimization**: Device-specific code splitting

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
**Design Source**: Current Figma selection with responsive context
**Target Framework**: $ARGUMENTS or auto-detected
**Responsive Strategy**: Mobile-first with 8-point grid alignment
**Layout System**: Figma Auto Layout → CSS Grid/Flexbox
**Visual Designer**: Enhanced with responsive design system
**Frontend Developer**: Optimized for all devices and alignments

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
   - 8-point grid creating perfect alignment
   - Mathematical spacing relationships
   - Thoughtful animations enhancing usability
   
2. **Responsive Excellence**:
   - Mobile-first implementation
   - Fluid typography and spacing
   - Breakpoint-aware components
   - Touch-optimized interactions
   - Container query support
   
3. **Figma Fidelity**:
   - Auto Layout accurately translated
   - Constraints preserved in CSS
   - Design tokens extracted and implemented
   - Visual parity across breakpoints
   - Component variants handled
   
4. **Technical Excellence**: 
   - Type-safe, testable architecture
   - Performance-optimized rendering
   - Device-specific optimizations
   - Progressive enhancement
   - Comprehensive error handling
   
5. **Accessibility Leadership**: 
   - WCAG 2.1 AA compliance
   - Responsive keyboard navigation
   - Touch target optimization (44px)
   - Screen reader optimization
   - Focus management across devices
   
6. **Developer Experience**: 
   - Self-documenting code
   - Responsive testing suite
   - Clear component APIs
   - Design system alignment
   - MCP integration patterns
   
7. **User Delight**: 
   - Instant feedback for all actions
   - Smooth transitions between breakpoints
   - Clear visual hierarchy on all devices
   - Optimized performance on mobile
   - Natural interaction patterns

### Next Steps
1. Review generated implementation
2. Test across devices and browsers
3. Gather user feedback
4. Iterate based on metrics
5. Document learnings

---

### Best Practices Summary

When using this command with Figma MCP:
1. **Break Down Large Selections**: Work with individual components or logical sections
2. **Use Auto Layout**: Ensures responsive behavior is communicated to the AI
3. **Add Annotations**: Include design intent that's not visually obvious
4. **Name Semantically**: Use clear, meaningful names for layers and components
5. **Define Variables**: Set up design tokens in Figma for consistent implementation
6. **Test Responsiveness**: Resize frames in Figma before generating code
7. **Specify Breakpoints**: Include frame variations for different screen sizes

**Remember**: This command leverages the full power of Opus 4's multi-agent system with enhanced responsive design capabilities to ensure your Figma designs become not just functional code, but exceptional user experiences that are perfectly aligned, responsive, accessible, performant, and maintainable across all devices.
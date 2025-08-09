---
description: Update frontend feature with modern UI patterns, accessibility, and comprehensive testing
allowed-tools: [Task, Read, Write, Edit, MultiEdit, Grep, Glob, LS, TodoWrite, Bash]
argument-hint: frontend feature update description (e.g., "update dashboard with real-time data visualization")
---

# 🎨 Update Frontend Feature: $ARGUMENTS

## 🧠 OPUS 4 FRONTEND EXCELLENCE MODE


### Frontend Modernization Principles
- **User Experience First**: Performance, accessibility, delight
- **Component Reusability**: Shared design system
- **State Management**: Modern patterns (Signals/Stores)
- **Responsive Design**: Mobile-first approach
- **Test Coverage**: 100% success with visual regression

## Phase 0: Frontend Discovery & Planning



### Frontend Component Discovery
```bash
# Parallel frontend discovery
Finding files matching: **/components/*$FEATURE*.*
Finding files matching: **/services/*$FEATURE*.*
Finding files matching: **/styles/*$FEATURE*.*
Finding files matching: **/*$FEATURE*.spec.ts
Searching for pattern: @Component.*$FEATURE|class.*$FEATURE.*Component
```

### Frontend Update Task List
I'll update the task list to track our progress.

## Phase 1: Parallel Frontend Analysis



### Comprehensive Frontend Analysis

I'll have the Frontend Developer agent Frontend architecture analysis.

I'll have the Visual Designer agent Visual design enhancement.

I'll have the Visual Designer agent UX and accessibility audit.

I'll have the general-purpose agent Frontend code quality review.

## Phase 2: Component Architecture Update



### Modern Angular Component Structure

```typescript
// Updated component with backward compatibility
Using Component tool for this operation.">
            <!-- Modern implementation with signals -->
            @if (!legacyMode()) {
                <div class="modern-ui">
                    @for (item of items(); track item.id) {
                        <app-feature-item 
                            [item]="item"
                            [selected]="isSelected(item.id)"
                            (select)="onSelect($event)"
                        />
                    }
                    
                    @if (loading()) {
                        <app-skeleton-loader />
                    }
                    
                    @if (error()) {
                        <app-error-state [error]="error()" />
                    }
                </div>
            }
            
            <!-- Fallback for legacy support -->
            @else {
                <div class="legacy-ui">
                    <div *ngFor="let item of items$ | async; trackBy: trackById">
                        <app-legacy-item [item]="item" />
                    </div>
                </div>
            }
        </div>
    `,
    styleUrl: './feature.component.scss',
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class FeatureComponent implements OnInit {
    // Modern signal-based state
    items = signal<Item[]>([]);
    loading = signal(false);
    error = signal<Error | null>(null);
    selectedIds = signal<Set<string>>(new Set());
    
    // Legacy observable support
    items$ = new BehaviorSubject<Item[]>([]);
    legacyMode = signal(false);
    
    // Computed values
    selectedCount = computed(() => this.selectedIds().size);
    hasSelection = computed(() => this.selectedCount() > 0);
    
    private featureService = inject(FeatureService);
    private config = inject(ConfigService);
    
    ngOnInit() {
        // Check for legacy mode
        this.legacyMode.set(this.config.useLegacyUI);
        
        // Load data
        this.loadItems();
    }
    
    async loadItems() {
        this.loading.set(true);
        this.error.set(null);
        
        try {
            const items = await this.featureService.getItems();
            this.items.set(items);
            
            // Update legacy observable for backward compatibility
            if (this.legacyMode()) {
                this.items$.next(items);
            }
        } catch (error) {
            this.error.set(error as Error);
        } finally {
            this.loading.set(false);
        }
    }
    
    isSelected(id: string): boolean {
        return this.selectedIds().has(id);
    }
    
    onSelect(id: string) {
        this.selectedIds.update(ids => {
            const newIds = new Set(ids);
            if (newIds.has(id)) {
                newIds.delete(id);
            } else {
                newIds.add(id);
            }
            return newIds;
        });
    }
    
    trackById(index: number, item: Item): string {
        return item.id;
    }
}
```

## Phase 3: Enhanced State Management



### Modern State with Signals

```typescript
// Feature state service
Using Injectable tool for this operation.
export class FeatureStateService {
    // State signals
    private itemsSignal = signal<Item[]>([]);
    private loadingSignal = signal(false);
    private errorSignal = signal<Error | null>(null);
    private filtersSignal = signal<Filters>({});
    
    // Public readonly signals
    readonly items = this.itemsSignal.asReadonly();
    readonly loading = this.loadingSignal.asReadonly();
    readonly error = this.errorSignal.asReadonly();
    readonly filters = this.filtersSignal.asReadonly();
    
    // Computed values
    readonly filteredItems = computed(() => {
        const items = this.items();
        const filters = this.filters();
        
        return items.filter(item => 
            this.matchesFilters(item, filters)
        );
    });
    
    readonly totalCount = computed(() => this.items().length);
    readonly filteredCount = computed(() => this.filteredItems().length);
    
    // Effects
    constructor() {
        // Auto-save filters to localStorage
        effect(() => {
            const filters = this.filters();
            localStorage.setItem('feature-filters', JSON.stringify(filters));
        });
        
        // Log errors to monitoring (if not in cloud)
        effect(() => {
            const error = this.error();
            if (error && !environment.isCloud) {
                console.error('Feature error:', error);
            }
        });
    }
    
    // Actions
    async loadItems() {
        this.loadingSignal.set(true);
        this.errorSignal.set(null);
        
        try {
            const items = await this.fetchItems();
            this.itemsSignal.set(items);
        } catch (error) {
            this.errorSignal.set(error as Error);
        } finally {
            this.loadingSignal.set(false);
        }
    }
    
    updateFilters(filters: Partial<Filters>) {
        this.filtersSignal.update(current => ({
            ...current,
            ...filters
        }));
    }
    
    clearFilters() {
        this.filtersSignal.set({});
    }
}
```

## Phase 4: UI/UX Enhancements



### Enhanced Styles with CSS Variables

```scss
// Modern SCSS with CSS custom properties
.feature-container {
    // CSS variables for theming
    --feature-primary: var(--color-primary, #007bff);
    --feature-spacing: var(--spacing-unit, 8px);
    --feature-radius: var(--border-radius, 4px);
    --feature-transition: var(--transition-default, 200ms ease);
    
    // Container styles
    display: grid;
    gap: calc(var(--feature-spacing) * 2);
    padding: calc(var(--feature-spacing) * 3);
    
    // Responsive grid
    @container (min-width: 768px) {
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    }
    
    // Modern UI styles
    .modern-ui {
        // Smooth animations
        animation: fadeIn var(--feature-transition);
        
        // Grid layout
        display: grid;
        gap: var(--feature-spacing);
        
        // Card styles
        .feature-item {
            background: var(--surface-color);
            border-radius: var(--feature-radius);
            padding: calc(var(--feature-spacing) * 2);
            transition: transform var(--feature-transition),
                       box-shadow var(--feature-transition);
            
            // Hover effects
            &:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-elevated);
            }
            
            // Focus styles for accessibility
            &:focus-within {
                outline: 2px solid var(--feature-primary);
                outline-offset: 2px;
            }
        }
    }
    
    // Legacy mode styles (backward compatibility)
    &.legacy-mode {
        .legacy-ui {
            // Simpler styles for legacy support
            display: flex;
            flex-direction: column;
            gap: var(--feature-spacing);
        }
    }
}

// Skeleton loader animation
@keyframes shimmer {
    0% { background-position: -1000px 0; }
    100% { background-position: 1000px 0; }
}

.skeleton-loader {
    background: linear-gradient(
        90deg,
        var(--skeleton-base) 25%,
        var(--skeleton-highlight) 50%,
        var(--skeleton-base) 75%
    );
    background-size: 1000px 100%;
    animation: shimmer 2s infinite;
}

// Dark mode support
@media (prefers-color-scheme: dark) {
    .feature-container {
        --feature-primary: #4dabf7;
        --surface-color: #1e1e1e;
        --text-color: #e0e0e0;
    }
}

// Reduced motion support
@media (prefers-reduced-motion: reduce) {
    .feature-container * {
        animation-duration: 0.01ms !important;
        transition-duration: 0.01ms !important;
    }
}
```

## Phase 5: Accessibility Improvements



### ARIA and Keyboard Navigation

```typescript
// Accessible component template
template: `
    <div 
        class="feature-list"
        role="region"
        aria-label="Feature items"
        aria-busy="{{ loading() }}"
        aria-live="polite"
    >
        <!-- Skip link for keyboard users -->
        <a href="#feature-actions" class="skip-link">
            Skip to actions
        </a>
        
        <!-- Accessible grid -->
        <div 
            role="grid"
            aria-rowcount="{{ filteredItems().length }}"
            aria-colcount="3"
        >
            @for (item of filteredItems(); track item.id; let i = $index) {
                <div
                    role="row"
                    aria-rowindex="{{ i + 1 }}"
                    [attr.aria-selected]="isSelected(item.id)"
                    tabindex="{{ i === 0 ? 0 : -1 }}"
                    (keydown)="handleKeyboardNavigation($event, i)"
                >
                    <div role="gridcell">{{ item.name }}</div>
                    <div role="gridcell">{{ item.status }}</div>
                    <div role="gridcell">
                        <button
                            [attr.aria-label]="'Select ' + item.name"
                            [attr.aria-pressed]="isSelected(item.id)"
                            (click)="onSelect(item.id)"
                        >
                            {{ isSelected(item.id) ? 'Selected' : 'Select' }}
                        </button>
                    </div>
                </div>
            }
        </div>
        
        <!-- Screen reader announcements -->
        <div class="sr-only" aria-live="assertive">
            @if (announcementMessage()) {
                {{ announcementMessage() }}
            }
        </div>
    </div>
`

// Keyboard navigation handler
handleKeyboardNavigation(event: KeyboardEvent, currentIndex: number) {
    const items = this.filteredItems();
    let nextIndex = currentIndex;
    
    switch (event.key) {
        case 'ArrowDown':
            nextIndex = Math.min(currentIndex + 1, items.length - 1);
            break;
        case 'ArrowUp':
            nextIndex = Math.max(currentIndex - 1, 0);
            break;
        case 'Home':
            nextIndex = 0;
            break;
        case 'End':
            nextIndex = items.length - 1;
            break;
        case ' ':
        case 'Enter':
            this.onSelect(items[currentIndex].id);
            this.announce(`${items[currentIndex].name} ${
                this.isSelected(items[currentIndex].id) ? 'selected' : 'deselected'
            }`);
            return;
    }
    
    if (nextIndex !== currentIndex) {
        event.preventDefault();
        this.focusItem(nextIndex);
    }
}
```

## Phase 6: Comprehensive Frontend Testing



### Unit Tests with 100% Coverage

```typescript
describe('FeatureComponent', () => {
    let component: FeatureComponent;
    let fixture: ComponentFixture<FeatureComponent>;
    let service: jasmine.SpyObj<FeatureService>;
    
    beforeEach(async () => {
        const serviceSpy = jasmine.createSpyObj('FeatureService', ['getItems']);
        
        await TestBed.configureTestingModule({
            imports: [FeatureComponent],
            providers: [
                { provide: FeatureService, useValue: serviceSpy }
            ]
        }).compileComponents();
        
        service = TestBed.inject(FeatureService) as jasmine.SpyObj<FeatureService>;
        fixture = TestBed.createComponent(FeatureComponent);
        component = fixture.componentInstance;
    });
    
    // Component initialization
    it('should create', () => {
        expect(component).toBeTruthy();
    });
    
    // Data loading
    it('should load items on init', fakeAsync(() => {
        const mockItems = [
            { id: '1', name: 'Item 1' },
            { id: '2', name: 'Item 2' }
        ];
        service.getItems.and.returnValue(Promise.resolve(mockItems));
        
        component.ngOnInit();
        tick();
        
        expect(component.items()).toEqual(mockItems);
        expect(component.loading()).toBeFalse();
    }));
    
    // Error handling
    it('should handle loading errors', fakeAsync(() => {
        const error = new Error('Loading failed');
        service.getItems.and.returnValue(Promise.reject(error));
        
        component.loadItems();
        tick();
        
        expect(component.error()).toEqual(error);
        expect(component.loading()).toBeFalse();
    }));
    
    // Selection logic
    it('should toggle item selection', () => {
        component.onSelect('1');
        expect(component.isSelected('1')).toBeTrue();
        
        component.onSelect('1');
        expect(component.isSelected('1')).toBeFalse();
    });
    
    // Accessibility
    it('should handle keyboard navigation', () => {
        const items = [
            { id: '1', name: 'Item 1' },
            { id: '2', name: 'Item 2' }
        ];
        component.items.set(items);
        
        const event = new KeyboardEvent('keydown', { key: 'ArrowDown' });
        spyOn(component, 'focusItem');
        
        component.handleKeyboardNavigation(event, 0);
        
        expect(component.focusItem).toHaveBeenCalledWith(1);
    });
    
    // Visual regression
    it('should match visual snapshot', async () => {
        await expectAsync(fixture.nativeElement).toMatchSnapshot();
    });
});
```

### E2E Tests

```typescript
describe('Feature E2E Tests', () => {
    beforeEach(() => {
        cy.visit('/feature');
    });
    
    it('should display and interact with features', () => {
        // Wait for data load
        cy.get('[data-test="feature-item"]').should('have.length.greaterThan', 0);
        
        // Test selection
        cy.get('[data-test="feature-item"]').first().click();
        cy.get('[data-test="feature-item"]').first()
            .should('have.attr', 'aria-selected', 'true');
        
        // Test filtering
        cy.get('[data-test="filter-input"]').type('test');
        cy.get('[data-test="feature-item"]').should('have.length', 2);
        
        // Test keyboard navigation
        cy.get('[data-test="feature-list"]').focus();
        cy.realPress('ArrowDown');
        cy.focused().should('have.attr', 'aria-rowindex', '2');
        
        // Test accessibility
        cy.injectAxe();
        cy.checkA11y();
    });
    
    it('should handle errors gracefully', () => {
        cy.intercept('GET', '/api/features', { statusCode: 500 });
        cy.visit('/feature');
        
        cy.get('[data-test="error-state"]').should('be.visible');
        cy.get('[data-test="retry-button"]').click();
    });
});
```

## Phase 7: Performance Optimization



### Performance Enhancements

```typescript
// Optimized service with caching
Using Injectable tool for this operation.
export class FeatureService {
    private cache = new Map<string, CacheEntry>();
    private readonly CACHE_TTL = 5 * 60 * 1000; // 5 minutes
    
    async getItems(): Promise<Item[]> {
        const cacheKey = 'items';
        const cached = this.getFromCache(cacheKey);
        
        if (cached) {
            return cached;
        }
        
        const items = await this.fetchItems();
        this.setCache(cacheKey, items);
        
        return items;
    }
    
    private getFromCache(key: string): any {
        const entry = this.cache.get(key);
        if (!entry) return null;
        
        if (Date.now() - entry.timestamp > this.CACHE_TTL) {
            this.cache.delete(key);
            return null;
        }
        
        return entry.data;
    }
    
    private setCache(key: string, data: any) {
        this.cache.set(key, {
            data,
            timestamp: Date.now()
        });
    }
}

// Virtual scrolling for large lists
Using Component tool for this operation.; trackBy: trackById">
                <app-feature-item [item]="item" />
            </div>
        </cdk-virtual-scroll-viewport>
    `
})
export class VirtualScrollFeature { }
```

## Phase 8: Validation Loop



### Continuous Frontend Validation

```typescript
async function validateFrontendUpdate(): Promise<ValidationResult> {
    let confidence = 0;
    let testSuccess = 0;
    let iterations = 0;
    
    while (confidence < 99 || testSuccess < 100) {
        iterations++;
        
        // Run all tests
        const unitTests = await runUnitTests();
        const e2eTests = await runE2ETests();
        const visualTests = await runVisualRegressionTests();
        const a11yTests = await runAccessibilityTests();
        const perfTests = await runPerformanceTests();
        
        // Calculate success rate
        testSuccess = calculateSuccessRate([
            unitTests,
            e2eTests,
            visualTests,
            a11yTests,
            perfTests
        ]);
        
        // Fix failures
        if (testSuccess < 100) {
            await fixTestFailures({
                unitTests,
                e2eTests,
                visualTests,
                a11yTests,
                perfTests
            });
            continue;
        }
        
        // Calculate confidence
        confidence = calculateConfidence({
            coverage: await getCodeCoverage(),
            performance: perfTests,
            accessibility: a11yTests,
            userFlow: e2eTests
        });
    }
    
    return {
        success: true,
        confidence,
        testSuccess,
        iterations
    };
}
```

## Completion Criteria

```yaml
Frontend Update Checklist:
  ✓ Components updated
  ✓ State management modernized
  ✓ Accessibility improved (WCAG 2.1 AA)
  ✓ Performance optimized
  ✓ Responsive design verified
  ✓ Unit tests: 100% passing
  ✓ E2E tests: 100% passing
  ✓ Visual regression: Verified
  ✓ No monitoring overhead
  ✓ Backward compatibility maintained
```


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

## Final Validation

```markdown
## Confidence Score: ≥99%

Frontend Validation:
- Components updated: 100%
- Test success: 100%
- Accessibility: WCAG 2.1 AA
- Performance: Within budget
- User experience: Enhanced

✅ Frontend feature successfully updated
```

This command will NOT terminate until:
1. All frontend components updated
2. 100% test success achieved
3. Accessibility validated
4. Performance optimized
5. Confidence ≥99%
---
description: Replace frontend feature entirely with modern UI framework patterns, removing all legacy code
allowed-tools: [Task, Read, Write, Edit, MultiEdit, Grep, Glob, LS, TodoWrite, Bash]
argument-hint: frontend feature replacement description (e.g., "replace jQuery UI with modern Angular components")
agent-dependencies: [Frontend Developer, Visual Designer, UX Reviewer, Technical Debt Analyst, Test Quality Analyst]
complexity: high
estimated-time: 20-25 minutes
category: development
---

# 🔥 Replace Frontend Feature (No Compatibility): $ARGUMENTS

## ⚠️ RADICAL FRONTEND MODERNIZATION
<think harder about completely replacing frontend with cutting-edge patterns, zero legacy support>

### Aggressive Frontend Transformation
- **Latest Angular 19 Only**: No backward compatibility
- **Signals Everywhere**: No observables, no subjects
- **Standalone Only**: No modules
- **Modern CSS Only**: Grid, Container Queries, Layers
- **No Legacy Browser Support**: Chrome 100+, Firefox 100+, Safari 15+

## Phase 0: Legacy Frontend Elimination Planning

<think step-by-step about removing all legacy UI code>

### Legacy Frontend Discovery
```bash
# Find all legacy frontend code
@Grep(pattern="Observable|Subject|subscribe|ngModule", output_mode="files_with_matches")
@Grep(pattern="jQuery|bootstrap[^-]|legacy|deprecated", output_mode="files_with_matches")
@Glob(pattern="**/*legacy*.*")
@Glob(pattern="**/*.module.ts")
```

### Aggressive Frontend Cleanup Tasks
@TodoWrite(todos=[
  {id: "1", content: "Identify all legacy components", status: "pending", priority: "high"},
  {id: "2", content: "Remove legacy modules", status: "pending", priority: "high"},
  {id: "3", content: "Remove observable patterns", status: "pending", priority: "high"},
  {id: "4", content: "Remove legacy styles", status: "pending", priority: "high"},
  {id: "5", content: "Remove jQuery dependencies", status: "pending", priority: "high"},
  {id: "6", content: "Implement pure signal architecture", status: "pending", priority: "high"},
  {id: "7", content: "Implement modern CSS architecture", status: "pending", priority: "high"},
  {id: "8", content: "Create new test suite", status: "pending", priority: "high"},
  {id: "9", content: "Achieve 100% test success", status: "pending", priority: "high"},
  {id: "10", content: "Validate modern browser only", status: "pending", priority: "high"}
])

## Phase 1: Parallel Modern Frontend Design

<think harder about unrestricted modern UI patterns>

### Radical Frontend Redesign

@Task(description="Modern frontend architecture", prompt="Design cutting-edge frontend for $ARGUMENTS with NO legacy constraints:
1. Use Angular 19 signals exclusively
2. Implement standalone components only
3. Use Vite for building (no Webpack)
4. Implement Module Federation for micro-frontends
5. Use Web Components where beneficial
6. Implement edge-side rendering
7. Use WebAssembly for compute-intensive tasks
8. Implement service workers for offline
9. Use Web Push API for notifications
10. Implement WebRTC for real-time features
Provide radical modernization blueprint", subagent_type="Frontend Developer")

@Task(description="Next-gen visual design", prompt="Create futuristic design for $ARGUMENTS:
1. Use CSS Grid and Subgrid exclusively
2. Implement Container Queries everywhere
3. Use CSS Layers for cascade control
4. Implement View Transitions API
5. Use CSS Houdini for custom properties
6. Implement scroll-driven animations
7. Use aspect-ratio and logical properties
8. Implement color-mix() and color-contrast()
9. Use :has() selector aggressively
10. Implement @starting-style animations
Design with zero legacy CSS", subagent_type="Visual Designer")

@Task(description="Modern UX patterns", prompt="Design cutting-edge UX for $ARGUMENTS:
1. Implement gesture controls
2. Use Web Speech API for voice commands
3. Implement haptic feedback
4. Use Intersection Observer for lazy loading
5. Implement infinite scroll with virtualization
6. Use Web Share API for native sharing
7. Implement biometric authentication
8. Use Ambient Light API for auto-theming
9. Implement WebXR for AR features
10. Use Web NFC for contactless interactions
Create futuristic user experience", subagent_type="Visual Designer")

@Task(description="Legacy elimination", prompt="Remove ALL legacy patterns from $ARGUMENTS:
1. Find and remove all RxJS usage
2. Remove all NgModules
3. Remove all deprecated directives
4. Remove Bootstrap/jQuery
5. Remove all class-based services
6. Remove all string-based DI
7. Remove all template-driven forms
8. Remove all ViewChild decorators
9. Remove all lifecycle hooks (use signals)
10. Remove all zone.js dependencies
Provide complete elimination plan", subagent_type="Technical Debt Analyst")

## Phase 2: Aggressive Legacy Removal

### Complete Frontend Demolition

```bash
# Remove entire legacy structure
@Bash(command="rm -rf src/app/modules/")
@Bash(command="rm -rf src/app/shared/")
@Bash(command="rm -rf src/legacy/")
@Bash(command="rm -rf src/styles/bootstrap/")

# Remove old dependencies
@Bash(command="npm uninstall rxjs @angular/animations zone.js")
@Bash(command="npm uninstall jquery bootstrap popper.js")

# Remove Angular modules
@Bash(command="find . -name '*.module.ts' -delete")
```

## Phase 3: Pure Signal Architecture

<think harder about implementing signals-only architecture>

### Modern Signal-Based Components

```typescript
// Pure signal component - NO observables
@Component({
    selector: 'app-feature',
    standalone: true,
    imports: [AsyncPipe],  // Remove this eventually
    template: `
        <!-- Modern control flow only -->
        @defer (on viewport) {
            <div class="feature-grid">
                @for (item of items(); track item.id) {
                    <app-feature-card 
                        [item]="item"
                        [selected]="selection().has(item.id)"
                        (toggle)="toggleSelection(item.id)"
                    />
                } @empty {
                    <app-empty-state />
                }
            </div>
        } @placeholder {
            <app-skeleton-grid />
        } @loading {
            <app-loading-indicator />
        } @error {
            <app-error-boundary [error]="$error" />
        }
        
        <!-- Modern floating UI -->
        @if (showActions()) {
            <div class="floating-actions" popover>
                <button popovertarget="actions-menu">
                    Actions ({{ selection().size }})
                </button>
            </div>
        }
    `,
    styles: [`
        @layer components {
            .feature-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(min(300px, 100%), 1fr));
                gap: var(--spacing-fluid);
                container-type: inline-size;
            }
            
            @container (width > 768px) {
                .feature-grid {
                    grid-template-columns: repeat(3, 1fr);
                }
            }
        }
    `]
})
export class FeatureComponent {
    // Pure signals - no subjects, no observables
    items = signal<Item[]>([]);
    selection = signal<Set<string>>(new Set());
    filters = signal<FilterState>({});
    
    // Computed signals
    filteredItems = computed(() => {
        const allItems = this.items();
        const activeFilters = this.filters();
        return this.applyFilters(allItems, activeFilters);
    });
    
    showActions = computed(() => this.selection().size > 0);
    
    // Resource API for data fetching
    itemsResource = resource({
        request: () => ({ filters: this.filters() }),
        loader: async ({ request }) => {
            const response = await fetch('/api/items', {
                method: 'POST',
                body: JSON.stringify(request.filters)
            });
            return response.json();
        }
    });
    
    constructor() {
        // Effects run automatically
        effect(() => {
            const data = this.itemsResource.value();
            if (data) {
                this.items.set(data);
            }
        });
        
        // Linked signals for complex state
        linkedSignal(() => {
            // Auto-sync with URL params
            const params = new URLSearchParams(window.location.search);
            return Object.fromEntries(params);
        });
    }
    
    toggleSelection(id: string) {
        this.selection.update(sel => {
            const newSel = new Set(sel);
            newSel.has(id) ? newSel.delete(id) : newSel.add(id);
            return newSel;
        });
    }
}
```

### Modern State Management

```typescript
// Signal-based store (no NgRx, no Akita)
@Injectable({ providedIn: 'root' })
export class FeatureStore {
    // State tree
    private state = signal<State>({
        items: [],
        selection: new Set(),
        filters: {},
        sorting: { field: 'name', direction: 'asc' },
        pagination: { page: 1, size: 20 }
    });
    
    // Computed projections
    items = computed(() => this.state().items);
    selection = computed(() => this.state().selection);
    selectedItems = computed(() => 
        this.items().filter(item => 
            this.selection().has(item.id)
        )
    );
    
    // Actions using signal mutations
    loadItems = action(async () => {
        const items = await this.api.getItems();
        this.state.update(s => ({ ...s, items }));
    });
    
    selectItem = action((id: string) => {
        this.state.update(s => ({
            ...s,
            selection: new Set([...s.selection, id])
        }));
    });
    
    // Middleware using effects
    constructor() {
        // Persist selection
        effect(() => {
            const selection = this.selection();
            localStorage.setItem('selection', JSON.stringify([...selection]));
        });
        
        // URL sync
        effect(() => {
            const filters = this.state().filters;
            const params = new URLSearchParams(filters);
            history.replaceState(null, '', `?${params}`);
        });
    }
}
```

## Phase 4: Modern CSS Architecture

<think harder about cutting-edge CSS>

### CSS Layers and Container Queries

```css
/* Modern CSS with layers */
@layer reset, base, components, utilities;

@layer reset {
    /* Modern reset using :where() for zero specificity */
    :where(*) {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
}

@layer base {
    :root {
        /* Modern color system */
        --color-primary: oklch(60% 0.15 250);
        --color-surface: color-mix(in oklch, var(--color-primary), white 90%);
        
        /* Fluid spacing */
        --spacing-fluid: clamp(1rem, 2vw, 2rem);
        
        /* Modern typography */
        font-family: system-ui, sans-serif;
        font-size: clamp(1rem, 2vw, 1.125rem);
    }
    
    /* Dark mode with color-scheme */
    @media (prefers-color-scheme: dark) {
        :root {
            color-scheme: dark;
            --color-primary: oklch(70% 0.15 250);
        }
    }
}

@layer components {
    /* Container queries */
    .feature-card {
        container: card / inline-size;
        
        @container card (width > 300px) {
            display: grid;
            grid-template-columns: auto 1fr;
        }
    }
    
    /* Modern selectors */
    .feature-list:has(.item:hover) .item:not(:hover) {
        opacity: 0.7;
    }
    
    /* Scroll-driven animations */
    @supports (animation-timeline: scroll()) {
        .parallax {
            animation: parallax linear;
            animation-timeline: scroll();
        }
    }
    
    /* View transitions */
    ::view-transition-old(feature),
    ::view-transition-new(feature) {
        animation-duration: 0.25s;
    }
}

@layer utilities {
    /* Logical properties */
    .spacing-inline {
        padding-inline: var(--spacing-fluid);
    }
    
    /* Modern layout */
    .masonry {
        display: grid;
        grid-template-rows: masonry;
    }
    
    /* Subgrid */
    .subgrid {
        display: grid;
        grid-template-columns: subgrid;
    }
}
```

## Phase 5: Modern Testing Approach

<think harder about next-gen testing>

### Component Testing with Signals

```typescript
describe('Modern Feature Tests', () => {
    let component: FeatureComponent;
    
    beforeEach(() => {
        TestBed.configureTestingModule({
            imports: [FeatureComponent]
        });
        
        component = TestBed.createComponent(FeatureComponent).componentInstance;
    });
    
    // Signal testing
    it('should update signals correctly', () => {
        // Test signal updates
        component.items.set([{ id: '1', name: 'Test' }]);
        expect(component.items()).toHaveLength(1);
        
        // Test computed signals
        component.selection.set(new Set(['1']));
        expect(component.showActions()).toBeTrue();
    });
    
    // Effect testing
    it('should trigger effects', fakeAsync(() => {
        const effectSpy = jasmine.createSpy();
        
        TestBed.runInInjectionContext(() => {
            effect(() => {
                component.items();
                effectSpy();
            });
        });
        
        component.items.set([]);
        tick();
        
        expect(effectSpy).toHaveBeenCalled();
    }));
    
    // Resource testing
    it('should load resources', async () => {
        await TestBed.runInInjectionContext(async () => {
            const resource = component.itemsResource;
            await resource.reload();
            expect(resource.value()).toBeDefined();
        });
    });
});
```

### Visual Testing with Playwright

```typescript
import { test, expect } from '@playwright/test';

test.describe('Modern Feature Visual Tests', () => {
    test('should match visual design', async ({ page }) => {
        await page.goto('/feature');
        
        // Wait for view transition
        await page.waitForFunction(() => 
            document.startViewTransition !== undefined
        );
        
        // Test container queries
        await page.setViewportSize({ width: 1200, height: 800 });
        await expect(page).toHaveScreenshot('desktop.png');
        
        await page.setViewportSize({ width: 375, height: 667 });
        await expect(page).toHaveScreenshot('mobile.png');
        
        // Test dark mode
        await page.emulateMedia({ colorScheme: 'dark' });
        await expect(page).toHaveScreenshot('dark-mode.png');
    });
    
    test('should handle modern interactions', async ({ page }) => {
        await page.goto('/feature');
        
        // Test popover API
        await page.click('[popovertarget]');
        await expect(page.locator('[popover]')).toBeVisible();
        
        // Test view transitions
        await page.evaluate(() => {
            document.startViewTransition(() => {
                // Transition logic
            });
        });
    });
});
```

## Phase 6: Performance Optimization

<think step-by-step about modern performance>

### Modern Performance Patterns

```typescript
// Vite config for modern build
import { defineConfig } from 'vite';
import { angular } from '@analogjs/vite-plugin-angular';

export default defineConfig({
    plugins: [angular()],
    build: {
        target: 'esnext',
        minify: 'esbuild',
        rollupOptions: {
            output: {
                manualChunks: {
                    'vendor': ['@angular/core'],
                    'features': ['./src/features']
                }
            }
        }
    },
    optimizeDeps: {
        exclude: ['@angular/platform-server']
    }
});

// Service worker for offline
self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open('v1').then((cache) => {
            return cache.addAll([
                '/',
                '/assets/app.js',
                '/assets/styles.css'
            ]);
        })
    );
});

// Web Worker for heavy computation
const worker = new Worker('/workers/compute.js', { type: 'module' });
worker.postMessage({ cmd: 'process', data: largeDataset });
```

## Phase 7: Validation Loop

<think harder about ensuring 100% modern success>

### Modern Validation Process

```typescript
async function validateModernFrontend(): Promise<ValidationResult> {
    let confidence = 0;
    let iterations = 0;
    
    while (confidence < 99) {
        iterations++;
        
        // Validate no legacy code remains
        const legacyCheck = await checkForLegacyPatterns();
        if (legacyCheck.found) {
            await removeLegacyCode(legacyCheck.files);
            continue;
        }
        
        // Run modern tests
        const tests = await Promise.all([
            runSignalTests(),
            runVisualTests(),
            runPerformanceTests(),
            runAccessibilityTests()
        ]);
        
        const failures = tests.filter(t => !t.success);
        if (failures.length > 0) {
            await fixModernIssues(failures);
            continue;
        }
        
        // Validate modern browser only
        const browserCheck = await validateBrowserSupport();
        if (!browserCheck.modernOnly) {
            await removePolyfills();
            continue;
        }
        
        confidence = calculateModernConfidence({
            legacyRemoved: !legacyCheck.found,
            testsPass: failures.length === 0,
            modernPatterns: await validateModernPatterns(),
            performance: await measurePerformance()
        });
    }
    
    return {
        success: true,
        confidence,
        iterations,
        modernScore: 100
    };
}
```

## Completion Criteria

```yaml
Modern Frontend Checklist:
  ✓ All legacy code removed
  ✓ Pure signals architecture
  ✓ Standalone components only
  ✓ Modern CSS (Grid, Layers, Container Queries)
  ✓ No RxJS/Observables
  ✓ No NgModules
  ✓ Tests: 100% passing
  ✓ Modern browsers only
  ✓ Vite build system
  ✓ No monitoring overhead
```

## Final Validation

```markdown
## Confidence Score: ≥99%

Modern Frontend Status:
- Legacy removed: 100%
- Signals only: 100%
- Modern patterns: 100%
- Test success: 100%
- Browser support: Modern only

✅ Frontend completely modernized
```

This command will NOT terminate until:
1. ALL legacy frontend code removed
2. Pure signal architecture implemented
3. 100% test success achieved
4. Modern browsers only validated
5. Confidence ≥99%
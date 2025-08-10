---
name: add-frontend-feature
description: Create modern Angular 19 UI features with signals, standalone components, and zoneless patterns
allowed-tools: [Task, Read, Write, Edit, MultiEdit, Grep, Glob, LS, TodoWrite, Bash]
argument-hint: feature description (e.g., "user dashboard with real-time updates")
think-mode: think_hard
---

# 🎨 Add Frontend Feature: $ARGUMENTS

## Quick Start
Create a production-ready Angular 19 feature using signals for state management, new control flow syntax, and standalone components with optimal performance patterns.

## 📋 Task Breakdown

Using TodoWrite to track implementation:
1. [ ] Analyze requirements and existing patterns
2. [ ] Design component architecture
3. [ ] Implement with Angular 19 patterns
4. [ ] Add tests and accessibility
5. [ ] Optimize performance

## Phase 1: Discovery & Analysis

### Detect Angular Version & Setup
```bash
ng version | grep "Angular CLI"
test -f angular.json && echo "✓ Angular project detected"
```

### Analyze Existing Patterns
Finding files matching: src/app/**/*.component.ts
Searching for pattern: signal|computed|effect|inject
Reading file: angular.json

## Phase 2: Component Architecture Design

<think_hard about component structure and state management>

### Modern Angular 19 Structure
```
src/app/features/{feature-name}/
├── {feature}.component.ts       # Standalone component
├── {feature}.component.html     # Template with new control flow
├── {feature}.component.scss     # Styles with CSS layers
├── {feature}.service.ts         # Service with inject()
├── {feature}.model.ts           # Types and interfaces
└── {feature}.component.spec.ts  # Tests
```

## Phase 3: Implementation

### Component Template (Angular 19 Control Flow)
```typescript
@Component({
  selector: 'app-{feature}',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    @if (loading()) {
      <mat-progress-spinner />
    } @else if (error()) {
      <app-error-state [error]="error()" />
    } @else {
      @for (item of items(); track item.id) {
        <app-item [data]="item" />
      } @empty {
        <app-empty-state />
      }
    }
  `
})
export class FeatureComponent {
  // Signals for reactive state
  private service = inject(FeatureService);
  
  items = signal<Item[]>([]);
  loading = signal(true);
  error = signal<Error | null>(null);
  
  // Computed values
  itemCount = computed(() => this.items().length);
  hasItems = computed(() => this.itemCount() > 0);
  
  constructor() {
    // Load data on init
    effect(() => this.loadData());
  }
  
  async loadData() {
    this.loading.set(true);
    try {
      const data = await this.service.fetchItems();
      this.items.set(data);
    } catch (err) {
      this.error.set(err as Error);
    } finally {
      this.loading.set(false);
    }
  }
}
```

### Service with Modern DI
```typescript
@Injectable({ providedIn: 'root' })
export class FeatureService {
  private http = inject(HttpClient);
  private config = inject(APP_CONFIG);
  
  fetchItems(): Promise<Item[]> {
    return firstValueFrom(
      this.http.get<Item[]>(`${this.config.apiUrl}/items`)
    );
  }
}
```

## Phase 4: Performance Optimization

### Enable Zoneless (Optional)
```typescript
// main.ts
bootstrapApplication(AppComponent, {
  providers: [
    provideExperimentalZonelessChangeDetection(),
    provideRouter(routes),
    provideHttpClient()
  ]
});
```

### Bundle Optimization
- Use standalone components (tree-shaking)
- Lazy load feature modules
- OnPush change detection
- Track functions in @for loops

## Phase 5: Testing & Accessibility

### Component Test
```typescript
describe('FeatureComponent', () => {
  it('should load and display items', async () => {
    const { fixture } = await render(FeatureComponent);
    
    // Wait for data load
    await waitFor(() => {
      expect(screen.queryByRole('progressbar')).not.toBeInTheDocument();
    });
    
    // Verify items displayed
    expect(screen.getAllByTestId('item')).toHaveLength(3);
  });
});
```

### Accessibility Checklist
- [ ] Semantic HTML structure
- [ ] ARIA labels where needed
- [ ] Keyboard navigation support
- [ ] Screen reader tested
- [ ] Color contrast WCAG 2.2 AA

## Success Criteria

✅ Component uses signals for all state
✅ New control flow syntax (@if/@for/@switch)
✅ Standalone component with imports
✅ OnPush change detection
✅ Tests passing with >80% coverage
✅ Accessibility audit passed
✅ Bundle size within budget (<50KB)
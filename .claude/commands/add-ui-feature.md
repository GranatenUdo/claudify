# ADD UI FEATURE - INTERLEAVED THINKING & BEAUTIFUL DESIGN

<think about the user experience and interface design requirements>

## ACTIVATION
You are implementing a new UI feature with beautiful, accessible design. Use interleaved thinking to create an exceptional user experience that follows the API-first workflow.

**UI Feature Request**: "$ARGUMENTS"

## Phase 1: API Verification (Critical)

<verify the backend exists before creating any UI>

### 1.1 Check API Endpoints
- What API endpoints does this feature need?
- Do these endpoints exist?
- What data do they return?
- What errors might occur?

### 1.2 API Contract Review
```typescript
// Document the API interface
interface ApiEndpoints {
  // GET /api/v1/resource
  getResource(): Observable<Resource[]>;
  
  // POST /api/v1/resource
  createResource(dto: CreateResourceDto): Observable<Resource>;
  
  // Error responses to handle
  errors: {
    400: ValidationError;
    401: UnauthorizedError;
    404: NotFoundError;
    500: ServerError;
  };
}
```

**STOP** if API doesn't exist - direct user to create it first with `/add-api-feature`

## Phase 2: Design Analysis

<think about the user's mental model and workflow>

### 2.1 User Journey
- What is the user trying to accomplish?
- What are the key interaction points?
- What feedback do they need?
- What could go wrong?

### 2.2 Design Patterns
- Mobile-first responsive design
- Material Design 3 principles
- Accessibility (WCAG 2.1 AA)
- Loading states
- Error states
- Empty states
- Success feedback

## Phase 3: Component Architecture

### 3.1 Angular Component Structure
```typescript
// Standalone component with signals
@Component({
  selector: 'app-[feature]',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MaterialModules],
  template: `...`,
  styles: [`...`],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class [Feature]Component {
  // State management with signals
  private readonly items = signal<Item[]>([]);
  private readonly loading = signal(false);
  private readonly error = signal<string | null>(null);
  
  // Public readonly signals
  readonly items$ = this.items.asReadonly();
  readonly loading$ = this.loading.asReadonly();
  readonly hasItems = computed(() => this.items().length > 0);
}
```

### 3.2 Service Layer with Signals
```typescript
@Injectable({ providedIn: 'root' })
export class [Feature]Service {
  private readonly items = signal<Item[]>([]);
  private readonly currentItem = signal<Item | null>(null);
  
  readonly items$ = this.items.asReadonly();
  readonly currentItem$ = this.currentItem.asReadonly();
  
  loadItems(): Observable<void> {
    return this.api.get<Item[]>('/api/v1/items').pipe(
      tap(items => this.items.set(items)),
      map(() => void 0),
      catchError(error => {
        console.error('Failed to load items:', error);
        return EMPTY;
      })
    );
  }
}
```

## Phase 4: UI Implementation

### 4.1 Mobile-First Template
```html
<!-- Loading state -->
<mat-progress-bar *ngIf="loading$()" mode="indeterminate"></mat-progress-bar>

<!-- Error state -->
<mat-card *ngIf="error$()" class="error-state">
  <mat-card-content>
    <mat-icon>error_outline</mat-icon>
    <p>{{ error$() }}</p>
    <button mat-button (click)="retry()">Try Again</button>
  </mat-card-content>
</mat-card>

<!-- Empty state -->
<div *ngIf="!loading$() && !hasItems()" class="empty-state">
  <img src="assets/empty-state.svg" alt="No items">
  <h2>No items yet</h2>
  <p>Create your first item to get started</p>
  <button mat-raised-button color="primary" (click)="createNew()">
    <mat-icon>add</mat-icon>
    Create Item
  </button>
</div>

<!-- Content -->
<div *ngIf="hasItems()" class="content-grid">
  <!-- Responsive grid layout -->
</div>
```

### 4.2 Responsive Styles
```scss
:host {
  display: block;
  padding: 16px;
  
  @media (min-width: 768px) {
    padding: 24px;
  }
}

.content-grid {
  display: grid;
  gap: 16px;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  
  @media (min-width: 1200px) {
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  }
}

.empty-state {
  text-align: center;
  padding: 48px 16px;
  
  img {
    max-width: 200px;
    margin-bottom: 24px;
  }
}

// Touch-friendly targets
button {
  min-height: 44px;
  min-width: 44px;
}
```

### 4.3 Form with Validation
```typescript
// Form with CommonValidators
form = this.fb.group({
  name: ['', [
    Validators.required,
    CommonValidators.noWhitespace,
    CommonValidators.minLength(3)
  ]],
  email: ['', [
    Validators.required,
    CommonValidators.email
  ], [
    CommonValidators.uniqueEmail(this.userService)
  ]],
  amount: [0, [
    Validators.required,
    CommonValidators.min(0),
    CommonValidators.max(1000000)
  ]]
});

// Async validation with debouncing built into CommonValidators
```

## Phase 5: Accessibility & UX

### 5.1 Accessibility Checklist
- [ ] Semantic HTML elements
- [ ] ARIA labels for interactive elements
- [ ] Keyboard navigation support
- [ ] Focus management
- [ ] Screen reader announcements
- [ ] Color contrast (4.5:1 minimum)
- [ ] Touch targets (44x44px minimum)

### 5.2 Progressive Enhancement
```typescript
// Optimistic updates
createItem(dto: CreateItemDto) {
  // Optimistically add to UI
  const tempItem = { ...dto, id: 'temp-' + Date.now() };
  this.items.update(items => [...items, tempItem]);
  
  // Call API
  this.api.post('/api/v1/items', dto).subscribe({
    next: (created) => {
      // Replace temp with real
      this.items.update(items => 
        items.map(item => item.id === tempItem.id ? created : item)
      );
    },
    error: (error) => {
      // Revert on failure
      this.items.update(items => 
        items.filter(item => item.id !== tempItem.id)
      );
      this.showError('Failed to create item');
    }
  });
}
```

## Phase 6: Testing

### 6.1 Component Tests
```typescript
describe('[Feature]Component', () => {
  // Test loading states
  it('should show loading indicator', () => {
    spectator.service.loading.set(true);
    spectator.detectChanges();
    expect(spectator.query('mat-progress-bar')).toExist();
  });
  
  // Test error handling
  it('should display error message', () => {
    const error = 'Network error';
    spectator.service.error.set(error);
    spectator.detectChanges();
    expect(spectator.query('.error-state')).toContainText(error);
  });
  
  // Test empty state
  it('should show empty state when no items', () => {
    spectator.service.items.set([]);
    spectator.detectChanges();
    expect(spectator.query('.empty-state')).toExist();
  });
});
```

### 6.2 Accessibility Tests
```typescript
it('should be keyboard navigable', () => {
  const firstButton = spectator.query('button');
  firstButton.focus();
  spectator.keyboard.pressTab();
  expect(document.activeElement).toBe(spectator.query('button:nth-child(2)'));
});

it('should have proper ARIA labels', () => {
  const button = spectator.query('button[aria-label]');
  expect(button.getAttribute('aria-label')).toBeTruthy();
});
```

## Phase 7: Performance Optimization

- OnPush change detection
- Lazy loading for routes
- Virtual scrolling for large lists
- Image optimization with NgOptimizedImage
- Bundle size monitoring

## Checklist
- [ ] API endpoints verified
- [ ] Mobile-first design
- [ ] All UI states handled (loading, error, empty, success)
- [ ] Forms use CommonValidators
- [ ] Accessibility standards met
- [ ] Unit tests written
- [ ] Responsive on all screen sizes
- [ ] Performance optimized
- [ ] Error handling comprehensive
- [ ] Documentation updated

## Remember
- API must exist before UI
- Mobile-first always
- Accessibility is not optional
- Test all UI states
- Use Angular signals for state
- Follow Material Design 3
- Keep components under 100 lines
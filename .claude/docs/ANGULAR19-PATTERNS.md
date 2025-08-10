# 📚 Angular 19 Patterns Reference

## 🚀 Quick Reference
Essential Angular 19 patterns for modern development. Commands should reference this document instead of including verbose inline examples.

## 📡 Signals

### Basic Signal Pattern
```typescript
// State management with signals
export class ComponentName {
  // Writable signals
  count = signal(0);
  user = signal<User | null>(null);
  items = signal<Item[]>([]);
  
  // Update patterns
  increment() {
    this.count.set(this.count() + 1);
    // or
    this.count.update(v => v + 1);
  }
  
  // Array updates
  addItem(item: Item) {
    this.items.update(items => [...items, item]);
  }
}
```

### Computed Signals
```typescript
// Derived state that auto-updates
export class CartComponent {
  items = signal<CartItem[]>([]);
  
  // Computed values
  total = computed(() => 
    this.items().reduce((sum, item) => sum + item.price, 0)
  );
  
  itemCount = computed(() => this.items().length);
  isEmpty = computed(() => this.itemCount() === 0);
  
  // Computed with complex logic
  shipping = computed(() => {
    const total = this.total();
    return total > 100 ? 0 : 10;
  });
}
```

### Effects
```typescript
export class DataComponent {
  userId = signal<string>('');
  userData = signal<User | null>(null);
  
  private userService = inject(UserService);
  
  constructor() {
    // Effect runs when dependencies change
    effect(() => {
      const id = this.userId();
      if (id) {
        this.loadUser(id);
      }
    });
    
    // Cleanup in effects
    effect((onCleanup) => {
      const timer = setTimeout(() => {
        console.log('Delayed operation');
      }, 1000);
      
      onCleanup(() => clearTimeout(timer));
    });
  }
}
```

### LinkedSignal (Experimental)
```typescript
// Signal that updates based on another signal
export class LinkedExample {
  source = signal(1);
  
  // Automatically updates when source changes
  derived = linkedSignal(() => this.source() * 2);
  
  // Can also be manually updated
  updateDerived() {
    this.derived.set(100);
  }
}
```

## 🔄 Control Flow

### @if / @else
```html
<!-- Simple conditional -->
@if (isLoggedIn()) {
  <app-dashboard />
} @else {
  <app-login />
}

<!-- Multiple conditions -->
@if (loading()) {
  <mat-spinner />
} @else if (error()) {
  <app-error [message]="error()" />
} @else if (items().length === 0) {
  <app-empty-state />
} @else {
  <app-item-list [items]="items()" />
}
```

### @for with track
```html
<!-- Always include track for performance -->
@for (item of items(); track item.id) {
  <app-item [data]="item" />
}

<!-- With index -->
@for (item of items(); track item.id; let i = $index) {
  <div>{{ i + 1 }}. {{ item.name }}</div>
}

<!-- With empty state -->
@for (item of items(); track item.id) {
  <app-item [data]="item" />
} @empty {
  <p>No items found</p>
}
```

### @switch
```html
@switch (status()) {
  @case ('loading') {
    <app-loading />
  }
  @case ('success') {
    <app-success [data]="data()" />
  }
  @case ('error') {
    <app-error [error]="error()" />
  }
  @default {
    <app-idle />
  }
}
```

### @defer (Lazy Loading)
```html
<!-- Defer loading until visible -->
@defer (on viewport) {
  <heavy-component />
} @placeholder {
  <div>Loading...</div>
} @error {
  <div>Failed to load</div>
}

<!-- Other triggers -->
@defer (on idle) { }
@defer (on immediate) { }
@defer (on timer(5s)) { }
@defer (on hover) { }
@defer (on interaction) { }
```

## 🏗️ Standalone Components

### Basic Standalone Component
```typescript
@Component({
  selector: 'app-feature',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    MatButtonModule,
    // Import what you need
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `...`
})
export class FeatureComponent {
  // Use inject() for DI
  private router = inject(Router);
  private http = inject(HttpClient);
  private dialog = inject(MatDialog);
}
```

### Service with inject()
```typescript
@Injectable({ providedIn: 'root' })
export class DataService {
  // Modern DI pattern - no constructor needed
  private http = inject(HttpClient);
  private config = inject(APP_CONFIG);
  private logger = inject(LoggerService);
  
  // Service methods
  getData(): Observable<Data[]> {
    return this.http.get<Data[]>(`${this.config.apiUrl}/data`);
  }
}
```

## ⚡ Zoneless Change Detection

### Bootstrap Configuration
```typescript
// main.ts
import { provideExperimentalZonelessChangeDetection } from '@angular/core';

bootstrapApplication(AppComponent, {
  providers: [
    provideExperimentalZonelessChangeDetection(),
    provideRouter(routes),
    provideHttpClient(),
    provideAnimations()
  ]
});
```

### Manual Change Detection (When Needed)
```typescript
export class ZonelessComponent {
  private cdr = inject(ChangeDetectorRef);
  data = signal<Data | null>(null);
  
  // Signals trigger automatically
  updateWithSignal(newData: Data) {
    this.data.set(newData); // Auto-updates view
  }
  
  // Manual trigger for non-signal updates
  updateManually(newData: Data) {
    this.legacyData = newData;
    this.cdr.markForCheck(); // Manual trigger needed
  }
}
```

## 🔌 Resource API (Experimental)

### Async Data Loading
```typescript
export class ResourceComponent {
  userId = signal<string>('');
  
  // Automatic data fetching
  userResource = resource({
    request: () => ({ id: this.userId() }),
    loader: async ({ request }) => {
      const response = await fetch(`/api/users/${request.id}`);
      return response.json();
    }
  });
  
  // Access in template
  user = this.userResource.value;
  loading = this.userResource.isLoading;
  error = this.userResource.error;
}
```

## 🧪 Testing Patterns

### Testing Signals
```typescript
it('should update computed value', () => {
  const component = new TestComponent();
  
  // Set signal value
  component.count.set(5);
  
  // Computed updates automatically
  expect(component.doubled()).toBe(10);
  
  // Update and verify
  component.count.update(v => v + 1);
  expect(component.doubled()).toBe(12);
});
```

### Testing Components with Signals
```typescript
it('should display items', async () => {
  const { fixture } = await render(ItemListComponent);
  const component = fixture.componentInstance;
  
  // Set signal data
  component.items.set([
    { id: 1, name: 'Item 1' },
    { id: 2, name: 'Item 2' }
  ]);
  
  fixture.detectChanges();
  
  // Verify rendering
  expect(screen.getAllByTestId('item')).toHaveLength(2);
});
```

## 🎯 Performance Patterns

### OnPush with Signals
```typescript
@Component({
  selector: 'app-optimized',
  changeDetection: ChangeDetectionStrategy.OnPush,
  // Signals work perfectly with OnPush
})
export class OptimizedComponent {
  data = signal<Data[]>([]);
  
  // View updates only when signal changes
  updateData(newData: Data[]) {
    this.data.set(newData);
  }
}
```

### Track Functions
```typescript
// Always provide track functions for loops
export class ListComponent {
  // Good: Track by unique property
  trackById(index: number, item: Item): number {
    return item.id;
  }
  
  // Good: Track by index for static lists
  trackByIndex(index: number): number {
    return index;
  }
}
```

## 📁 Project Structure

### Feature Module Structure
```
src/app/features/{feature-name}/
├── components/           # Feature components
├── services/            # Feature services
├── models/              # Types and interfaces
├── utils/               # Helper functions
├── {feature}.routes.ts  # Feature routes
└── index.ts            # Public API
```

### Shared Module Structure
```
src/app/shared/
├── components/          # Reusable components
├── directives/         # Custom directives
├── pipes/              # Custom pipes
├── services/           # Shared services
└── models/             # Shared types
```

## 🔗 Quick Links

- [Angular Signals Guide](https://angular.dev/guide/signals)
- [Control Flow Syntax](https://angular.dev/guide/control-flow)
- [Standalone Components](https://angular.dev/guide/standalone-components)
- [Zoneless Change Detection](https://angular.dev/guide/zoneless)

---

**Reference Version**: Angular 19.0
**Last Updated**: 2025-08-09
**Usage**: Reference this document in commands instead of inline examples
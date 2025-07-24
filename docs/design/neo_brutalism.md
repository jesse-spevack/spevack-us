# Modern UI Design System
*For Rails 8 & Tailwind CSS 4*

## Table of Contents
1. [Color Palette](#color-palette)
2. [Typography](#typography)
3. [Spacing & Layout](#spacing--layout)
4. [Components](#components)
5. [Interactive States](#interactive-states)
6. [Dark Mode](#dark-mode)
7. [Animations & Transitions](#animations--transitions)

---

## Color Palette

### Primary Colors
```css
/* Primary Theme Colors */
--background: #ffffff;
--foreground: #000000;
--primary: #ff3333;
--primary-foreground: #ffffff;
```

### Secondary & Accent Colors
```css
--secondary: #ffff00;
--secondary-foreground: #000000;
--accent: #0066ff;
--accent-foreground: #ffffff;
```

### UI Component Colors
```css
--card: #ffffff;
--card-foreground: #000000;
--popover: #ffffff;
--popover-foreground: #000000;
--muted: #f0f0f0;
--muted-foreground: #333333;
```

### Utility & Form Colors
```css
--border: #000000;
--input: #000000;
--ring: #ff3333;
```

### Status & Feedback Colors
```css
--destructive: #000000;
--destructive-foreground: #ffffff;
```

### Chart & Visualization Colors
```css
--chart-1: #ff3333;
--chart-2: #ffff00;
--chart-3: #0066ff;
--chart-4: #00cc00;
--chart-5: #cc00cc;
```

### Sidebar & Navigation Colors
```css
--sidebar-background: #f0f0f0;
--sidebar-foreground: #000000;
--sidebar-primary: #ff3333;
--sidebar-primary-foreground: #ffffff;
--sidebar-accent: #0066ff;
--sidebar-accent-foreground: #ffffff;
--sidebar-border: #000000;
--sidebar-ring: #ff3333;
```

## Typography

### Font Families
```css
/* Sans-serif */
font-family: "DM Sans", ui-sans-serif, system-ui, sans-serif;

/* Serif */
font-family: ui-serif, Georgia, Cambria, "Times New Roman", Times, serif;

/* Monospace */
font-family: "Space Mono", ui-monospace, monospace;
```

### Letter Spacing
- Default: `0em`
- Adjustable range: `-0.5em` to `0.5em`

### Text Sizes
```css
/* Headings */
.text-2xl { font-size: 1.5rem; line-height: 2rem; }
.text-xl { font-size: 1.25rem; line-height: 1.75rem; }
.text-lg { font-size: 1.125rem; line-height: 1.75rem; }

/* Body */
.text-base { font-size: 1rem; line-height: 1.5rem; }
.text-sm { font-size: 0.875rem; line-height: 1.25rem; }
.text-xs { font-size: 0.75rem; line-height: 1rem; }

/* Display */
.text-4xl { font-size: 2.25rem; line-height: 2.5rem; }
.text-3xl { font-size: 1.875rem; line-height: 2.25rem; }
```

### Font Weights
```css
.font-normal { font-weight: 400; }
.font-medium { font-weight: 500; }
.font-semibold { font-weight: 600; }
.font-bold { font-weight: 700; }
```

## Spacing & Layout

### Container Queries
```css
/* Responsive breakpoints using container queries */
@container (min-width: 320px) { /* @sm */ }
@container (min-width: 512px) { /* @xl */ }
@container (min-width: 768px) { /* @2xl */ }
@container (min-width: 1024px) { /* @3xl */ }
@container (min-width: 1280px) { /* @4xl */ }
@container (min-width: 1536px) { /* @5xl */ }
@container (min-width: 1792px) { /* @6xl */ }
@container (min-width: 2048px) { /* @7xl */ }
```

### Spacing Scale
```css
/* Consistent spacing values */
.p-0 { padding: 0; }
.p-1 { padding: 0.25rem; }
.p-2 { padding: 0.5rem; }
.p-3 { padding: 0.75rem; }
.p-4 { padding: 1rem; }
.p-6 { padding: 1.5rem; }
```

### Grid Layouts
```css
/* Common grid patterns */
.grid-cols-1
.grid-cols-2
@container (min-width: 768px) { .@2xl:grid-cols-3 }
@container (min-width: 1280px) { .@4xl:grid-cols-4 }
```

## Components

### Cards
```erb
<div class="rounded-xl border bg-card text-card-foreground shadow">
  <div class="flex flex-col space-y-1.5 p-6">
    <h3 class="font-semibold leading-none tracking-tight">Card Title</h3>
    <p class="text-sm text-muted-foreground">Card description</p>
  </div>
  <div class="p-6 pt-0">
    <!-- Card content -->
  </div>
</div>
```

### Buttons

#### Primary Button
```erb
<button class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground shadow hover:bg-primary/90 h-9 px-4 py-2">
  Button Text
</button>
```

#### Secondary Button
```erb
<button class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 bg-secondary text-secondary-foreground shadow-sm hover:bg-secondary/80 h-9 px-4 py-2">
  Button Text
</button>
```

#### Outline Button
```erb
<button class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground h-9 px-4 py-2">
  Button Text
</button>
```

#### Icon Button
```erb
<button class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 hover:bg-accent hover:text-accent-foreground size-8 p-0">
  <svg><!-- Icon --></svg>
</button>
```

### Form Elements

#### Input
```erb
<input class="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-base shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 md:text-sm">
```

#### Textarea
```erb
<textarea class="flex min-h-[60px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-base shadow-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 md:text-sm"></textarea>
```

#### Select/Combobox
```erb
<button type="button" role="combobox" class="flex h-9 items-center justify-between whitespace-nowrap rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm ring-offset-background data-[placeholder]:text-muted-foreground focus:outline-none focus:ring-1 focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50 w-full">
  <span>Select option</span>
  <svg class="h-4 w-4 opacity-50"><!-- Chevron icon --></svg>
</button>
```

#### Checkbox
```erb
<button type="button" role="checkbox" class="peer h-4 w-4 shrink-0 rounded-sm border border-primary ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground">
  <!-- Check icon when checked -->
</button>
```

#### Radio Button
```erb
<button type="button" role="radio" class="aspect-square h-4 w-4 rounded-full border border-primary text-primary ring-offset-background focus:outline-hidden focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:border-primary">
  <!-- Circle icon when checked -->
</button>
```

#### Switch/Toggle
```erb
<button type="button" role="switch" class="peer inline-flex h-6 w-11 shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent transition-colors focus-visible:outline-hidden focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary data-[state=unchecked]:bg-input">
  <span class="pointer-events-none block h-5 w-5 rounded-full bg-background shadow-lg ring-0 transition-transform data-[state=checked]:translate-x-5 data-[state=unchecked]:translate-x-0"></span>
</button>
```

### Avatars
```erb
<span class="relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full border">
  <span class="flex h-full w-full items-center justify-center rounded-full bg-muted">
    <%= user.initials %>
  </span>
</span>
```

### Badges
```erb
<span class="inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2">
  Badge
</span>
```

### Tables
```erb
<div class="rounded-md border">
  <div class="relative w-full overflow-y-auto overflow-x-hidden">
    <table class="w-full caption-bottom text-sm">
      <thead class="[&_tr]:border-b">
        <tr class="border-b transition-colors hover:bg-muted/50">
          <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Header</th>
        </tr>
      </thead>
      <tbody class="[&_tr:last-child]:border-0">
        <tr class="border-b transition-colors hover:bg-muted/50">
          <td class="p-4 align-middle">Cell</td>
        </tr>
      </tbody>
    </table>
  </div>
</div>
```

### Calendar
```erb
<div class="rdp-root p-3">
  <!-- Calendar implementation with day cells -->
  <td class="h-9 w-9 p-0 font-normal rounded-md">
    <button class="inline-flex items-center justify-center h-9 w-9 text-center text-sm hover:bg-accent hover:text-accent-foreground rounded-md">
      1
    </button>
  </td>
</div>
```

## Interactive States

### Hover States
- Buttons: `hover:bg-primary/90` or `hover:bg-accent hover:text-accent-foreground`
- Cards: `hover:bg-muted/50`
- Links: `hover:text-muted-foreground/90`

### Focus States
- All interactive elements: `focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring`
- Some elements add: `focus-visible:ring-offset-2`

### Disabled States
- All interactive elements: `disabled:pointer-events-none disabled:opacity-50`

### Selected/Active States
- Use `data-[state=selected]:bg-muted`
- Use `aria-selected:opacity-100`

## Dark Mode

The design system should support dark mode through CSS custom properties:

```css
:root {
  /* Light mode colors */
}

.dark {
  /* Dark mode color overrides */
  --background: #1a1a1a;
  --foreground: #ffffff;
  /* etc... */
}
```

## Animations & Transitions

### Default Transition
```css
.transition-colors { 
  transition-property: color, background-color, border-color;
  transition-duration: 150ms;
}
```

### Hover Animations
```css
.group-hover:scale-120 {
  transform: scale(1.2);
}
```

### Page Transitions
- Use `transition-all duration-300 ease-[cubic-bezier(0.4,0.36,0,1)]`

## Rails 8 Integration Tips

### ViewComponents
Create reusable ViewComponents for each UI element:

```ruby
# app/components/button_component.rb
class ButtonComponent < ViewComponent::Base
  def initialize(variant: :primary, size: :default, **options)
    @variant = variant
    @size = size
    @options = options
  end

  private

  def classes
    base_classes + variant_classes + size_classes
  end

  def base_classes
    "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50"
  end

  def variant_classes
    case @variant
    when :primary
      "bg-primary text-primary-foreground shadow hover:bg-primary/90"
    when :secondary
      "bg-secondary text-secondary-foreground shadow-sm hover:bg-secondary/80"
    when :outline
      "border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground"
    end
  end

  def size_classes
    case @size
    when :sm
      "h-8 rounded-md px-3 text-xs"
    when :lg
      "h-10 rounded-md px-8"
    else
      "h-9 px-4 py-2 text-sm"
    end
  end
end
```

### Stimulus Controllers
Use Stimulus for interactive components:

```javascript
// app/javascript/controllers/dropdown_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "menu"]
  
  toggle() {
    this.menuTarget.classList.toggle("hidden")
    const expanded = this.buttonTarget.getAttribute("aria-expanded") === "true"
    this.buttonTarget.setAttribute("aria-expanded", !expanded)
  }
}
```

### Tailwind Config
Configure Tailwind 4 with custom properties:

```javascript
// tailwind.config.js
export default {
  content: [
    './app/views/**/*.html.erb',
    './app/components/**/*.{rb,html.erb}',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        // ... other color definitions
      },
      fontFamily: {
        sans: ["DM Sans", "sans-serif"],
        mono: ["Space Mono", "monospace"],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ],
}
```

### CSS Architecture
Organize your styles:

```css
/* app/assets/stylesheets/application.css */
@import "tailwindcss/base";
@import "tailwindcss/components";
@import "tailwindcss/utilities";

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 0 0% 0%;
    --primary: 0 80% 60%;
    /* ... other custom properties */
  }
}

@layer components {
  /* Custom component styles */
}
```

## Accessibility

- All interactive elements must have proper ARIA labels
- Use semantic HTML elements
- Ensure proper keyboard navigation
- Maintain color contrast ratios (WCAG AA minimum)
- Include focus indicators for keyboard users
- Use `sr-only` class for screen reader only content

## Performance Considerations

- Use container queries for responsive design
- Lazy load non-critical components
- Optimize icon usage (prefer inline SVG)
- Use Turbo for page transitions
- Implement proper caching strategies

## Design Principles

1. **Clarity**: Clean, uncluttered interfaces with clear visual hierarchy
2. **Consistency**: Uniform spacing, colors, and interactions throughout
3. **Responsiveness**: Adaptive layouts using container queries
4. **Accessibility**: WCAG compliant with proper ARIA support
5. **Performance**: Fast, smooth interactions with minimal overhead
6. **Modularity**: Component-based architecture for reusability
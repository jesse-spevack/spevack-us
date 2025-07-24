# Dashboard Design System

A comprehensive design system for modern dashboard interfaces built with Tailwind CSS 4.

## Table of Contents

1. [Overview](#overview)
2. [Design Tokens](#design-tokens)
3. [Foundation](#foundation)
4. [Components](#components)
5. [Layout Patterns](#layout-patterns)
6. [Usage Guidelines](#usage-guidelines)

---

## Overview

This design system provides a cohesive set of components and patterns for building modern dashboard interfaces. It emphasizes clean typography, subtle shadows, consistent spacing, and thoughtful color usage with built-in dark mode support.

### Key Principles

- **Consistency**: Unified spacing, typography, and color usage across all components
- **Accessibility**: Proper contrast ratios, focus states, and semantic markup
- **Theming**: CSS custom properties for easy light/dark mode switching
- **Scalability**: Container queries and responsive design patterns
- **Modern**: Built with Tailwind CSS 4 and modern web standards

---

## Design Tokens

### Color System

This design system uses a **Pink/Magenta + Teal** color palette with warm, vibrant colors and CSS custom properties for theming:

#### Primary Theme Colors
```css
:root {
  /* Core Colors */
  --background: #f6e6ee;           /* Light pink background */
  --foreground: #5b5b5b;           /* Medium gray text */
  --primary: #d04f99;              /* Bright magenta/pink */
  --primary-foreground: #ffffff;    /* White text on primary */
  
  /* Secondary & Accent Colors */
  --secondary: #8acfd1;            /* Soft teal/cyan */
  --secondary-foreground: #333333;  /* Dark gray text */
  --accent: #fbe2a7;               /* Warm yellow/cream */
  --accent-foreground: #333333;     /* Dark gray text */
  
  /* UI Component Colors */
  --card: #fdedc9;                 /* Light cream/yellow card background */
  --card-foreground: #5b5b5b;      /* Medium gray text */
  --popover: #ffffff;              /* White popover background */
  --popover-foreground: #5b5b5b;   /* Medium gray text */
  --muted: #b2e1eb;                /* Light teal/cyan muted background */
  --muted-foreground: #7a7a7a;     /* Medium-light gray muted text */
  
  /* Form & Utility Colors */
  --border: #d04f99;               /* Magenta borders (same as primary) */
  --input: #e4e4e4;                /* Light gray input background */
  --ring: #e670ab;                 /* Light magenta focus ring */
  
  /* Status Colors */
  --destructive: #f96f70;          /* Coral red for destructive actions */
  --destructive-foreground: #ffffff; /* White text on destructive */
}
```

#### Chart & Visualization Colors
The system uses a cohesive 5-color palette for data visualization:
```css
:root {
  --chart-1: #e670ab;  /* Light magenta */
  --chart-2: #84d2e2;  /* Light blue/cyan */
  --chart-3: #fbe2a7;  /* Warm cream/yellow */
  --chart-4: #f3a0ca;  /* Light pink */
  --chart-5: #d7488e;  /* Medium magenta */
}
```

#### Sidebar & Navigation Colors
```css
:root {
  --sidebar-background: #f8d8ea;      /* Very light pink */
  --sidebar-foreground: #333333;       /* Dark gray */
  --sidebar-primary: #ec4899;          /* Bright magenta/pink */
  --sidebar-primary-foreground: #ffffff; /* White */
  --sidebar-accent: #f9a8d4;          /* Light pink accent */
  --sidebar-accent-foreground: #333333; /* Dark gray */
  --sidebar-border: #f3e8ff;          /* Very light purple */
  --sidebar-ring: #ec4899;            /* Bright magenta (focus) */
}
```

#### Complete Color Palette Reference

**Primary Palette (Pink/Magenta):**
- Primary: `#d04f99` - Main brand color, buttons, links
- Light variant: `#e670ab` - Hover states, focus rings
- Medium variant: `#ec4899` - Sidebar elements
- Dark variant: `#d7488e` - Chart color 5

**Secondary Palette (Teal/Cyan):**
- Secondary: `#8acfd1` - Secondary buttons, accents
- Light variant: `#b2e1eb` - Muted backgrounds
- Medium variant: `#84d2e2` - Chart color 2
- Chart variant: `#132d10` - Additional chart option

**Accent Palette (Warm Yellow/Cream):**
- Accent: `#fbe2a7` - Accent backgrounds, chart color 3
- Card variant: `#fdedc9` - Card backgrounds

**Neutral Palette:**
- Background: `#f6e6ee` - Main background (light pink tint)
- Foreground: `#5b5b5b` - Primary text
- Dark text: `#333333` - High contrast text
- Medium text: `#7a7a7a` - Muted text
- Light gray: `#e4e4e4` - Input backgrounds
- White: `#ffffff` - Cards, buttons, contrasting elements

**Status Colors:**
- Destructive: `#f96f70` - Error states, delete actions

### Typography Scale

| Class | Font Size | Line Height | Usage |
|-------|-----------|-------------|-------|
| `text-xs` | 0.75rem | 1rem | Small labels, captions |
| `text-sm` | 0.875rem | 1.25rem | Body text, descriptions |
| `text-base` | 1rem | 1.5rem | Default body text |
| `text-lg` | 1.125rem | 1.75rem | Subheadings |
| `text-xl` | 1.25rem | 1.75rem | Section titles |
| `text-2xl` | 1.5rem | 2rem | Page titles |
| `text-3xl` | 1.875rem | 2.25rem | Large numbers, KPIs |
| `text-4xl` | 2.25rem | 2.5rem | Hero numbers |

### Spacing System

Consistent spacing using Tailwind's default scale:

- **Component padding**: `p-6` (24px) for card content
- **Section spacing**: `pt-0` for removing top padding when needed  
- **Element gaps**: `gap-4` (16px) for related elements, `gap-2` (8px) for tight spacing
- **Form spacing**: `gap-3` (12px) for form field groups

### Border Radius

- **Small**: `rounded-md` (6px) for inputs, small buttons
- **Medium**: `rounded-lg` (8px) for medium components
- **Large**: `rounded-xl` (12px) for cards and containers
- **Full**: `rounded-full` for avatars and icon buttons

### Shadows

- **Card shadow**: `shadow` - Subtle elevation for cards
- **Interactive shadow**: `shadow-sm` - Light shadow for buttons and inputs

---

## Foundation

### Grid System

The layout uses CSS Container Queries for responsive design:

```html
<div class="@container">
  <div class="grid gap-4 @xl:grid-cols-2 @5xl:grid-cols-10">
    <!-- Content -->
  </div>
</div>
```

### Focus States

All interactive elements include proper focus management:

```css
focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring
```

### Disabled States

Consistent disabled styling across components:

```css
disabled:pointer-events-none disabled:opacity-50
```

---

## Components

### Cards

The foundation component for content organization.

#### Basic Card

```html
<div class="rounded-xl border bg-card text-card-foreground shadow">
  <div class="flex flex-col space-y-1.5 p-6">
    <div class="font-semibold leading-none tracking-tight">Card Title</div>
    <div class="text-sm text-muted-foreground">Card description</div>
  </div>
  <div class="p-6 pt-0">
    <!-- Card content -->
  </div>
</div>
```

#### Card with Footer

```html
<div class="rounded-xl border bg-card text-card-foreground shadow">
  <!-- Header and content -->
  <div class="flex items-center p-6 pt-0">
    <!-- Footer content -->
  </div>
</div>
```

### Buttons

Multiple button variants for different use cases.

#### Primary Button

```html
<button class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground shadow hover:bg-primary/90 h-9 px-4 py-2">
  Button Text
</button>
```

#### Secondary Button

```html
<button class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground h-9 px-4 py-2">
  Button Text
</button>
```

#### Icon Button

```html
<button class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 hover:bg-accent hover:text-accent-foreground h-9 w-9">
  <svg class="h-4 w-4"><!-- icon --></svg>
</button>
```

### Form Elements

#### Input Field

```html
<div class="flex flex-col gap-2">
  <label class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70" for="input-id">
    Label Text
  </label>
  <input class="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-base shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 md:text-sm" id="input-id" placeholder="Enter text...">
</div>
```

#### Textarea

```html
<textarea class="flex min-h-[60px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-base shadow-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 md:text-sm" placeholder="Enter description..."></textarea>
```

#### Switch

```html
<button type="button" role="switch" aria-checked="false" data-state="unchecked" class="peer inline-flex h-6 w-11 shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent transition-colors focus-visible:outline-hidden focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary data-[state=unchecked]:bg-input">
  <span data-state="unchecked" class="pointer-events-none block h-5 w-5 rounded-full bg-background shadow-lg ring-0 transition-transform data-[state=checked]:translate-x-5 data-[state=unchecked]:translate-x-0"></span>
</button>
```

### Navigation

#### Tab Navigation

```html
<div role="tablist" aria-orientation="horizontal" class="h-10 p-1 bg-background text-muted-foreground inline-flex w-fit items-center justify-center rounded-full px-0">
  <button type="button" role="tab" aria-selected="true" data-state="active" class="data-[state=active]:shadow-xs ring-offset-background focus-visible:ring-ring data-[state=active]:bg-secondary data-[state=active]:text-secondary-foreground hover:text-muted-foreground/70 inline-flex items-center justify-center rounded-full px-3 py-1 text-sm font-medium whitespace-nowrap transition-all focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:outline-none">
    Active Tab
  </button>
  <button type="button" role="tab" aria-selected="false" data-state="inactive" class="data-[state=active]:shadow-xs ring-offset-background focus-visible:ring-ring data-[state=active]:bg-secondary data-[state=active]:text-secondary-foreground hover:text-muted-foreground/70 inline-flex items-center justify-center rounded-full px-3 py-1 text-sm font-medium whitespace-nowrap transition-all focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:outline-none">
    Inactive Tab
  </button>
</div>
```

### Data Display

#### Avatar

```html
<span class="relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full border">
  <span class="flex h-full w-full items-center justify-center rounded-full bg-muted">
    U
  </span>
</span>
```

#### Badge/Status

```html
<div class="capitalize">success</div>
<div class="text-muted-foreground text-xs">Secondary text</div>
```

### Tables

#### Data Table

```html
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
          <td class="p-4 align-middle">Cell content</td>
        </tr>
      </tbody>
    </table>
  </div>
</div>
```

---

## Layout Patterns

### Dashboard Grid

The main dashboard uses a responsive grid system with container queries:

```html
<div class="@container mt-0 h-full w-full space-y-6">
  <div class="@3xl:grids-col-2 grid p-2 md:p-4 @3xl:gap-4 @5xl:grid-cols-10 @7xl:grid-cols-11">
    <div class="grid gap-4 @5xl:col-span-4 @7xl:col-span-6">
      <!-- Left column -->
    </div>
    <div class="flex flex-col gap-4 @5xl:col-span-6 @7xl:col-span-5">
      <!-- Right column -->
    </div>
  </div>
</div>
```

### Card Layouts

#### Two-Column Card Grid

```html
<div class="grid gap-4 @xl:grid-cols-2">
  <div class="rounded-xl border bg-card text-card-foreground shadow">
    <!-- Card content -->
  </div>
  <div class="rounded-xl border bg-card text-card-foreground shadow">
    <!-- Card content -->
  </div>
</div>
```

#### Responsive Column Layout

```html
<div class="grid gap-4 @2xl:grid-cols-2 @3xl:grid-cols-1 @7xl:grid-cols-2">
  <!-- Cards adapt based on container size -->
</div>
```

---

## Usage Guidelines

### Color Usage

- **Primary**: Use for main actions, selected states, and brand elements
- **Secondary**: Use for secondary actions and subtle emphasis
- **Muted**: Use for less important text and subtle backgrounds
- **Destructive**: Use sparingly for delete actions and error states

### Typography Hierarchy

1. **Page titles**: `text-2xl font-semibold tracking-tight`
2. **Section headers**: `text-xl font-semibold leading-none tracking-tight`
3. **Card titles**: `font-semibold leading-none tracking-tight`
4. **Body text**: `text-sm` (default)
5. **Captions**: `text-xs text-muted-foreground`

### Spacing Guidelines

- Use `space-y-6` for major section spacing
- Use `gap-4` for related component groups
- Use `gap-2` for tightly related elements
- Use `p-6` for card content padding
- Use `pt-0` to remove top padding when elements stack

### Interactive States

All interactive elements should include:

1. **Hover states**: Subtle background or opacity changes
2. **Focus states**: Visible focus rings for keyboard navigation
3. **Disabled states**: Reduced opacity and pointer-events-none
4. **Loading states**: Consider loading indicators for async actions

### Accessibility

- Always include proper ARIA labels and roles
- Ensure sufficient color contrast (4.5:1 for normal text)
- Provide keyboard navigation support
- Use semantic HTML elements when possible
- Include screen reader friendly text with `sr-only` class

### Best Practices

1. **Consistency**: Use the established patterns rather than creating new ones
2. **Performance**: Leverage Tailwind's utility classes for optimal CSS output
3. **Maintainability**: Use CSS custom properties for theming
4. **Responsive**: Design mobile-first with container queries for complex layouts
5. **Testing**: Test components in both light and dark modes

---

## Implementation Notes

### Tailwind Configuration

Ensure your Tailwind config includes:

```js
module.exports = {
  content: ['./src/**/*.{js,ts,jsx,tsx}'],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
        },
        // ... additional color tokens
      },
    },
  },
  plugins: [
    require('@tailwindcss/container-queries'),
  ],
}
```

### Container Queries

This design system heavily uses container queries. Ensure you have the container queries plugin installed:

```bash
npm install @tailwindcss/container-queries
```

### Dark Mode Implementation

Toggle dark mode by adding/removing the `dark` class on the root element:

```js
document.documentElement.classList.toggle('dark')
```
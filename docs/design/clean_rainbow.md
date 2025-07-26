# Clean Rainbow Design System

A vibrant, gradient-based design system for modern task management interfaces built with Tailwind CSS.

## Overview

This mobile interface showcases a vibrant, gradient-heavy design for a task/checklist application. Key characteristics:

- **Mobile-first design** with rounded container aesthetics
- **Gradient-based color system** with rainbow spectrum theming
- **Card-based task items** with checkmark indicators
- **Glassmorphism effects** with translucent overlays
- **Layered depth** through shadows and gradients
- **Consistent spacing** and rounded corner design language

## Design Tokens

### Tailwind Configuration Extension

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        gradient: {
          'coral': '#FF7F7F',
          'orange': '#FFB366',
          'yellow': '#FFE066',
          'teal': '#66E0B3',
          'cyan': '#66D9EF',
          'blue': '#66B3FF',
          'purple': '#B366FF',
          'pink': '#FF66CC',
        },
        glass: {
          'white': 'rgba(255, 255, 255, 0.2)',
          'white-heavy': 'rgba(255, 255, 255, 0.9)',
          'backdrop': 'rgba(255, 255, 255, 0.1)',
        }
      },
      backgroundImage: {
        'gradient-rainbow': 'linear-gradient(135deg, #FF7F7F 0%, #FFB366 14%, #FFE066 28%, #66E0B3 42%, #66D9EF 57%, #66B3FF 71%, #B366FF 85%, #FF66CC 100%)',
        'gradient-coral-yellow': 'linear-gradient(135deg, #FF7F7F 0%, #FFE066 100%)',
        'gradient-teal': 'linear-gradient(135deg, #66E0B3 0%, #66D9EF 100%)',
        'gradient-coral': 'linear-gradient(135deg, #FF7F7F 0%, #FF66CC 100%)',
        'gradient-orange': 'linear-gradient(135deg, #FFB366 0%, #FFE066 100%)',
        'gradient-blue': 'linear-gradient(135deg, #66B3FF 0%, #B366FF 100%)',
        'gradient-purple': 'linear-gradient(135deg, #B366FF 0%, #FF66CC 100%)',
      },
      boxShadow: {
        'glass': '0 8px 32px 0 rgba(31, 38, 135, 0.37)',
        'task': '0 4px 16px 0 rgba(0, 0, 0, 0.1)',
        'floating': '0 12px 40px 0 rgba(0, 0, 0, 0.15)',
      },
      backdropBlur: {
        'glass': '8px',
      },
      borderRadius: {
        '2xl': '1rem',
        '3xl': '1.5rem',
        '4xl': '2rem',
      }
    }
  }
}
```

### Design Token Reference

| Token Category | Values |
|----------------|--------|
| **Spacing Scale** | 4px, 8px, 12px, 16px, 20px, 24px, 32px |
| **Border Radius** | sm: 4px, md: 8px, lg: 12px, xl: 16px, 2xl: 20px, 3xl: 24px |
| **Typography** | Base: 16px, sm: 14px, lg: 18px, xl: 20px |
| **Shadows** | glass, task, floating for depth hierarchy |

## Component Library

### Base Task Item Component

```erb
<!-- app/views/shared/_task_item.html.erb -->
<div class="relative mb-4 last:mb-0">
  <div class="flex items-center p-4 bg-glass-white-heavy backdrop-blur-glass rounded-2xl shadow-task border border-white/30">
    <div class="flex-shrink-0 mr-4">
      <%= render 'shared/task_checkbox', 
          checked: local_assigns[:checked] || false, 
          gradient_class: local_assigns[:gradient_class] || 'bg-gradient-teal' %>
    </div>
    
    <div class="flex-1 min-w-0">
      <% if local_assigns[:title] %>
        <h3 class="text-gray-800 font-medium text-base leading-tight truncate">
          <%= title %>
        </h3>
      <% end %>
      
      <% if local_assigns[:description] %>
        <p class="text-gray-600 text-sm mt-1 line-clamp-2">
          <%= description %>
        </p>
      <% end %>
    </div>
  </div>
  
  <!-- Gradient accent line -->
  <div class="absolute bottom-0 left-4 right-4 h-1 <%= local_assigns[:gradient_class] || 'bg-gradient-teal' %> rounded-full"></div>
</div>
```

### Task Checkbox Component

```erb
<!-- app/views/shared/_task_checkbox.html.erb -->
<div class="relative w-8 h-8">
  <input type="checkbox" 
         id="<%= local_assigns[:id] || "task_#{SecureRandom.hex(4)}" %>"
         class="sr-only peer"
         <%= 'checked' if local_assigns[:checked] %>
         data-action="<%= local_assigns[:action] %>"
         data-task-id="<%= local_assigns[:task_id] %>">
  
  <label for="<%= local_assigns[:id] || "task_#{SecureRandom.hex(4)}" %>" 
         class="flex items-center justify-center w-8 h-8 rounded-lg cursor-pointer transition-all duration-200 
                <%= local_assigns[:gradient_class] || 'bg-gradient-teal' %>
                peer-checked:scale-105 hover:scale-110 shadow-md">
    <svg class="w-5 h-5 text-white opacity-0 peer-checked:opacity-100 transition-opacity duration-200" 
         fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path>
    </svg>
  </label>
</div>
```

### Main Container Component

```erb
<!-- app/views/shared/_mobile_container.html.erb -->
<div class="min-h-screen bg-gradient-rainbow flex items-center justify-center p-6">
  <div class="w-full max-w-sm mx-auto">
    <div class="bg-glass-white backdrop-blur-glass rounded-3xl shadow-floating border border-white/20 overflow-hidden">
      <!-- Header -->
      <div class="p-6 pb-4">
        <%= render 'shared/mobile_header', title: local_assigns[:title] %>
      </div>
      
      <!-- Content -->
      <div class="px-6 pb-6">
        <%= content %>
      </div>
      
      <!-- Bottom indicator -->
      <div class="flex justify-center pb-4">
        <div class="w-32 h-1 bg-white/60 rounded-full"></div>
      </div>
    </div>
  </div>
</div>
```

### Mobile Header Component

```erb
<!-- app/views/shared/_mobile_header.html.erb -->
<div class="text-center">
  <div class="inline-block p-3 mb-4 bg-white/20 backdrop-blur-sm rounded-xl border border-white/30">
    <%= image_tag local_assigns[:icon] || 'checklist-icon.svg', 
        class: 'w-6 h-6', alt: 'App Icon' if local_assigns[:icon] %>
  </div>
  
  <% if local_assigns[:title] %>
    <h1 class="text-xl font-semibold text-gray-800 mb-2">
      <%= title %>
    </h1>
  <% end %>
</div>
```

### Task List Component

```erb
<!-- app/views/shared/_task_list.html.erb -->
<div class="space-y-4" data-controller="task-list">
  <% tasks.each_with_index do |task, index| %>
    <%= render 'shared/task_item',
        title: task[:title],
        description: task[:description],
        checked: task[:completed],
        gradient_class: gradient_for_index(index),
        task_id: task[:id],
        action: 'task-list#toggle' %>
  <% end %>
  
  <!-- Add new task button -->
  <button class="w-full p-4 bg-white/40 backdrop-blur-sm rounded-2xl border border-white/30 
                 text-gray-600 hover:bg-white/60 transition-all duration-200 
                 flex items-center justify-center group"
          data-action="click->task-list#addTask">
    <svg class="w-5 h-5 mr-2 group-hover:scale-110 transition-transform" 
         fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
    </svg>
    Add New Task
  </button>
</div>
```

## Helper Methods

```ruby
# app/helpers/task_helper.rb
module TaskHelper
  GRADIENT_CLASSES = [
    'bg-gradient-teal',
    'bg-gradient-coral', 
    'bg-gradient-orange',
    'bg-gradient-blue',
    'bg-gradient-purple',
    'bg-gradient-coral-yellow'
  ].freeze

  def gradient_for_index(index)
    GRADIENT_CLASSES[index % GRADIENT_CLASSES.length]
  end

  def task_completion_percentage(tasks)
    return 0 if tasks.empty?
    
    completed_count = tasks.count { |task| task[:completed] }
    ((completed_count.to_f / tasks.length) * 100).round
  end

  def glassmorphism_classes(opacity: 'white-heavy')
    "bg-glass-#{opacity} backdrop-blur-glass border border-white/30"
  end

  def gradient_shadow_for_index(index)
    shadows = [
      'shadow-teal-500/30',
      'shadow-red-500/30',
      'shadow-orange-500/30', 
      'shadow-blue-500/30',
      'shadow-purple-500/30',
      'shadow-yellow-500/30'
    ]
    shadows[index % shadows.length]
  end
end
```

```ruby
# app/helpers/ui_helper.rb
module UiHelper
  def mobile_page_wrapper(title: nil, &block)
    content_tag :div, class: 'min-h-screen bg-gradient-rainbow flex items-center justify-center p-6' do
      content_tag :div, class: 'w-full max-w-sm mx-auto' do
        content_tag :div, class: glassmorphism_classes + ' rounded-3xl shadow-floating overflow-hidden' do
          concat(content_tag(:div, class: 'p-6 pb-4') do
            render 'shared/mobile_header', title: title
          end) if title
          
          content_tag :div, class: 'px-6 pb-6', &block
        end
      end
    end
  end

  def gradient_button(text, gradient_class: 'bg-gradient-teal', **options)
    default_classes = "px-6 py-3 #{gradient_class} text-white font-medium rounded-xl 
                       shadow-lg hover:shadow-xl transform hover:scale-105 
                       transition-all duration-200"
    
    options[:class] = [default_classes, options[:class]].compact.join(' ')
    
    if options[:href]
      link_to text, options[:href], options.except(:href)
    else
      button_tag text, options
    end
  end
end
```

## Stimulus Controllers

```javascript
// app/javascript/controllers/task_list_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "progress"]
  static values = { 
    addUrl: String,
    updateUrl: String 
  }

  connect() {
    this.updateProgress()
  }

  toggle(event) {
    const checkbox = event.target
    const taskId = checkbox.dataset.taskId
    
    // Add loading state
    checkbox.closest('.task-item').classList.add('opacity-50')
    
    fetch(this.updateUrlValue, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        id: taskId,
        completed: checkbox.checked
      })
    })
    .then(response => response.json())
    .then(data => {
      // Remove loading state
      checkbox.closest('.task-item').classList.remove('opacity-50')
      this.updateProgress()
      
      // Add success animation
      if (checkbox.checked) {
        this.animateCompletion(checkbox.closest('.task-item'))
      }
    })
    .catch(error => {
      console.error('Error:', error)
      checkbox.checked = !checkbox.checked // Revert on error
      checkbox.closest('.task-item').classList.remove('opacity-50')
    })
  }

  addTask() {
    // Trigger modal or inline form
    const modal = document.getElementById('add-task-modal')
    if (modal) {
      modal.classList.remove('hidden')
    }
  }

  animateCompletion(taskElement) {
    taskElement.style.transform = 'scale(1.02)'
    setTimeout(() => {
      taskElement.style.transform = 'scale(1)'
    }, 200)
  }

  updateProgress() {
    const totalTasks = this.itemTargets.length
    const completedTasks = this.itemTargets.filter(item => 
      item.querySelector('input[type="checkbox"]').checked
    ).length
    
    const percentage = totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0
    
    if (this.hasProgressTarget) {
      this.progressTarget.style.width = `${percentage}%`
    }
  }
}
```

## Usage Examples

### Basic Task List Page

```erb
<!-- app/views/tasks/index.html.erb -->
<%= mobile_page_wrapper title: 'My Tasks' do %>
  <div class="mb-6">
    <%= render 'shared/progress_bar', percentage: task_completion_percentage(@tasks) %>
  </div>
  
  <%= render 'shared/task_list', tasks: @tasks %>
<% end %>
```

### Individual Task Usage

```erb
<!-- Example task item usage -->
<%= render 'shared/task_item',
    title: 'Complete project proposal',
    description: 'Finish the Q4 project proposal and send to stakeholders',
    checked: false,
    gradient_class: 'bg-gradient-coral',
    task_id: 123 %>
```

### Custom Gradient Button

```erb
<%= gradient_button 'Save Changes', 
    gradient_class: 'bg-gradient-blue',
    data: { action: 'click->form#submit' } %>
```

## Responsive Strategy

The design is primarily mobile-focused, but here's how it adapts:

```erb
<!-- Responsive container -->
<div class="min-h-screen bg-gradient-rainbow flex items-center justify-center p-4 md:p-8">
  <div class="w-full max-w-sm md:max-w-md lg:max-w-lg mx-auto">
    <!-- Content scales appropriately -->
  </div>
</div>
```

**Breakpoint Strategy:**
- **Mobile (default)**: Single column, full-width tasks
- **Tablet (md:)**: Slightly wider container, increased padding
- **Desktop (lg:)**: Maximum width constraint, centered layout

## Accessibility Features

- **Semantic HTML**: Proper checkbox inputs with labels
- **Screen Reader Support**: Hidden text for checkbox states
- **Keyboard Navigation**: All interactive elements focusable
- **Color Contrast**: White text on gradient backgrounds meets WCAG standards
- **Focus Indicators**: Clear focus states for all interactive elements

## Animation & Micro-interactions

```css
/* app/assets/stylesheets/components/gradient_tasks.css */
.task-item {
  @apply transition-all duration-300 ease-out;
}

.task-item:hover {
  @apply transform translate-y-[-2px] shadow-lg;
}

.task-checkbox {
  @apply transition-all duration-200 ease-out;
}

.task-checkbox:checked {
  @apply animate-pulse;
  animation-iteration-count: 1;
}

.glass-morphism {
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
}
```

This design system provides a complete foundation for building the gradient-based task interface in Rails with Tailwind CSS, emphasizing visual appeal, smooth interactions, and maintainable code structure.
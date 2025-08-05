import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="timezone-setter"
export default class extends Controller {
  connect() {
    // Check if timezone cookie exists
    if (!document.cookie.includes('timezone=')) {
      const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone
      
      // Set cookie for 1 year
      document.cookie = `timezone=${timezone}; path=/; max-age=31536000; SameSite=Lax`
      
      // Reload only if we're on a page that shows dates
      if (window.location.pathname.includes('/tasks') || 
          window.location.pathname.includes('/review')) {
        window.location.reload()
      }
    }
  }
}
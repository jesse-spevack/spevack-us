import { Controller } from "@hotwired/stimulus"
import { 
  detectUserTimezone, 
  getCurrentLocalDate, 
  getLocalDateString,
  formatLocalDate,
  isLocalToday,
  isTimezoneSupported
} from "../utils/timezone_utils"

// Connects to data-controller="timezone"
export default class extends Controller {
  static targets = ["date", "time", "datetime"]
  static values = { 
    cacheKey: String,
    fallbackWarning: Boolean
  }

  connect() {
    this.initializeTimezone()
    this.convertDatesOnPage()
    
    // Listen for Turbo page loads to re-convert dates
    document.addEventListener("turbo:load", this.convertDatesOnPage.bind(this))
  }

  disconnect() {
    document.removeEventListener("turbo:load", this.convertDatesOnPage.bind(this))
  }

  /**
   * Initialize timezone detection and caching
   */
  initializeTimezone() {
    const cacheKey = this.cacheKeyValue || "chore_tracker_timezone"
    
    // Check if timezone is already cached
    let cachedTimezone = sessionStorage.getItem(cacheKey)
    
    if (!cachedTimezone || this.shouldRefreshTimezone(cacheKey)) {
      if (isTimezoneSupported()) {
        cachedTimezone = detectUserTimezone()
        this.cacheTimezone(cacheKey, cachedTimezone)
        
        // Store current date for comparison
        sessionStorage.setItem(`${cacheKey}_date`, getLocalDateString())
      } else {
        this.showFallbackWarning()
        cachedTimezone = "UTC"
      }
    }
    
    // Make timezone available to the page
    this.element.dataset.userTimezone = cachedTimezone
    this.element.dataset.localDate = getLocalDateString()
    this.element.dataset.isToday = "true" // Will be updated by specific controllers
  }

  /**
   * Cache the detected timezone with timestamp
   */
  cacheTimezone(cacheKey, timezone) {
    sessionStorage.setItem(cacheKey, timezone)
    sessionStorage.setItem(`${cacheKey}_cached_at`, Date.now().toString())
  }

  /**
   * Check if we should refresh the cached timezone
   * Refresh daily or if date has changed
   */
  shouldRefreshTimezone(cacheKey) {
    const cachedAt = sessionStorage.getItem(`${cacheKey}_cached_at`)
    const cachedDate = sessionStorage.getItem(`${cacheKey}_date`)
    const currentDate = getLocalDateString()
    
    if (!cachedAt || !cachedDate) return true
    
    // Refresh if date has changed (handles day transitions)
    if (cachedDate !== currentDate) return true
    
    // Refresh if cache is older than 24 hours
    const cacheAge = Date.now() - parseInt(cachedAt)
    return cacheAge > (24 * 60 * 60 * 1000)
  }

  /**
   * Convert all date elements on the page to local timezone
   */
  convertDatesOnPage() {
    // Convert date targets
    this.dateTargets.forEach(element => {
      this.convertDateElement(element, "date")
    })
    
    // Convert time targets  
    this.timeTargets.forEach(element => {
      this.convertDateElement(element, "time")
    })
    
    // Convert datetime targets
    this.datetimeTargets.forEach(element => {
      this.convertDateElement(element, "datetime")
    })
    
    // Convert any elements with data-utc-date attribute
    const utcElements = this.element.querySelectorAll("[data-utc-date]")
    utcElements.forEach(element => {
      const format = element.dataset.format || "date"
      this.convertDateElement(element, format)
    })
  }

  /**
   * Convert a single date element to local timezone
   */
  convertDateElement(element, format) {
    const utcDate = element.dataset.utcDate || element.textContent.trim()
    if (!utcDate) return
    
    try {
      const localFormatted = formatLocalDate(utcDate, format)
      if (localFormatted) {
        element.textContent = localFormatted
        element.setAttribute("title", `Original: ${utcDate}`)
      }
    } catch (error) {
      console.warn("Failed to convert date element:", element, error)
    }
  }

  /**
   * Get the current local date string for forms and navigation
   */
  getCurrentLocalDateString() {
    return getLocalDateString()
  }

  /**
   * Check if a date string represents "today" in local timezone
   */
  isLocallyToday(dateString) {
    return isLocalToday(dateString)
  }

  /**
   * Update navigation links to use local dates
   */
  updateDateNavigation() {
    const currentDate = new Date(this.element.dataset.currentDate || new Date())
    const localDateString = getLocalDateString(currentDate)
    
    // Update "today" button visibility
    const todayButtons = this.element.querySelectorAll("[data-today-button]")
    todayButtons.forEach(button => {
      const isToday = this.isLocallyToday(localDateString)
      button.style.display = isToday ? "none" : "block"
    })
    
    // Update previous/next day links
    const prevLinks = this.element.querySelectorAll("[data-prev-day]")
    const nextLinks = this.element.querySelectorAll("[data-next-day]")
    
    prevLinks.forEach(link => {
      const prevDate = new Date(currentDate)
      prevDate.setDate(prevDate.getDate() - 1)
      const prevDateString = getLocalDateString(prevDate)
      link.href = link.href.replace(/date=[^&]*/, `date=${prevDateString}`)
    })
    
    nextLinks.forEach(link => {
      const nextDate = new Date(currentDate)
      nextDate.setDate(nextDate.getDate() + 1)
      const nextDateString = getLocalDateString(nextDate)
      const today = getLocalDateString()
      
      // Disable future navigation beyond today
      if (nextDateString > today) {
        link.classList.add("opacity-30", "pointer-events-none")
      }
      
      link.href = link.href.replace(/date=[^&]*/, `date=${nextDateString}`)
    })
  }

  /**
   * Show warning when timezone features are not supported
   */
  showFallbackWarning() {
    if (!this.fallbackWarningValue) return
    
    console.warn("ChoreTracker: Browser timezone features not supported. Displaying UTC dates.")
    
    // Could add a visible warning banner if needed
    const warningElement = document.createElement("div")
    warningElement.className = "bg-yellow-100 border border-yellow-400 text-yellow-700 px-4 py-3 rounded mb-4"
    warningElement.innerHTML = `
      <strong>Note:</strong> Your browser doesn't support timezone detection. 
      Dates are displayed in UTC time.
    `
    
    // Insert warning at top of main content if container exists
    const mainContent = document.querySelector("main") || document.body
    mainContent.insertBefore(warningElement, mainContent.firstChild)
  }

  /**
   * Action to refresh timezone detection (for debugging)
   */
  refreshTimezone() {
    const cacheKey = this.cacheKeyValue || "chore_tracker_timezone"
    sessionStorage.removeItem(cacheKey)
    sessionStorage.removeItem(`${cacheKey}_cached_at`)
    sessionStorage.removeItem(`${cacheKey}_date`)
    
    this.initializeTimezone()
    this.convertDatesOnPage()
    
    console.log("Timezone refreshed:", this.element.dataset.userTimezone)
  }

  /**
   * Get debug information about current timezone state
   */
  getDebugInfo() {
    const cacheKey = this.cacheKeyValue || "chore_tracker_timezone"
    
    return {
      detectedTimezone: detectUserTimezone(),
      cachedTimezone: sessionStorage.getItem(cacheKey),
      localDate: getLocalDateString(),
      isSupported: isTimezoneSupported(),
      cacheAge: Date.now() - parseInt(sessionStorage.getItem(`${cacheKey}_cached_at`) || "0")
    }
  }
}
/**
 * Timezone utility functions for ChoreTracker
 * Handles browser timezone detection and date conversions
 */

/**
 * Detects the user's timezone using the Intl API
 * @returns {string} IANA timezone identifier (e.g., "America/Los_Angeles")
 */
export function detectUserTimezone() {
  try {
    return Intl.DateTimeFormat().resolvedOptions().timeZone;
  } catch (error) {
    console.warn("Timezone detection failed, falling back to UTC:", error);
    return "UTC";
  }
}

/**
 * Gets the current date in the user's local timezone
 * @returns {Date} Current date in local timezone
 */
export function getCurrentLocalDate() {
  return new Date();
}

/**
 * Converts a UTC date string to local timezone date
 * @param {string} utcDateString - UTC date string (e.g., "2025-08-05T14:30:00Z")
 * @returns {Date} Date object in local timezone
 */
export function convertUTCToLocal(utcDateString) {
  if (!utcDateString) return null;
  
  try {
    return new Date(utcDateString);
  } catch (error) {
    console.warn("Failed to convert UTC date:", utcDateString, error);
    return null;
  }
}

/**
 * Formats a date for display in local timezone
 * @param {Date|string} date - Date object or UTC string
 * @param {string} format - Format type: "date", "time", "datetime"
 * @returns {string} Formatted date string
 */
export function formatLocalDate(date, format = "date") {
  const dateObj = date instanceof Date ? date : convertUTCToLocal(date);
  if (!dateObj) return "";

  const timezone = detectUserTimezone();
  
  try {
    switch (format) {
      case "date":
        return dateObj.toLocaleDateString("en-US", {
          timeZone: timezone,
          weekday: "long",
          year: "numeric",
          month: "long",
          day: "numeric"
        });
      case "time":
        return dateObj.toLocaleTimeString("en-US", {
          timeZone: timezone,
          hour: "numeric",
          minute: "2-digit",
          hour12: true
        });
      case "datetime":
        return dateObj.toLocaleString("en-US", {
          timeZone: timezone,
          weekday: "long",
          year: "numeric", 
          month: "long",
          day: "numeric",
          hour: "numeric",
          minute: "2-digit",
          hour12: true
        });
      default:
        return dateObj.toLocaleDateString("en-US", { timeZone: timezone });
    }
  } catch (error) {
    console.warn("Date formatting failed:", error);
    return dateObj.toString();
  }
}

/**
 * Gets the local date string in YYYY-MM-DD format for a given date
 * @param {Date} date - Date object (defaults to current date)
 * @returns {string} Date string in YYYY-MM-DD format in local timezone
 */
export function getLocalDateString(date = new Date()) {
  const timezone = detectUserTimezone();
  
  try {
    // Get date components in local timezone
    const localDate = new Date(date.toLocaleString("en-CA", { timeZone: timezone }));
    return localDate.toISOString().split('T')[0];
  } catch (error) {
    console.warn("Local date string conversion failed:", error);
    // Fallback to basic date formatting
    return date.toISOString().split('T')[0];
  }
}

/**
 * Checks if a date is "today" in the user's local timezone
 * @param {Date|string} date - Date to check
 * @returns {boolean} True if the date is today in local timezone
 */
export function isLocalToday(date) {
  const today = getLocalDateString();
  const checkDate = date instanceof Date ? getLocalDateString(date) : date;
  return today === checkDate;
}

/**
 * Adds days to a date and returns the result in local timezone
 * @param {Date} date - Starting date
 * @param {number} days - Number of days to add (can be negative)
 * @returns {Date} New date with days added
 */
export function addDaysLocal(date, days) {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

/**
 * Gets the start of the week for a given date in local timezone
 * @param {Date} date - Reference date
 * @param {number} startDay - Day of week to start (0 = Sunday, 1 = Monday)
 * @returns {Date} Start of week date
 */
export function getLocalWeekStart(date, startDay = 0) {
  const result = new Date(date);
  const day = result.getDay();
  const diff = (day - startDay + 7) % 7;
  result.setDate(result.getDate() - diff);
  result.setHours(0, 0, 0, 0);
  return result;
}

/**
 * Gets the end of the week for a given date in local timezone
 * @param {Date} date - Reference date  
 * @param {number} startDay - Day of week to start (0 = Sunday, 1 = Monday)
 * @returns {Date} End of week date
 */
export function getLocalWeekEnd(date, startDay = 0) {
  const weekStart = getLocalWeekStart(date, startDay);
  const weekEnd = new Date(weekStart);
  weekEnd.setDate(weekEnd.getDate() + 6);
  weekEnd.setHours(23, 59, 59, 999);
  return weekEnd;
}

/**
 * Checks if the browser supports the required timezone features
 * @returns {boolean} True if timezone features are supported
 */
export function isTimezoneSupported() {
  try {
    return !!(Intl && Intl.DateTimeFormat && Intl.DateTimeFormat().resolvedOptions);
  } catch (error) {
    return false;
  }
}
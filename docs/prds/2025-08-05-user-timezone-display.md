# PRD: User Timezone Display

**Feature**: Display dates and times in user's browser timezone  
**Date**: 2025-08-05  
**Priority**: High  
**Status**: Ready for Development  

## 1. Vision & Story

### User Story
It's 11:30 PM Pacific Time. Jake finishes brushing his teeth and opens ChoreTracker to check off his evening tasks. Instead of seeing today's date, the app shows "tomorrow" because it's already past midnight UTC. Confused, Jake asks his parent why the app thinks it's the next day. His parent has to explain "just ignore that, it's a computer thing."

With timezone-aware display, Jake sees the correct date for his location. When he completes a task at 11:30 PM, it appears under today's tasks, not tomorrow's. The app finally matches his real-world experience.

### Value Proposition
Make ChoreTracker's dates and times match the family's actual day, eliminating confusion about "which day" tasks belong to.

### Emotional Hook
Replace "computer says it's tomorrow but it's still today" confusion with intuitive, location-aware task management.

## 2. Problem & Goals

### Problem Statement
ChoreTracker currently displays all dates and times in UTC, causing confusion when users are in different timezones. Children see "tomorrow's" tasks when it's late evening, and task completions appear on the "wrong" day from their perspective.

**Impact**: 
- User confusion about which day tasks belong to
- Parent explanations needed for basic app navigation
- Reduced confidence in app accuracy

### Success Metrics
- Zero user reports of "wrong day" confusion
- Task completions appear on expected day 100% of the time
- No performance degradation in date calculations

### Primary Goals
1. Display all user-facing dates in browser's local timezone
2. Maintain UTC storage for data consistency
3. Ensure "today" matches user's actual day

## 3. User Stories & Experience

### Primary User Stories
**As a child user, I want to see today's tasks on the correct day so I know which tasks to complete now.**

**As a parent user, I want weekly reviews to show the correct week boundaries so I can accurately track my child's progress.**

### User Flows
1. **Daily Task View**
   - User opens app at any time of day
   - App detects browser timezone automatically
   - "Today" button shows current date in user's timezone
   - Task completion timestamps display in local time
   - Date navigation (previous/next day) uses local dates

2. **Task Completion**
   - Child completes task at 11:30 PM local time
   - App saves completion with current UTC timestamp to database
   - Task appears as completed on today's date (local timezone)
   - Weekly review includes completion on correct local day

### Acceptance Criteria
- When user opens app, "today" matches their calendar date
- Task completions made before midnight local time appear on current local date
- Date navigation buttons increment/decrement local dates
- Weekly review boundaries align with local week start/end
- No timezone selection UI needed (automatic detection)

## 4. Functional Requirements

### Core Features
1. **Automatic Timezone Detection**: Use JavaScript's `Intl.DateTimeFormat().resolvedOptions().timeZone` to detect browser timezone
2. **Date Display Conversion**: Convert all UTC dates to local timezone for display
3. **Local Date Boundaries**: Calculate "today", "yesterday", "tomorrow" based on local timezone
4. **Task Completion Logic**: Save UTC timestamp but display completion on correct local date
5. **Weekly Review Alignment**: Use local timezone for week start/end calculations

### Business Logic
- **Task Due Date**: Task is "due today" if current local date matches task's due date
- **Completion Display**: Task completion shows on the local date when it was completed
- **Date Navigation**: Previous/next day buttons use local date arithmetic
- **Week Boundaries**: Weekly reviews start on local Sunday/Monday (configurable)

### Technical Integration
- **Frontend**: JavaScript timezone detection and date conversion
- **Backend**: Continue storing all timestamps in UTC
- **Database**: No schema changes required
- **Views**: Update ERB templates to use timezone-aware helpers

### Performance & Security
- **Performance**: Timezone conversion happens client-side, no additional server requests
- **Caching**: Local timezone cached in browser session
- **Fallback**: If timezone detection fails, default to UTC display with warning

## 5. Scope & Boundaries

### In Scope
- Browser-based automatic timezone detection
- Convert display of dates and times to local timezone
- Maintain UTC storage in database
- Update task completion display logic
- Adjust weekly review date boundaries
- Date navigation using local dates

### Out of Scope
- User-configurable timezone settings
- Historical timezone changes
- Multi-timezone family support
- Server-side timezone processing
- Timezone abbreviation display (PST, EST, etc.)
- Time zone selection UI

### Future Considerations
- Manual timezone override for edge cases
- Timezone display in tooltips/debugging
- Multi-location family support
- Travel mode timezone switching

### Dependencies
- Modern browser with Intl API support
- JavaScript enabled on client side
- Existing date handling in Rails views

## 6. Success Validation

### Launch Criteria
- All date displays show in user's local timezone
- Task completions appear on correct local date
- Date navigation works with local dates
- Weekly reviews use local week boundaries
- No breaking changes to existing functionality
- Cross-browser testing completed (Chrome, Safari, Firefox)

### Risk Assessment
**Technical Risks:**
- Browser compatibility with Intl API (mitigation: fallback to UTC)
- Daylight Saving Time edge cases (mitigation: use browser's built-in handling)
- Client-server date synchronization issues (mitigation: clear UTC storage contract)

**Business Risks:**
- User confusion during timezone transitions (mitigation: consistent local date display)
- Performance impact of frequent date conversions (mitigation: client-side caching)

### Open Questions
- Should we show timezone abbreviation anywhere for clarity?
- How to handle users who disable JavaScript?
- Any special handling needed for Daylight Saving Time transitions?
- Should date picker inputs also use local timezone?

## Implementation Notes

### Key Files to Modify
- Views: Date display templates
- JavaScript: Timezone detection and conversion utilities
- Helpers: Date formatting helpers
- Controllers: Date parameter parsing

### Technical Approach
1. Add JavaScript timezone utilities
2. Update view helpers for timezone-aware display
3. Modify date navigation to use local dates
4. Test across timezone boundaries and DST transitions
5. Ensure UTC storage remains unchanged
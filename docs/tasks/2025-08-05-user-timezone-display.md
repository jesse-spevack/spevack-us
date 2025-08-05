# Task List: User Timezone Display

**Generated**: 2025-08-05  
**Based on PRD**: 2025-08-05-user-timezone-display.md  
**Estimated Total**: 3-4 days

## Architecture Overview

The timezone feature converts UTC-stored data to user's local timezone for display only. JavaScript detects browser timezone and handles all client-side conversions. Rails backend continues storing UTC timestamps unchanged. Key flow: browser detects timezone → JavaScript utilities convert dates for display → ERB templates show local dates → form submissions still save UTC to database.

## File Planning

### New Files
- `app/javascript/controllers/timezone_controller.js` - Stimulus controller for timezone detection and date conversion
- `app/javascript/utils/timezone_utils.js` - Utility functions for date conversion and local date calculations  
- `test/javascript/timezone_utils.test.js` - Unit tests for timezone utilities (if JS testing set up)
- `app/helpers/timezone_helper.rb` - Rails helper methods for timezone-aware date formatting

### Modified Files  
- `app/controllers/application_controller.rb` - Update set_date to handle local timezone dates
- `app/controllers/tasks_controller.rb` - Update @is_today logic for local timezone
- `app/views/tasks/index.html.erb` - Add timezone detection and update date displays
- `app/views/tasks/_tasks_frame.html.erb` - Update task completion timestamp displays
- `app/views/reviews/show.html.erb` - Update weekly review date boundaries

## Implementation Tasks

### Phase 1: Foundation (P0)
- [x] **1.1** Create timezone detection JavaScript utility `Simple`
  - **Dependencies**: None
  - **Files**: `app/javascript/utils/timezone_utils.js`
  - **Testing**: Manual testing across different timezone browsers
  - **Details**: Implement `detectUserTimezone()`, `getCurrentLocalDate()`, `convertUTCToLocal()`

- [x] **1.2** Create Stimulus controller for timezone management `Simple`
  - **Dependencies**: None
  - **Files**: `app/javascript/controllers/timezone_controller.js`
  - **Testing**: Verify timezone caching in sessionStorage
  - **Details**: Cache detected timezone, provide data attributes for templates

### Phase 2: Backend Date Logic (P1)  
- [x] **2.1** Update ApplicationController date parsing for local timezone `Medium`
  - **Dependencies**: Requires 1.1, 1.2
  - **Files**: `app/controllers/application_controller.rb`
  - **Testing**: Unit tests for date parameter parsing with timezone
  - **Details**: Parse date params as local dates, convert to UTC for database queries

- [x] **2.2** Create Rails helper for timezone-aware formatting `Simple`
  - **Dependencies**: None
  - **Files**: `app/helpers/timezone_helper.rb`
  - **Testing**: Unit tests for helper methods
  - **Details**: Methods for formatting UTC dates as local, calculating local "today"

- [x] **2.3** Update TasksController "today" logic `Simple`
  - **Dependencies**: Requires 2.1, 2.2
  - **Files**: `app/controllers/tasks_controller.rb`
  - **Testing**: Test @is_today calculation across timezone boundaries
  - **Details**: Use local timezone for "today" comparison instead of server timezone

### Phase 3: View Updates (P1)
- [ ] **3.1** Update tasks index view with timezone controller `Medium`
  - **Dependencies**: Requires 1.2, 2.2
  - **Parallel with**: 3.2, 3.3
  - **Files**: `app/views/tasks/index.html.erb`
  - **Testing**: Manual testing of date display and navigation
  - **Details**: Add timezone data attributes, update date formatting, fix navigation links

- [ ] **3.2** Update tasks frame for completion timestamps `Simple`
  - **Dependencies**: Requires 1.1, 2.2
  - **Parallel with**: 3.1, 3.3
  - **Files**: `app/views/tasks/_tasks_frame.html.erb`
  - **Testing**: Test task completion display in local timezone
  - **Details**: Show completion times in local timezone, ensure completion appears on correct local date

- [ ] **3.3** Update weekly review for local week boundaries `Medium`
  - **Dependencies**: Requires 2.1, 2.2
  - **Parallel with**: 3.1, 3.2
  - **Files**: `app/views/reviews/show.html.erb`
  - **Testing**: Test week boundary calculations across timezones
  - **Details**: Calculate week start/end in local timezone, update date range displays

### Phase 4: Integration & Testing (P1-P2)
- [ ] **4.1** Implement browser compatibility fallbacks `Simple`
  - **Dependencies**: Requires 1.1
  - **Files**: `app/javascript/utils/timezone_utils.js`
  - **Testing**: Test on older browsers, IE compatibility if needed
  - **Details**: Fallback to UTC display with warning if Intl API unavailable

- [ ] **4.2** Add client-side timezone caching `Simple`
  - **Dependencies**: Requires 1.2
  - **Files**: `app/javascript/controllers/timezone_controller.js`
  - **Testing**: Verify timezone persists across page loads
  - **Details**: Cache timezone in sessionStorage, refresh detection periodically

- [ ] **4.3** Cross-timezone integration testing `Complex`
  - **Dependencies**: Requires 3.1-3.3
  - **Files**: Various test files
  - **Testing**: Manual testing across PST, EST, UTC, international timezones
  - **Details**: Test task completion, date navigation, weekly reviews across timezones

### Phase 5: Edge Cases & Polish (P2-P3)
- [ ] **5.1** Handle Daylight Saving Time transitions `Medium`
  - **Dependencies**: Requires 4.3
  - **Files**: `app/javascript/utils/timezone_utils.js`
  - **Testing**: Test during DST transition dates (March/November)
  - **Details**: Verify date calculations work correctly during time changes

- [ ] **5.2** Add debugging support for timezone issues `Simple`
  - **Dependencies**: Requires 1.1
  - **Files**: `app/javascript/utils/timezone_utils.js`
  - **Testing**: Verify debug info displays correctly
  - **Details**: Console logging for timezone detection, optional timezone display in UI

- [ ] **5.3** Performance optimization for date conversions `Simple`
  - **Dependencies**: Requires 4.2
  - **Files**: `app/javascript/utils/timezone_utils.js`
  - **Testing**: Performance testing with many dates
  - **Details**: Cache converted dates, optimize repeated calculations

## Relevant Files

### Created Files
- `app/javascript/utils/timezone_utils.js` - JavaScript utilities for timezone detection and date conversion
- `app/javascript/controllers/timezone_controller.js` - Stimulus controller for managing timezone detection and caching
- `app/helpers/timezone_helper.rb` - Rails helper methods for timezone-aware date formatting

### Modified Files
- `docs/tasks/2025-08-05-user-timezone-display.md` - Updated task completion status
- `app/controllers/application_controller.rb` - Added timezone-aware date parsing and helper methods
- `app/controllers/tasks_controller.rb` - Included TimezoneHelper module

## Development Notes

### Testing Strategy
- **Manual Testing**: Primary focus - test across different browser timezones using developer tools
- **Unit Tests**: Focus on JavaScript utilities and Rails helpers
- **Integration Tests**: Critical user journeys from PRD - task completion flow, date navigation
- **Cross-browser**: Test Chrome, Safari, Firefox timezone detection

### Key Technical Decisions
- **JavaScript-first approach**: All timezone conversion happens in browser to avoid server complexity
- **UTC storage preserved**: Database schema unchanged, maintains data integrity
- **Session-based caching**: Timezone cached per browser session, not permanently stored
- **Graceful degradation**: Falls back to UTC display if JavaScript/Intl API unavailable

### Rails-Specific Considerations
- **Date parameter parsing**: Need to handle dates as local timezone, convert for DB queries
- **Helper method pattern**: Use Rails helpers for consistent date formatting across views
- **Stimulus integration**: Leverage existing Stimulus framework for timezone management
- **Turbo compatibility**: Ensure timezone detection works with Turbo page loads

### Critical User Journeys to Test
1. **Evening task completion**: Complete task at 11:30 PM local → should appear on today's date
2. **Date navigation**: Previous/next day buttons should use local dates
3. **Weekly review**: Week boundaries should align with local Sunday/Monday
4. **Cross-day usage**: App used across midnight local time boundary
5. **DST transitions**: Usage during spring forward / fall back weekends

### Performance Considerations
- Client-side conversion has minimal performance impact
- Cache timezone detection result to avoid repeated API calls
- Batch date conversions when displaying multiple timestamps
- Monitor for any impact on page load times

### Browser Compatibility
- **Required**: Modern browsers with Intl API (Chrome 24+, Firefox 29+, Safari 10+)
- **Fallback**: Display UTC dates with timezone warning for unsupported browsers
- **Testing**: Verify behavior when JavaScript disabled
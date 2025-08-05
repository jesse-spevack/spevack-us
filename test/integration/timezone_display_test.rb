require "test_helper"

class TimezoneDisplayTest < ActionDispatch::IntegrationTest
  def setup
    @child = children(:eddie)
    post session_path, params: { id: @child.id }
  end

  test "timezone setter controller is present on pages" do
    get tasks_path
    assert_response :success
    assert_match /data-controller.*timezone-setter/, response.body
  end

  test "date navigation works with timezone" do
    # Set timezone cookie to PST
    cookies[:timezone] = "America/Los_Angeles"
    
    get tasks_path
    assert_response :success
    
    # Should have navigation links
    assert_select 'a[href*="date="]', minimum: 2
  end

  test "weekly review respects timezone" do
    cookies[:timezone] = "America/New_York"
    
    get review_path
    assert_response :success
    
    # Should show week range
    assert_match /\w+ \d+ - \d+, \d{4}/, response.body
  end

  test "date parameter parsing handles timezone dates" do
    cookies[:timezone] = "America/Chicago"
    
    get tasks_path(date: "2025-08-05")
    assert_response :success
    
    # Should show the formatted date
    assert_match /August/, response.body
  end
end

require "test_helper"

class TimezoneDisplayTest < ActionDispatch::IntegrationTest
  def setup
    @child = children(:eddie)
    post session_path, params: { id: @child.id }
  end

  test "tasks page includes timezone controller" do
    get tasks_path
    assert_response :success
    # Check that timezone support attributes exist
    assert_match /data-controller/, response.body
    assert_match /timezone/, response.body
    assert_match /data-timezone-cache-key-value/, response.body
  end

  test "date navigation uses proper date format" do
    get tasks_path
    assert_response :success
    assert_select "[data-prev-day]"
    assert_select "[data-next-day]"
  end

  test "weekly review includes timezone support" do
    get review_path
    assert_response :success
    assert_match /data-controller/, response.body
    assert_match /timezone/, response.body
    assert_match /data-week-start/, response.body
  end

  test "date parameter parsing handles timezone dates" do
    get tasks_path(date: "2025-08-05")
    assert_response :success
    assert_select '[data-current-date="2025-08-05"]'
  end
end

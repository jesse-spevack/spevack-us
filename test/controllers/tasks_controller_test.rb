require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  def setup
    # Select a child for tests that require child authentication
    post session_path, params: { id: children(:eddie).id }
  end

  def test_index_shows_tasks_for_current_date
    get tasks_path
    assert_response :success
    assert_select "h2", /#{Date.current.strftime("%A, %B %d")}/
  end

  def test_index_shows_tasks_for_specific_date
    date = Date.current - 3.days
    get tasks_path(date: date)
    assert_response :success
    assert_select "h2", /#{date.strftime("%A, %B %d")}/
  end

  def test_today_button_not_shown_on_current_date
    get tasks_path
    assert_response :success
    assert_select "a", text: "Today", count: 0
  end

  def test_today_button_shown_on_past_date
    get tasks_path(date: Date.current - 1.day)
    assert_response :success
    assert_select "a[href=?]", tasks_path, text: "Today"
  end

  def test_forward_navigation_hidden_on_current_date
    get tasks_path
    assert_response :success
    # Check that the forward arrow has visibility: hidden style
    assert_select "a", text: "→" do |elements|
      assert elements.first["style"].include?("visibility: hidden")
    end
  end

  def test_forward_navigation_visible_on_past_date
    get tasks_path(date: Date.current - 1.day)
    assert_response :success
    # Check that the forward arrow does not have visibility: hidden style
    assert_select "a", text: "→" do |elements|
      assert_not elements.first["style"].include?("visibility: hidden")
    end
  end
end

class TasksControllerRedirectTest < ActionDispatch::IntegrationTest
  def test_redirects_to_new_session_when_no_child_selected
    get tasks_path
    assert_redirected_to new_session_path
  end
end

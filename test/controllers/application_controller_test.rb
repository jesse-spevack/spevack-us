require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  def setup
    # Select a child for tests that require child authentication
    post select_child_path(children(:eddie))
  end

  def test_set_date_with_date_param
    get tasks_path(date: "2025-01-15")
    assert_response :success
  end

  def test_set_date_without_date_param
    get tasks_path
    assert_response :success
  end
end

class ApplicationControllerRedirectTest < ActionDispatch::IntegrationTest
  def test_redirects_to_children_when_no_child_selected
    # Test without setting a child cookie first
    get tasks_path
    assert_redirected_to children_path
  end
end

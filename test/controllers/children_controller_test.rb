require "test_helper"

class ChildrenControllerTest < ActionDispatch::IntegrationTest
  def test_index_shows_all_children
    get children_path
    assert_response :success
    assert_includes response.body, "Eddie"
    assert_includes response.body, "Audrey"
  end

  def test_index_redirects_to_tasks_when_child_already_selected
    post select_child_path(children(:eddie))
    get children_path
    assert_redirected_to tasks_path
  end

  def test_select_sets_cookie_and_redirects
    post select_child_path(children(:eddie))
    assert_redirected_to tasks_path
    assert_equal children(:eddie).id.to_s, cookies[:child_id]
  end
end

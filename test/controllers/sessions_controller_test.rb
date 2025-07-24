require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def test_new_shows_all_children
    get new_session_path
    assert_response :success
    assert_includes response.body, "Eddie"
    assert_includes response.body, "Audrey"
  end

  def test_new_redirects_to_root_when_child_already_selected
    post session_path, params: { id: children(:eddie).id }
    get new_session_path
    assert_redirected_to root_path
  end

  def test_create_sets_session_and_redirects
    post session_path, params: { id: children(:eddie).id }
    assert_redirected_to root_path
    assert_equal children(:eddie).id, session[:child_id]
  end

  def test_destroy_clears_session_and_redirects
    post session_path, params: { id: children(:eddie).id }
    delete session_path
    assert_redirected_to new_session_path
    assert_nil session[:child_id]
  end
end

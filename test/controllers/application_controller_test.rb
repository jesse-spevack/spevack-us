require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  def test_set_date_with_date_param
    get tasks_path(date: "2025-01-15")
    assert_response :success
  end

  def test_set_date_without_date_param
    get tasks_path
    assert_response :success
  end
end

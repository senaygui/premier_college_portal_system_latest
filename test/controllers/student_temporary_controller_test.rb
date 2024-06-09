require "test_helper"

class StudentTemporaryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get student_temporary_index_url
    assert_response :success
  end
end

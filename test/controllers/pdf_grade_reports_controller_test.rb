require "test_helper"

class PdfGradeReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pdf_grade_reports_index_url
    assert_response :success
  end
end

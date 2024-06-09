require 'test_helper'

class GradeReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @grade_report = grade_reports(:one)
  end

  test "should get index" do
    get grade_reports_url
    assert_response :success
  end

  test "should get new" do
    get new_grade_report_url
    assert_response :success
  end

  test "should create grade_report" do
    assert_difference('GradeReport.count') do
      post grade_reports_url, params: { grade_report: { index: @grade_report.index, show: @grade_report.show } }
    end

    assert_redirected_to grade_report_url(GradeReport.last)
  end

  test "should show grade_report" do
    get grade_report_url(@grade_report)
    assert_response :success
  end

  test "should get edit" do
    get edit_grade_report_url(@grade_report)
    assert_response :success
  end

  test "should update grade_report" do
    patch grade_report_url(@grade_report), params: { grade_report: { index: @grade_report.index, show: @grade_report.show } }
    assert_redirected_to grade_report_url(@grade_report)
  end

  test "should destroy grade_report" do
    assert_difference('GradeReport.count', -1) do
      delete grade_report_url(@grade_report)
    end

    assert_redirected_to grade_reports_url
  end
end

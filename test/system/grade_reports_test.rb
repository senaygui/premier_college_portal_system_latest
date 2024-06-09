require "application_system_test_case"

class GradeReportsTest < ApplicationSystemTestCase
  setup do
    @grade_report = grade_reports(:one)
  end

  test "visiting the index" do
    visit grade_reports_url
    assert_selector "h1", text: "Grade Reports"
  end

  test "creating a Grade report" do
    visit grade_reports_url
    click_on "New Grade Report"

    fill_in "Index", with: @grade_report.index
    fill_in "Show", with: @grade_report.show
    click_on "Create Grade report"

    assert_text "Grade report was successfully created"
    click_on "Back"
  end

  test "updating a Grade report" do
    visit grade_reports_url
    click_on "Edit", match: :first

    fill_in "Index", with: @grade_report.index
    fill_in "Show", with: @grade_report.show
    click_on "Update Grade report"

    assert_text "Grade report was successfully updated"
    click_on "Back"
  end

  test "destroying a Grade report" do
    visit grade_reports_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Grade report was successfully destroyed"
  end
end

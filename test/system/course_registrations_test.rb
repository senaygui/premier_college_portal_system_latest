require "application_system_test_case"

class CourseRegistrationsTest < ApplicationSystemTestCase
  setup do
    @course_registration = course_registrations(:one)
  end

  test "visiting the index" do
    visit course_registrations_url
    assert_selector "h1", text: "Course Registrations"
  end

  test "creating a Course registration" do
    visit course_registrations_url
    click_on "New Course Registration"

    click_on "Create Course registration"

    assert_text "Course registration was successfully created"
    click_on "Back"
  end

  test "updating a Course registration" do
    visit course_registrations_url
    click_on "Edit", match: :first

    click_on "Update Course registration"

    assert_text "Course registration was successfully updated"
    click_on "Back"
  end

  test "destroying a Course registration" do
    visit course_registrations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Course registration was successfully destroyed"
  end
end

require "application_system_test_case"

class StudentRegistrationsTest < ApplicationSystemTestCase
  setup do
    @student_registration = student_registrations(:one)
  end

  test "visiting the index" do
    visit student_registrations_url
    assert_selector "h1", text: "Student Registrations"
  end

  test "creating a Student registration" do
    visit student_registrations_url
    click_on "New Student Registration"

    click_on "Create Student registration"

    assert_text "Student registration was successfully created"
    click_on "Back"
  end

  test "updating a Student registration" do
    visit student_registrations_url
    click_on "Edit", match: :first

    click_on "Update Student registration"

    assert_text "Student registration was successfully updated"
    click_on "Back"
  end

  test "destroying a Student registration" do
    visit student_registrations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Student registration was successfully destroyed"
  end
end

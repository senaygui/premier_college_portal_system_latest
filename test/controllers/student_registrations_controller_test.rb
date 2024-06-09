require 'test_helper'

class StudentRegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student_registration = student_registrations(:one)
  end

  test "should get index" do
    get student_registrations_url
    assert_response :success
  end

  test "should get new" do
    get new_student_registration_url
    assert_response :success
  end

  test "should create student_registration" do
    assert_difference('StudentRegistration.count') do
      post student_registrations_url, params: { student_registration: {  } }
    end

    assert_redirected_to student_registration_url(StudentRegistration.last)
  end

  test "should show student_registration" do
    get student_registration_url(@student_registration)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_registration_url(@student_registration)
    assert_response :success
  end

  test "should update student_registration" do
    patch student_registration_url(@student_registration), params: { student_registration: {  } }
    assert_redirected_to student_registration_url(@student_registration)
  end

  test "should destroy student_registration" do
    assert_difference('StudentRegistration.count', -1) do
      delete student_registration_url(@student_registration)
    end

    assert_redirected_to student_registrations_url
  end
end

require 'test_helper'

class AcademicCalendarsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get academic_calendars_show_url
    assert_response :success
  end

  test "should get index" do
    get academic_calendars_index_url
    assert_response :success
  end

end

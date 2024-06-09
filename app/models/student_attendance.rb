class StudentAttendance < ApplicationRecord
  belongs_to :session
  belongs_to :student
  belongs_to :course_registration
end

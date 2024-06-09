class Session < ApplicationRecord
	after_create :add_student_attendance
  before_save :attribute_assignment
	
  belongs_to :attendance
  belongs_to :course, optional: true
  belongs_to :academic_calendar, optional: true

  # belongs_to :academic_calendar
  has_many :student_attendances
  accepts_nested_attributes_for :student_attendances, reject_if: :all_blank, allow_destroy: true

  # def attribute_assignment
  #   # self[:program_id] = self.course_section.course_breakdown.curriculum.program.id
  #   self[:academic_calendar_id] = self.attendance.academic_calendar.id
  #   # self[:course_breakdown_id] = self.course_section.course_breakdown.id
  #   # self[:course_title] = self.course_section.course_breakdown.course_title
  # end

  private
    def add_student_attendance
      self.attendance.section.course_registrations.where(academic_calendar_id: attendance.academic_calendar.id, course_id: self.course).each do |co|
        StudentAttendance.create do |item|
          item.course_registration_id = self.id
          item.session_id = self.id
          item.student_id = co.student_id
          item.student_full_name = co.student_full_name
          item.course_registration_id = co.id
          item.created_by = self.attendance.created_by
        end
      end
    end
    def attribute_assignment
      self[:course_id] = self.attendance.course.id
      self[:academic_calendar_id] = self.attendance.academic_calendar.id
      self[:year] = self.attendance.year
      self[:semester] = self.attendance.semester
    end
  end

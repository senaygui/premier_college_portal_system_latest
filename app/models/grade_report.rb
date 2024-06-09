class GradeReport < ApplicationRecord

	##validations
  	validates :admission_type, :presence => true
		validates :study_level, :presence => true
		validates :total_course, :presence => true
		validates :total_credit_hour, :presence => true
		validates :total_grade_point, :presence => true
		validates :cumulative_total_credit_hour, :presence => true
		validates :cumulative_total_grade_point, :presence => true
		validates :cgpa, :presence => true
		validates :sgpa, :presence => true
		validates :semester, :presence => true
		validates :year, :presence => true
		validates :academic_status, :presence => true
  ##associations
 	  belongs_to :department
	  belongs_to :semester_registration
	  belongs_to :student
	  belongs_to :academic_calendar
	  belongs_to :program
	  belongs_to :section, optional: true
	  def self.get_gc_students(graduation_status, year, semester, study_level, admission_type)
		student_ids = Student.where(graduation_status: graduation_status).where(study_level: study_level).where(admission_type: admission_type).select(:id)
		self.where(student: student_ids).where(year: year).where(semester: semester).includes(:student).includes(:department).includes(:grade_report)
	  end
end

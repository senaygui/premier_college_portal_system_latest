class StudentCourse < ApplicationRecord
	##associations
  	belongs_to :student
  	belongs_to :course
	##valdation
		validates :course_title, :presence => true
		validates :semester, :presence => true
		validates :year, :presence => true
		validates :credit_hour, :presence => true
		validates :ects, :presence => true
		validates :course_code, :presence => true
end
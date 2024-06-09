class SchoolOrUniversityInformation < ApplicationRecord
  ##associations
  	belongs_to :student

  ##validations
  # 	validates :college_or_university, :presence => true, if: :apply_graduate?
		# validates :phone_number, :presence => true, if: :apply_graduate?
		# validates :address, :presence => true, if: :apply_graduate?
		# validates :field_of_specialization, :presence => true, if: :apply_graduate?
  #validates :cgpa, :presence => true, if: :apply_graduate?
  #validates :last_attended_high_school, format: { with: /\A[a-zA-Z]+\z/, message: "Only letters are allowed" }
  #validates :grade_10_result, format: { with: /\A[1-9]\d*\z/, message: "Only positive numbers are allowed" }
  #validates :grade_12_exam_result, format: { with: /\A[1-9]\d*\z/, message: "Only positive numbers are allowed" }
		# def apply_graduate?
		# 	if self.student.present?
  #   		self.student.study_level == "graduate" 
  #   	end
  # 	end
end
class GradeSystem < ApplicationRecord

	##validations
  	validates :min_cgpa_value_to_pass , :presence => true
  	validates :min_cgpa_value_to_graduate , :presence => true
  ##associations
	  belongs_to :program
	  belongs_to :curriculum
	  has_many :grades, dependent: :destroy
	  has_many :academic_statuses, dependent: :destroy
		accepts_nested_attributes_for :grades, reject_if: :all_blank, allow_destroy: true
		accepts_nested_attributes_for :academic_statuses, reject_if: :all_blank, allow_destroy: true
end

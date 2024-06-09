class Transfer < ApplicationRecord
	##validations
		validates :semester, presence: true
		validates :year, presence: true
	##assocations
	  belongs_to :student
	  belongs_to :program
	  belongs_to :section
	  belongs_to :department
	  belongs_to :academic_calendar
	  has_many :course_exemptions, as: :exemptible, dependent: :destroy
	  accepts_nested_attributes_for :course_exemptions, reject_if: :all_blank, allow_destroy: true
end

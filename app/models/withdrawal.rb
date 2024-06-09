class Withdrawal < ApplicationRecord

	##validation
		validates :semester, :presence => true
		validates :year, :presence => true
		validates :fee_status, :presence => true
		validates :reason_for_withdrawal, :presence => true
		validates :last_class_attended, :presence => true
  ##assocations
	  belongs_to :program
	  belongs_to :department
	  belongs_to :student
	  belongs_to :section
	  belongs_to :academic_calendar
end

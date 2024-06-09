class Activity < ApplicationRecord
	##validations
	  validates :activity, :presence => true
		validates :semester, :presence => true
		validates :category, :presence => true
		validates :starting_date, :presence => true
		validates :ending_date, :presence => true
	##associations
  	belongs_to :academic_calendar
end

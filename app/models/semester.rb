class Semester < ApplicationRecord
	##associations
  	belongs_to :academic_calendar

  ##validations
  	validates :semester, :presence => true
		validates :starting_date, :presence => true
		validates :ending_date, :presence => true
end

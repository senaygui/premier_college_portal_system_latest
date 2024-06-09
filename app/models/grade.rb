class Grade < ApplicationRecord
	##validations
  	validates :letter_grade , :presence => true
  	validates :grade_point , :presence => true
  	validates :min_row_mark , :presence => true
  	validates :max_row_mark , :presence => true
	belongs_to :grade_system
end

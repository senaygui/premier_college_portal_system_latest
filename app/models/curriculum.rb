class Curriculum < ApplicationRecord

	##validations
    validates :curriculum_title, :presence => true
		validates :curriculum_version, :presence => true, uniqueness: true
		validates :curriculum_active_date, :presence => true
	##associations
	  belongs_to :program
	  has_many :courses, dependent: :destroy
	  has_one :grade_system, dependent: :destroy
	  
	  accepts_nested_attributes_for :courses, reject_if: :all_blank, allow_destroy: true
end

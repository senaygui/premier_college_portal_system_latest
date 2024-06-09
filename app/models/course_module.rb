class CourseModule < ApplicationRecord
  #validations
    validates :module_title, :presence => true,:length => { :within => 2..140 }
    validates :module_code, :presence => true,:length => { :within => 2..50 }

  ##associations
  	belongs_to :department
  	has_many :courses, dependent: :destroy
  ##scope
  	scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}
end

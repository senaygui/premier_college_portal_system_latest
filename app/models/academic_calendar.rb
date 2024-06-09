class AcademicCalendar < ApplicationRecord
	##validations
    validates :calender_year_in_gc, :presence => true
    validates :calender_year_in_ec, :presence => true
	  validates :calender_year, :presence => true
		validates :starting_date, :presence => true
		validates :ending_date, :presence => true
		validates :admission_type, :presence => true
		validates :study_level, :presence => true

	##scope
  	scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}
  	scope :undergraduate, lambda { where(study_level: "undergraduate")}
  	scope :graduate, lambda { where(study_level: "graduate")}
  	scope :online, lambda { where(admission_type: "online")}
  	scope :regular, lambda { where(admission_type: "regular")}
  	scope :extention, lambda { where(admission_type: "extention")}
  	scope :distance, lambda { where(admission_type: "distance")}

  	
	##associations
    has_many :students
  	has_many :activities, dependent: :destroy
    accepts_nested_attributes_for :activities, reject_if: :all_blank, allow_destroy: true
    has_many :semesters, dependent: :destroy
    accepts_nested_attributes_for :semesters, reject_if: :all_blank, allow_destroy: true
    has_many :semester_registrations
    has_many :course_registrations
    has_many :invoices
    has_many :attendances
    has_many :course_instructors
    has_many :grade_reports
    has_many :grade_changes
    has_many :sessions
    has_many :withdrawals
    has_many :recurring_payments
    has_many :add_and_drops
    has_many :makeup_exams
end

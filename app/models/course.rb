class Course < ApplicationRecord
	before_save :attribute_assignment
	
	#validations
        validates :semester, :presence => true
		validates :year, :presence => true
		validates :credit_hour, :presence => true
		validates :lecture_hour, :presence => true
		validates :ects, :presence => true
		validates :course_code, :presence => true
		# validates :student_grades, presence: true
  ##associations
  	belongs_to :course_module
  	belongs_to :curriculum
  	belongs_to :program, optional: true
 		# has_many :programs, through: :curriculums, dependent: :destroy
 	has_many :student_grades, dependent: :destroy

 	has_many :student_courses, dependent: :destroy
 		has_many :assessments
	  has_many :course_registrations, dependent: :destroy
	  has_many :invoice_items
	  # has_many :course_sections, dependent: :destroy
	  has_many :attendances, dependent: :destroy
	  has_many :assessment_plans, dependent: :destroy
		has_one_attached :course_outline, dependent: :destroy
		accepts_nested_attributes_for :assessment_plans, reject_if: :all_blank, allow_destroy: true


		has_many :course_instructors
		accepts_nested_attributes_for :course_instructors, reject_if: :all_blank, allow_destroy: true

		has_many :sessions

		has_many :grade_changes
		has_many :makeup_exams
		has_many :add_and_drop_courses
		has_many :course_prerequisites, class_name: "Prerequisite"
  	has_many :prerequisites, through: :course_prerequisites, source: :prerequisite
  	accepts_nested_attributes_for :course_prerequisites, reject_if: :all_blank, allow_destroy: true

  	has_many :course_exemptions
  ##scope
  	scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}
  	scope :instructor_courses, -> (user_id) {CourseInstructor.where(admin_user_id: user_id).pluck(:course_id)}


  private

  def attribute_assignment
    self[:program_id] = self.curriculum.program.id
  end
end

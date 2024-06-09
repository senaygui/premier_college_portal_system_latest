class CourseSection < ApplicationRecord
	before_save :course_title_assign

	##validations
    validates :section_short_name, :presence => true
		validates :section_full_name, :presence => true, uniqueness: true
		
	##associations
    # has_many :grade_changes
  	belongs_to :course
  	has_many :course_registrations
  	has_many :attendances, dependent: :destroy

  ##scope
    scope :instructor_courses, -> (user_id) {CourseInstructor.where(admin_user_id: user_id).pluck(:course_section_id)}
    scope :instructors, -> (user_id) {CourseInstructor.where(course_section_id: instructor_courses(user_id)).pluck(:course_id)}
  private

  def course_title_assign
  	self[:course_title] = self.course.course_title
    self[:section_full_name] = "#{self.section_short_name} - #{self.course_title}"
    self[:program_name] = self.course.program.program_name
  end
end

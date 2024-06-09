class AddAndDropCourse < ApplicationRecord
	after_save :drop_course_from_course_registration
	# after_save :add_course_to_course_registration
	##validations
		validates :add_or_drop, :presence => true
	##associations
	  belongs_to :add_and_drop
	  belongs_to :course

	private

	def drop_course_from_course_registration
		if (self.advisor_approval == "approved") && (self.add_and_drop.registrar_approval == "approved") && (self.add_or_drop == "Drop Course") && (self.add_and_drop.semester_registration.course_registrations.where(course_id: self.course.id).present?)
			drop = self.add_and_drop.semester_registration.course_registrations.where(course_id: self.course.id).first
			drop.destroy
		end
	end
end

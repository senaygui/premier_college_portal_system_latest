class AddAndDrop < ApplicationRecord
	after_save :department_assignment
	after_save :assign_semester_registration
	after_save :attributes_assignment
	after_save :generate_invoice_for_add_course


	##validations
  	validates :semester, :presence => true
  	validates :year, :presence => true
	##associations
	  belongs_to :student
	  belongs_to :academic_calendar
	  belongs_to :semester_registration, optional: true
	  belongs_to :department, optional: true
	  belongs_to :program
	  belongs_to :section
	  has_many :add_and_drop_courses, dependent: :destroy
	  accepts_nested_attributes_for :add_and_drop_courses, reject_if: :all_blank, allow_destroy: true
	  has_one :other_payment, as: :payable, dependent: :destroy
	##scope
		scope :recently_added, lambda {where('created_at >= ?', 1.week.ago)}
    scope :pending, lambda { where(advisor_approval: "pending")}
    scope :approved, lambda { where(advisor_approval: "approved")}
    scope :denied, lambda { where(advisor_approval: "denied")}
    scope :registrar_pending, lambda { where(registrar_approval: "pending")}
    scope :registrar_approved, lambda { where(registrar_approval: "approved")}
    scope :registrar_denied, lambda { where(registrar_approval: "denied")}
	
	def department_assignment
		self.update_columns(department_id: self.program.department.id)
  end
  def assign_semester_registration
  	semester = self.student.semester_registrations.order("created_at ASC").last.id
  	self.update_columns(semester_registration_id: semester)
  end

  def attributes_assignment
	  student_full_name = "#{self.student.first_name.upcase} #{self.student.middle_name.upcase} #{self.student.last_name.upcase}"
	  self.update_columns(student_full_name: student_full_name)
		student_id_number = self.student.student_id
		self.update_columns(student_id_number: student_id_number)
  end
	private 

	def generate_invoice_for_add_course
		if (self.advisor_approval == "approved") && (self.registrar_approval == "approved") && (self.add_and_drop_courses.where( add_or_drop: "Add Course").present?) && (!self.other_payment.present?)
			OtherPayment.create do |invoice|
				invoice.student_id = self.student.id
				invoice.academic_calendar_id = self.academic_calendar_id
				invoice.semester_registration_id = self.semester_registration.id
				invoice.department_id = self.department_id
				invoice.program_id = self.program_id
				invoice.section_id = self.section_id
				invoice.payable_type = "AddAndDrop"
				invoice.payment_type = "Add Course"
				invoice.payable_id = self.id
				invoice.year = self.year
				invoice.semester = self.semester
				invoice.student_id_number = self.student_id_number
				invoice.student_full_name = self.student_full_name
				invoice.created_by = "system"
				invoice.due_date = Time.now + 10.day
				invoice.invoice_status = "unpaid"
				invoice.invoice_number = SecureRandom.random_number(10000000)
				invoice.total_price =  (self.add_and_drop_courses.collect { |oi| oi.valid? ? (CollegePayment.where(study_level: self.student.study_level,admission_type: self.student.admission_type).first.add_drop) : 0 }.sum)      
			end
		end
	end
	
end

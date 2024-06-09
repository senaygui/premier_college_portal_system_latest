class OtherPayment < ApplicationRecord
  after_create :add_invoice_item_for_add_and_drop
  after_save :add_and_drop_update_status

  after_create :add_invoice_item_for_makeup_exam
  

  ##validations
    validates :invoice_number , :presence => true
    validates :semester, :presence => true
		validates :year, :presence => true
	##scope
		scope :recently_added, lambda {where('created_at >= ?', 1.week.ago)}
		scope :pending, lambda { where(invoice_status: "pending")}
    scope :approved, lambda { where(invoice_status: "approved")}
    scope :denied, lambda { where(invoice_status: "denied")}
    scope :incomplete, lambda { where(invoice_status: "incomplete")}
    scope :unpaid, lambda { where(invoice_status: "unpaid")}
    scope :due_date_passed, lambda { where("due_date < ?", Time.now)}
	##associations
	  belongs_to :student
	  belongs_to :academic_calendar
	  belongs_to :semester_registration, optional: true
	  belongs_to :department, optional: true
	  belongs_to :program, optional: true
	  belongs_to :section, optional: true
	  belongs_to :payable, polymorphic: true
	  has_many :invoice_items, as: :itemable, dependent: :destroy
	  has_one :payment_transaction, as: :invoiceable, dependent: :destroy
	  accepts_nested_attributes_for :payment_transaction, reject_if: :all_blank, allow_destroy: true



	  private

	  def add_invoice_item_for_makeup_exam
  		if self.payable_type == "MakeupExam"
				InvoiceItem.create do |invoice_item|
						invoice_item.itemable_id = self.id
						invoice_item.itemable_type = "OtherPayment"
						invoice_item.course_id = self.payable.course_id
						invoice_item.course_registration_id = self.payable.course_registration_id
						invoice_item.created_by = self.created_by
						invoice_item.item_title = "#{self.payable.course.course_title} Makeup Exam"
						invoice_item.price = CollegePayment.where(study_level: self.student.study_level,admission_type: self.student.admission_type).first.makeup_exam_fee	
				end
			end
		end

  	def add_invoice_item_for_add_and_drop
  		if self.payable_type == "AddAndDrop"
				self.payable.add_and_drop_courses.where(add_or_drop: "Add Course").each do |add|
					InvoiceItem.create do |invoice_item|
						invoice_item.itemable_id = self.id
						invoice_item.itemable_type = "OtherPayment"
						invoice_item.course_id = add.course.id
						invoice_item.created_by = self.created_by
						invoice_item.item_title = add.course.course_title
						invoice_item.price = CollegePayment.where(study_level: self.student.study_level,admission_type: self.student.admission_type).first.add_drop	
					end
				end
			end
		end

		def add_and_drop_update_status
			if (self.payable_type == "AddAndDrop") && (self.payment_transaction.present?) && (self.payment_transaction.finance_approval_status == "approved") && (self.invoice_status == "approved") && (self.payable.status == "pending")
				self.payable.add_and_drop_courses.where(add_or_drop: "Add Course").each do |add|
					CourseRegistration.create do |course_registration|
		  			course_registration.semester_registration_id = self.semester_registration.id
		  			course_registration.program_id = self.program.id
		  			course_registration.department_id = self.department.id
		  			course_registration.academic_calendar_id = self.academic_calendar_id
		  			course_registration.student_id = self.student_id
		  			course_registration.student_full_name = self.student_full_name
		  			course_registration.course_id = add.course_id
		  			course_registration.course_title = add.course.course_title
		  			course_registration.semester = self.semester
						course_registration.year = self.year
						course_registration.enrollment_status = "enrolled"
		  			# course_registration.course_section_id = CourseSection.first.id
		  			course_registration.created_by = self.payable.registrar_name
				  end
				end

				self.payable.update_columns(status: "approved")

    	end
		end
end

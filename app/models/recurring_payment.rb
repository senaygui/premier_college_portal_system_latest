class RecurringPayment < ApplicationRecord
	after_create :add_invoice_item
	after_save :update_status
	##validations
    validates :invoice_number , :presence => true
    # validates :semester, :presence => true
		# validates :year, :presence => true
	##scope
		scope :recently_added, lambda {where('created_at >= ?', 1.week.ago)}
		scope :pending, lambda { where(invoice_status: "pending")}
    scope :approved, lambda { where(invoice_status: "approved")}
    scope :denied, lambda { where(invoice_status: "denied")}
    scope :incomplete, lambda { where(invoice_status: "incomplete")}
    scope :unpaid, lambda { where(invoice_status: "unpaid")}
    scope :due_date_passed, lambda { where("due_date < ?", Time.now)}
	##associations
	  belongs_to :semester_registration
	  belongs_to :student
	  belongs_to :academic_calendar
	  belongs_to :department
	  belongs_to :program
	  belongs_to :section
	  has_many :invoice_items, as: :itemable, dependent: :destroy
	  has_one :payment_transaction, as: :invoiceable, dependent: :destroy
	  accepts_nested_attributes_for :payment_transaction, reject_if: :all_blank, allow_destroy: true


	  private

  	def add_invoice_item
			self.semester_registration.course_registrations.each do |course|
				InvoiceItem.create do |invoice_item|
					invoice_item.itemable_id = self.id
					invoice_item.itemable_type = "RecurringPayment"
					invoice_item.course_registration_id = course.id
					invoice_item.created_by = self.created_by
					if self.semester_registration.mode_of_payment == "Monthly Payment"
						course_price =  CollegePayment.where(study_level: self.semester_registration.study_level,admission_type: self.semester_registration.admission_type).first.tution_per_credit_hr * course.course.credit_hour / 4
						invoice_item.price = course_price
					elsif self.semester_registration.mode_of_payment == "Full Semester Payment"
						course_price =  CollegePayment.where(study_level: self.semester_registration.study_level,admission_type: self.semester_registration.admission_type).first.tution_per_credit_hr * course.course.credit_hour
						invoice_item.price = course_price
					elsif self.semester_registration.mode_of_payment == "Half Semester Payment"
						course_price =  CollegePayment.where(study_level: self.semester_registration.study_level,admission_type: self.semester_registration.admission_type).first.tution_per_credit_hr * course.course.credit_hour / 2
						invoice_item.price = course_price
					end
					
				end
			end
		end

		def update_status
			if (self.payment_transaction.present?) && (self.payment_transaction.finance_approval_status == "approved") && (self.invoice_status == "approved")

      	if (self.semester_registration.remaining_amount >= self.total_price) && (self.payment_transaction.last_updated_by.nil?)
      		current_remaining_amount = (self.semester_registration.remaining_amount - self.total_price).abs
      		self.semester_registration.update_columns(remaining_amount: current_remaining_amount)
      		total_enrolled_course = self.semester_registration.course_registrations.count
      		self.semester_registration.update_columns(total_enrolled_course: total_enrolled_course)
      	end
    	end
		end
end

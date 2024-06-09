class Invoice < ApplicationRecord
  after_create :add_invoice_item
  after_save :update_status
  validates :invoice_number, :presence => true
  validates :semester, :presence => true
  validates :year, :presence => true
  belongs_to :semester_registration
  belongs_to :student
  belongs_to :academic_calendar
  belongs_to :program
  belongs_to :department
  has_one :payment_transaction, as: :invoiceable, dependent: :destroy
  accepts_nested_attributes_for :payment_transaction, reject_if: :all_blank, allow_destroy: true
  has_many :invoice_items, as: :itemable, dependent: :destroy

  scope :recently_added, lambda { where("created_at >= ?", 1.week.ago) }
  scope :unpaid, lambda { where(invoice_status: "unpaid") }
  scope :pending, lambda { where(invoice_status: "pending") }
  scope :approved, lambda { where(invoice_status: "approved") }
  scope :denied, lambda { where(invoice_status: "denied") }
  scope :incomplete, lambda { where(invoice_status: "incomplete") }
  scope :due_date_passed, lambda { where("due_date < ?", Time.now) }

  private

  def add_invoice_item
    self.semester_registration.course_registrations.each do |course|
      InvoiceItem.create do |invoice_item|
        invoice_item.itemable_id = self.id
        invoice_item.itemable_type = "Invoice"
        invoice_item.course_registration_id = course.id
        invoice_item.course_id = course.course.id
        invoice_item.created_by = self.created_by
        if self.semester_registration.mode_of_payment == "Monthly Payment"
          course_price = self.student.get_tution_fee / 4
          invoice_item.price = course_price
        elsif self.semester_registration.mode_of_payment == "Full Semester Payment"
          course_price = self.student.get_tution_fee
          invoice_item.price = course_price
        elsif self.semester_registration.mode_of_payment == "Half Semester Payment"
          course_price = self.student.get_tution_fee / 2
          invoice_item.price = course_price
        end
      end
    end
  end

  def update_status
    if (self.payment_transaction.present?) && (self.payment_transaction.finance_approval_status == "approved") && (self.invoice_status == "approved")
      self.semester_registration.update_columns(finance_approval_status: "approved", is_back_invoice_created: false)
      if self.semester_registration.total_price == 0
        tution_price = self.student.get_tution_fee + self.registration_fee + self.late_registration_fee
        remaining_amount = (tution_price - (self.total_price + self.registration_fee)).abs
        total_enrolled_course = self.student.get_current_courses.size
        self.semester_registration.update_columns(total_enrolled_course: total_enrolled_course, remaining_amount: remaining_amount, late_registration_fee: self.late_registration_fee, registration_fee: self.registration_fee, total_price: tution_price, actual_payment: self.total_price)
      else
        remaining_amount = self.semester_registration.remaining_amount
        new_remaining_amount = remaining_amount - self.total_price
        self.semester_registration.update_columns(remaining_amount: new_remaining_amount, is_back_invoice_created: false)
      end
    end
  end
end

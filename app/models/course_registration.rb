class CourseRegistration < ApplicationRecord
  # after_create :add_invoice_item
  after_save :add_grade
  after_save :attribute_assignment
  ##associations
  belongs_to :semester_registration
  belongs_to :department
  belongs_to :course
  has_many :invoice_items
  has_one :student_grade, dependent: :destroy
  belongs_to :student
  belongs_to :academic_calendar
  belongs_to :program
  # belongs_to :course_section, optional: true
  belongs_to :section, optional: true
  has_many :student_attendances, dependent: :destroy
  has_many :grade_changes, dependent: :destroy
  has_many :makeup_exams
  # validates_associated :student_grades

  def get_academic_year
    "#{self.academic_year}/#{self.academic_year + 1}"
  end
  def self.get_course_per_student(student_ids)
    self.where(student_id: student_ids).includes(:student).includes(:course).includes(:student_grade)
  end
  def add_grade
    if self.section.present? && !self.student_grade.present?
      StudentGrade.create do |student_grade|
        student_grade.course_registration_id = self.id
        student_grade.student_id = self.student.id
        student_grade.course_id = self.course.id
        student_grade.department_id = self.department.id
        student_grade.program_id = self.program.id
        student_grade.created_by = self.updated_by
      end
    end
  end

  private

  # def add_invoice_item
  # 	if (self.semester_registration.semester == 1) && (self.semester_registration.year == 1) && self.semester_registration.mode_of_payment.present? && self.semester_registration.invoices.last.nil?
  # 		InvoiceItem.create do |invoice_item|
  # 			invoice_item.invoice_id = self.semester_registration.invoice.id
  # 			invoice_item.course_registration_id = self.id

  # 			if self.semester_registration.mode_of_payment == "monthly"
  # 				course_price =  CollegePayment.where(study_level: self.study_level,admission_type: self.admission_type).first.tution_per_credit_hr * self.curriculum.credit_hour / 4
  # 			elsif self.semester_registration.mode_of_payment == "full"
  # 				course_price =  CollegePayment.where(study_level: self.study_level,admission_type: self.admission_type).first.tution_per_credit_hr * self.curriculum.credit_hour
  # 			elsif self.semester_registration.mode_of_payment == "half"
  # 				course_price =  CollegePayment.where(study_level: self.study_level,admission_type: self.admission_type).first.tution_per_credit_hr * self.curriculum.credit_hour / 2
  # 			end
  # 			invoice_item.price = course_price
  # 		end
  # 	end
  # end
  def attribute_assignment
    if !self.section.present? && self.semester_registration.section.present?
      self[:section_id] = self.semester_registration.section.id
    end
  end
end

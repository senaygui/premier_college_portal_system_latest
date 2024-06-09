class SemesterRegistration < ApplicationRecord
  after_save :change_course_registration_status
  after_save :assign_section_to_course_registration
  after_commit :semester_course_registration, on: :create
  after_save :generate_invoice
  after_save :add_admission_date
  scope :recently_added, lambda { where("created_at >= ?", 1.week.ago) }
  scope :undergraduate, lambda { where(study_level: "undergraduate") }
  scope :graduate, lambda { where(study_level: "graduate") }
  scope :online, lambda { where(admission_type: "online") }
  scope :regular, lambda { where(admission_type: "regular") }
  scope :extention, lambda { where(admission_type: "extention") }
  scope :distance, lambda { where(admission_type: "distance") }
  ##associations
  belongs_to :student
  belongs_to :program
  belongs_to :department
  belongs_to :section, optional: true
  belongs_to :academic_calendar
  has_many :course_registrations, dependent: :destroy
  has_many :courses, through: :course_registrations, dependent: :destroy
  accepts_nested_attributes_for :course_registrations, reject_if: :all_blank, allow_destroy: true
  has_many :invoices, dependent: :destroy
  has_one :grade_report, dependent: :destroy
  has_many :recurring_payments, dependent: :destroy
  has_many :add_and_drops, dependent: :destroy

  def self.fetch_student_semester_registrations(id)
    self.where(department_id: id, is_back_invoice_created: false).where("remaining_amount=?", 0.0).includes(:department).includes(:student)
  end


  def generate_grade_report
    if !self.grade_report.present?
      GradeReport.create do |report|
        report.semester_registration_id = self.id
        report.student_id = self.student.id
        report.academic_calendar_id = self.academic_calendar.id
        report.program_id = self.program.id
        report.department_id = self.program.department.id
        # grade_report.section_id = self.section.id
        report.admission_type = self.student.admission_type
        report.study_level = self.student.study_level
        report.semester = self.student.semester
        report.year = self.student.year
        # grade_report.total_course = self.course_registrations.where(enrollment_status: "enrolled").count
        # I recommend the official Stimulus.js handbook (https://stimulus.hotwired.dev/handbook/introduction) to anyone who wants to learn the basics of Stimulus.js for Rails. In addition to this (https://dev.to/bhumi/stimulus-rails-7-tutorial-5a6a) is also a great article to learn details about stimulus js.
        if self.student.grade_reports.empty?
          report.total_course = self.course_registrations.count
          report.total_credit_hour = self.course_registrations.where(enrollment_status: "enrolled").collect { |oi| ((oi.student_grade.letter_grade != "I") && (oi.student_grade.letter_grade != "NG")) ? (oi.course.credit_hour) : 0 }.sum
          report.total_grade_point = self.course_registrations.where(enrollment_status: "enrolled").collect { |oi| ((oi.student_grade.letter_grade != "I") && (oi.student_grade.letter_grade != "NG")) ? (oi.student_grade.grade_point) : 0 }.sum
          report.sgpa = report.total_credit_hour == 0 ? 0 : (report.total_grade_point / report.total_credit_hour).round(1)

          report.cumulative_total_credit_hour = report.total_credit_hour
          report.cumulative_total_grade_point = report.total_grade_point
          report.cgpa = report.cumulative_total_credit_hour == 0 ? 0 : (report.cumulative_total_grade_point / report.cumulative_total_credit_hour).round(1)

          if ((self.course_registrations.joins(:student_grade).pluck(:letter_grade).include?("I")) || (self.course_registrations.joins(:student_grade).pluck(:letter_grade).include?("NG")))
            report.academic_status = "Incomplete"
          else
            if self.student.study_level == "undergraduate"
              report.academic_status = AddAcademicStatus.academic_status({ sgpa: report.sgpa, cgpa: report.cgpa }, self.student)
            else
              report.academic_status = AcademicStatusGraduate.get_academic_status(report: report, student: self.student)
              # report.academic_status = self.student.program.grade_systems.last.academic_statuses.where("min_value < ?", report.cgpa).where("max_value >= ?", report.cgpa).last.status
            end

            if (report.academic_status.strip != "Academic Dismissal") || (report.academic_status.strip != "Incomplete")
              if self.program.program_semester > self.student.semester
                promoted_semester = self.student.semester + 1
                self.student.update_columns(semester: promoted_semester)
              elsif (self.program.program_semester == self.student.semester) && (self.program.program_duration > self.student.year)
                promoted_year = self.student.year + 1
                self.student.update_columns(semester: 1)
                self.student.update_columns(year: promoted_year)
              end
            end
          end
        elsif self.student.grade_reports.present?
          report.total_course = self.course_registrations.count
          report.total_credit_hour = self.course_registrations.collect { |oi| ((oi.student_grade.letter_grade != "I") && (oi.student_grade.letter_grade != "NG")) ? (oi.course.credit_hour) : 0 }.sum
          report.total_grade_point = self.course_registrations.collect { |oi| ((oi.student_grade.letter_grade != "I") && (oi.student_grade.letter_grade != "NG")) ? (oi.course.credit_hour * oi.student_grade.grade_point) : 0 }.sum
          report.sgpa = report.total_credit_hour == 0 ? 0 : (report.total_grade_point / report.total_credit_hour).round(1)
          report.cumulative_total_credit_hour = self.student.grade_reports.order("created_at DESC").first.cumulative_total_credit_hour + report.total_credit_hour
          report.cumulative_total_grade_point = self.student.grade_reports.order("created_at DESC").first.cumulative_total_grade_point + report.total_grade_point
          report.cgpa = report.cumulative_total_grade_point / report.cumulative_total_credit_hour
          if ((self.course_registrations.joins(:student_grade).pluck(:letter_grade).include?("I")) || (self.course_registrations.joins(:student_grade).pluck(:letter_grade).include?("NG")))
            report.academic_status = "Incomplete"
          else
            if self.student.study_level == "undergraduate"
              report.academic_status = AddAcademicStatus.academic_status({ sgpa: report.sgpa, cgpa: report.cgpa }, self.student)
            else
              report.academic_status = AcademicStatusGraduate.get_academic_status(report: report, student: self.student)
              # report.academic_status = self.student.program.grade_systems.last.academic_statuses.where("min_value <= ?", report.cgpa).where("max_value >= ?", report.cgpa).last.status
            end
            if (report.academic_status != "Academic Dismissal") || (report.academic_status != "Incomplete")
              if self.program.program_semester > self.student.semester
                promoted_semester = self.student.semester + 1
                self.student.update_columns(semester: promoted_semester)
              elsif (self.program.program_semester == self.student.semester) && (self.program.program_duration > self.student.year)
                promoted_year = self.student.year + 1
                self.student.update_columns(semester: 1)
                self.student.update_columns(year: promoted_year)
              end
            end
          end
        end

        report.created_by = self.created_by
      end
    end
  end

  def approve_enrollment_status
    if self.finance_approval_status == "approved" && self.registrar_approval_status == "approved"
      self.course_registrations.update(enrollment_status: "enrolled")
    end
  end

  def denied_enrollment_status
    if self.finance_approval_status == "denied" && self.registrar_approval_status == "denied"
      self.course_registrations.update(enrollment_status: "denied")
    end
  end

  private

  def add_admission_date
    if self.semester == 1 && self.year == 1
      self.student.update(admission_date: Date.current)
    end
  end

  def generate_invoice
    if self.mode_of_payment.present? && self.invoices.where(year: self.year, semester: self.semester).empty?
      self.update_columns(is_back_invoice_created: true)

      Invoice.create do |invoice|
        invoice.semester_registration_id = self.id
        invoice.student_id = self.student.id
        invoice.department_id = self.department_id
        invoice.program_id = self.program_id
        invoice.academic_calendar_id = self.academic_calendar_id
        invoice.year = self.year
        invoice.semester = self.semester
        invoice.student_id_number = self.student_id_number
        invoice.student_full_name = self.student_full_name
        invoice.created_by = self.last_updated_by
        invoice.due_date = self.created_at + 10.day
        invoice.invoice_status = "unpaid"
        invoice.registration_fee = self.student.get_registration_fee
        tution_price = self.student.get_tution_fee
        invoice.invoice_number = SecureRandom.random_number(10000000)
        if self.mode_of_payment == "Monthly Payment"
          invoice.total_price = tution_price / 4
        elsif self.mode_of_payment == "Full Semester Payment"
          invoice.total_price = tution_price
        elsif self.mode_of_payment == "Half Semester Payment"
          invoice.total_price = tution_price / 2
        end
      end
    end
  end

  def semester_course_registration
    if self.finance_approval_status == "pending" && self.registrar_approval_status == "pending"
      # self.program.curriculums.where(curriculum_version: self.student.curriculum_version).last.courses.where(year: self.year, semester: self.semester).each do |co|
      all_courses = []
      self.student.get_current_courses.each do |co|
        all_courses << CourseRegistration.new do |course_registration|
          course_registration.semester_registration_id = self.id
          course_registration.program_id = self.program.id
          course_registration.department_id = self.department.id
          course_registration.academic_calendar_id = self.academic_calendar_id
          course_registration.student_id = self.student.id
          course_registration.student_full_name = self.student_full_name
          course_registration.course_id = co.id
          course_registration.academic_year = get_academic_year(self.semester, self.student)
          course_registration.course_title = co.course_title
          course_registration.semester = self.semester
          course_registration.year = self.year
          # course_registration.course_section_id = CourseSection.first.id
          course_registration.created_by = self.created_by
        end
      end
      CourseRegistration.import! all_courses
    end
  end

  def change_course_registration_status
    if (self.registrar_approval_status == "approved")
      self.course_registrations.where(enrollment_status: "pending").map { |course| course.update_columns(enrollment_status: "enrolled") }
    end
  end

  def get_academic_year(semester, student)
    if semester == 1
      Date.current.year
    else
      CourseRegistration.select(:academic_year).where(student: student).where(semester: 1).last.academic_year
    end
  end

  def assign_section_to_course_registration
    if (self.registrar_approval_status == "approved") && self.section.present?
      self.course_registrations.where(section_id: nil).map { |course| course.update(section_id: self.section_id) }
    end
  end
end

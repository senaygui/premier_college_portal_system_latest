class Student < ApplicationRecord
  ##callbacks
  before_save :attributies_assignment
  before_save :student_id_generator
  after_save :student_semester_registration
  # before_create :assign_curriculum
  before_create :set_pwd
  after_save :student_course_assign

  # after_save :course_registration
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  #  , :authentication_keys => [:email]
  has_person_name
  ##associations
  belongs_to :department, optional: true
  belongs_to :program
  belongs_to :academic_calendar, optional: true
  has_one :student_address, dependent: :destroy
  accepts_nested_attributes_for :student_address
  has_one :emergency_contact, dependent: :destroy
  accepts_nested_attributes_for :emergency_contact
  has_many :semester_registrations, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_one_attached :grade_10_matric, dependent: :destroy
  has_one_attached :grade_12_matric, dependent: :destroy
  has_one_attached :coc, dependent: :destroy
  has_one_attached :highschool_transcript, dependent: :destroy
  has_one_attached :diploma_certificate, dependent: :destroy
  has_one_attached :degree_certificate, dependent: :destroy
  has_one_attached :undergraduate_transcript, dependent: :destroy
  has_one_attached :photo, dependent: :destroy
  has_many :student_grades, dependent: :destroy
  has_many :grade_reports
  has_many :course_registrations
  has_many :student_attendances
  has_many :assessments
  has_many :grade_changes
  has_one :school_or_university_information, dependent: :destroy
  accepts_nested_attributes_for :school_or_university_information
  has_many :student_courses, dependent: :destroy
  has_many :withdrawals, dependent: :destroy
  has_many :recurring_payments, dependent: :destroy
  has_many :add_and_drops, dependent: :destroy
  has_many :makeup_exams, dependent: :destroy

  #validate :password_complexity
  # validates :student_grades, presence: true
  #validates :first_name , :presence => true,:length => { :within => 2..100 }, format: { with: /\A[a-zA-Z]+\z/, message: "Only letters are allowed" }
  #validates :middle_name , :presence => true,:length => { :within => 2..100 }, format: { with: /\A[a-zA-Z]+\z/, message: "Only letters are allowed" }
  # validates :current_location , :presence => true,:length => { :within => 2..100 }
  #validates :last_name , :presence => true,:length => { :within => 2..100 }, format: { with: /\A[a-zA-Z]+\z/, message: "Only letters are allowed" }
  # validates :student_id , uniqueness: true
  #validates :gender, :presence => true
  #validates :date_of_birth , :presence => true
  #validates :study_level, :presence => true
  #validates :admission_type, :presence => true,:length => { :within => 2..10 }
  #validates :nationality, :presence => true
  #validates :photo, attached: true, content_type: ['image/gif', 'image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 5.megabytes, message: 'File size must be less than 5MB' }
  #validates :highschool_transcript, attached: true, size: { less_than: 5.megabytes, message: 'File size must be less than 5MB' }
  #validates :grade_12_matric, attached: true, size: { less_than: 5.megabytes, message: 'File size must be less than 5MB' }
  #validates :highschool_transcript, attached: true
  #validates :diploma_certificate, attached: true, size: { less_than: 5.megabytes, message: 'File size must be less than 5MB' }
  #validates :degree_certificate, attached: true, size: { less_than: 5.megabytes, message: 'File size must be less than 5MB' }
  #validates :place_of_birth, format: { with: /\A[a-zA-Z]+\z/, message: "Only letters are allowed"}

  def password_complexity
    if password.present?
      if !password.match(/^(?=.*[a-z])(?=.*[A-Z])/)
        errors.add :password, "must be between 5 to 20 characters which contain at least one lowercase letter, one uppercase letter, one numeric digit, and one special character"
      end
    end
  end

  ##scope
  scope :recently_added, lambda { where("created_at >= ?", 1.week.ago) }
  scope :undergraduate, lambda { where(study_level: "undergraduate") }
  scope :graduate, lambda { where(study_level: "graduate") }
  scope :online, lambda { where(admission_type: "online") }
  scope :regular, lambda { where(admission_type: "regular") }
  scope :extention, lambda { where(admission_type: "extention") }
  scope :distance, lambda { where(admission_type: "distance") }
  scope :pending, lambda { where(document_verification_status: "pending") }
  scope :approved, lambda { where(document_verification_status: "approved") }
  scope :denied, lambda { where(document_verification_status: "denied") }
  scope :incomplete, lambda { where(document_verification_status: "incomplete") }

  def get_current_courses
    self.program.curriculums.where(active_status: "active").first.courses.where(year: self.year, semester: self.semester).order("year ASC
    ", "semester ASC")
  end

  def self.get_gc_students(graduation_status, graduation_year, program_id, study_level, admission_type)
    self.where(graduation_status: graduation_status).where(study_level: study_level).where(graduation_year: graduation_year).where(program_id: program_id).where(admission_type: admission_type).includes(:department).includes(:grade_reports)
  end

  def self.get_admitted_student(graduation_status, program_id, year, semester, study_level, admission_type)
    self.where(graduation_status: graduation_status).where(study_level: study_level).where(year: year).where(semester: semester).where(program_id: program_id).where(admission_type: admission_type).includes(:program)
  end

  def self.report_semester(year)
    Student.distinct.where(year: year).select(:semester)
  end

  def self.fetch_student_for_report(status)
    self.where(graduation_status: status).includes(:department)
  end

  def get_registration_fee
    return nil if college_payment.nil?
    college_payment.registration_fee
  end

  def get_tution_fee
    return nil if college_payment.nil?
    get_current_courses.collect { |oi| oi.valid? ? (college_payment.tution_per_credit_hr * oi.credit_hour) : 0 }.sum
  end

  def college_payment
    CollegePayment.find_by(study_level: self.study_level.strip, admission_type: self.admission_type.strip)
  end

  def add_student_registration(mode_of_payment = nil)
    SemesterRegistration.create do |registration|
      registration.student_id = self.id
      registration.program_id = self.program.id
      registration.department_id = self.program.department.id
      registration.student_full_name = "#{self.first_name.upcase} #{self.middle_name.upcase} #{self.last_name.upcase}"
      registration.student_id_number = self.student_id
      registration.created_by = "#{self.created_by}"
      registration.academic_calendar_id = self.academic_calendar.id
      registration.year = self.year
      registration.semester = self.semester
      registration.program_name = self.program.program_name
      registration.admission_type = self.admission_type
      registration.study_level = self.study_level
      registration.created_by = self.last_updated_by
      registration.mode_of_payment = mode_of_payment unless mode_of_payment.nil?
      # registration.total_enrolled_course = total_course
    end
  end

  private

  ## callback methods
  def set_pwd
    self[:student_password] = self.password
  end

  def attributies_assignment
    if (self.document_verification_status == "approved") && (!self.academic_calendar.present?)
      self.update_columns(academic_calendar_id: AcademicCalendar.where(study_level: self.program.study_level, admission_type: self.program.admission_type).order("created_at DESC").first.id)
      self.update_columns(department_id: program.department_id)
      self.update_columns(curriculum_version: program.curriculums.where(active_status: "active").last.curriculum_version)
      self.update_columns(payment_version: program.payments.order("created_at DESC").first.version)
      self.update_columns(batch: AcademicCalendar.where(study_level: self.program.study_level).where(admission_type: self.program.admission_type).order("created_at DESC").first.calender_year_in_gc)
    end
  end

  def student_id_generator
    if self.document_verification_status == "approved" && !(self.student_id.present?)
      begin
        self.student_id = "#{self.program.program_code}/#{SecureRandom.random_number(1000..10000)}/#{Time.now.strftime("%y")}"
      end while Student.where(student_id: self.student_id).exists?
    end
  end

  def student_semester_registration
    if self.document_verification_status == "approved" && self.semester_registrations.empty? && self.year == 1 && self.semester == 1 && self.program.entrance_exam_requirement_status == false
      add_student_registration if self.semester_registrations.find_by(semester: self.semester).nil?
    end
  end

  def self.get_online_student(year, semester)
    # Student.where(admission_type: 'online', year: year, semester: semester).joins(:course_registrations).where(course_registrations: {year: year, semester: semester})
     self.where(admission_type: 'online').select("id")
  end

  def student_course_assign
    if self.student_courses.empty? && self.document_verification_status == "approved" && self.program.entrance_exam_requirement_status == false
      self.program.curriculums.where(curriculum_version: self.curriculum_version).last.courses.each do |course|
        StudentCourse.create do |student_course|
          student_course.student_id = self.id
          student_course.course_id = course.id
          student_course.course_title = course.course_title
          student_course.semester = course.semester
          student_course.year = course.year
          student_course.credit_hour = course.credit_hour
          student_course.ects = course.ects
          student_course.course_code = course.course_code
          student_course.created_by = self.created_by
        end
      end
    elsif self.student_courses.empty? && self.program.entrance_exam_requirement_status == true && self.document_verification_status == "approved" && self.entrance_exam_result_status == "Pass"
      self.program.curriculums.where(curriculum_version: self.curriculum_version).last.courses.each do |course|
        StudentCourse.create do |student_course|
          student_course.student_id = self.id
          student_course.course_id = course.id
          student_course.course_title = course.course_title
          student_course.semester = course.semester
          student_course.year = course.year
          student_course.credit_hour = course.credit_hour
          student_course.ects = course.ects
          student_course.course_code = course.course_code
        end
      end
    end
  end
end

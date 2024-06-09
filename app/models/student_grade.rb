class StudentGrade < ApplicationRecord
  after_create :generate_assessment
  after_save :update_subtotal
  # after_save :generate_grade
  after_save :add_course_registration
  after_save :update_grade_report
  ##validation
  validates :student, presence: true
  validates :course, presence: true
  #  validates :course_registration, presence: true
  ##assocations
  belongs_to :course_registration, optional: true
  belongs_to :student
  belongs_to :course
  belongs_to :department, optional: true
  belongs_to :program, optional: true
  has_many :assessments, dependent: :destroy
  accepts_nested_attributes_for :assessments, reject_if: :all_blank, allow_destroy: true
  has_many :grade_changes
  has_many :makeup_exams
  validates_uniqueness_of :id, scope: [:student_id, :course_id]

  def add_course_registration
    if !self.course_registration.present?
      cr = CourseRegistration.where(student_id: self.student.id, course_id: self.course.id).last.id
      self.update_columns(course_registration_id: cr)
    end
  end

  def assesment_total1
    # assessments.collect { |oi| oi.valid? ? (oi.result) : 0 }.sum
    assessments.sum(:result)
  end

  def self.create_student_grade(crs)
    counter = 0
    crs.each do |cr|
      if cr.student_grade.blank?
        counter += 1 if MoodleGrade.moodle_grade(cr)
      end
    end
    counter
  end

  def self.online_student_grade(department, year, semester, status)
    ids = Student.where(admission_type: "online").where(department_id: department).where(year: year).where(semester: semester).select("id")
    StudentGrade.where(student_id: ids).where(department_approval: status.strip).includes(:student).includes(:department)
  end

  def update_subtotal
    if self.assessments.any?
      self.update_columns(assesment_total: self.assessments.sum(:result))
    end
  end

  def generate_grade
    if self.assessments.any?
      if assessments.where(result: nil).empty?
        grade_in_letter = self.student.program.grade_systems.last.grades.where("min_row_mark <= ?", self.assesment_total1).where("max_row_mark >= ?", self.assesment_total1).last.letter_grade
        grade_letter_value = self.student.program.grade_systems.last.grades.where("min_row_mark <= ?", self.assesment_total1).where("max_row_mark >= ?", self.assesment_total1).last.grade_point * self.course.credit_hour
        self.update_columns(letter_grade: grade_in_letter)
        self.update_columns(grade_point: grade_letter_value)
      elsif self.assessments.where(result: nil, final_exam: true).present?
        self.update_columns(letter_grade: "NG")
        # needs to be empty and after a week changes to f
        self.update_columns(grade_point: 0)
      elsif assessments.where(result: nil, final_exam: false).present?
        self.update_columns(letter_grade: "I")
        # needs to be empty and after a week changes to f
        self.update_columns(grade_point: 0)
      end
    end
    # self[:grade_in_letter] = grade_in_letter
  end

  private

  def generate_assessment
    self.course.assessment_plans.each do |plan|
      Assessment.create do |assessment|
        assessment.course_id = self.course.id
        assessment.student_id = self.student.id
        assessment.student_grade_id = self.id
        assessment.assessment_plan_id = plan.id
        assessment.final_exam = plan.final_exam
        assessment.created_by = self.created_by
      end
    end
  end

  def update_grade_report
    if self.course_registration.semester_registration.grade_report.present?
      if self.student.grade_reports.count == 1
        total_credit_hour = self.course_registration.semester_registration.course_registrations.where(enrollment_status: "enrolled").collect { |oi| ((oi.student_grade.letter_grade != "I") && (oi.student_grade.letter_grade != "NG")) ? (oi.course.credit_hour) : 0 }.sum
        total_grade_point = self.course_registration.semester_registration.course_registrations.where(enrollment_status: "enrolled").collect { |oi| ((oi.student_grade.letter_grade != "I") && (oi.student_grade.letter_grade != "NG")) ? (oi.student_grade.grade_point) : 0 }.sum
        sgpa = total_credit_hour == 0 ? 0 : (total_grade_point / total_credit_hour).round(1)
        cumulative_total_credit_hour = total_credit_hour
        cumulative_total_grade_point = total_grade_point
        cgpa = cumulative_total_credit_hour == 0 ? 0 : (cumulative_total_grade_point / cumulative_total_credit_hour).round(1)
        self.course_registration.semester_registration.grade_report.update(total_credit_hour: total_credit_hour, total_grade_point: total_grade_point, sgpa: sgpa, cumulative_total_credit_hour: cumulative_total_credit_hour, cumulative_total_grade_point: cumulative_total_grade_point, cgpa: cgpa)
        if (self.course_registration.semester_registration.course_registrations.joins(:student_grade).pluck(:letter_grade).include?("I").present?) || (self.course_registration.semester_registration.course_registrations.joins(:student_grade).pluck(:letter_grade).include?("NG").present?)
          academic_status = "Incomplete"
        else
          academic_status = self.program.grade_systems.last.academic_statuses.where("min_value <= ?", cgpa).where("max_value >= ?", cgpa).last.status
        end

        if self.course_registration.semester_registration.grade_report.academic_status != academic_status
          if ((self.course_registration.semester_registration.grade_report.academic_status == "Dismissal") || (self.course_registration.semester_registration.grade_report.academic_status == "Incomplete")) && ((academic_status != "Dismissal") || (academic_status != "Incomplete"))
            if self.program.program_semester > self.student.semester
              promoted_semester = self.student.semester + 1
              self.student.update_columns(semester: promoted_semester)
            elsif (self.program.program_semester == self.student.semester) && (self.program.program_duration > self.student.year)
              promoted_year = self.student.year + 1
              self.student.update_columns(semester: 1)
              self.student.update_columns(year: promoted_year)
            end
          end
          self.course_registration.semester_registration.grade_report.update_columns(academic_status: academic_status)
        end
      else
        total_credit_hour = self.course_registration.semester_registration.course_registrations.where(enrollment_status: "enrolled").collect { |oi| ((oi.student_grade.letter_grade != "I") && (oi.student_grade.letter_grade != "NG")) ? (oi.course.credit_hour) : 0 }.sum
        total_grade_point = self.course_registration.semester_registration.course_registrations.where(enrollment_status: "enrolled").collect { |oi| ((oi.student_grade.letter_grade != "I") && (oi.student_grade.letter_grade != "NG")) ? (oi.student_grade.grade_point) : 0 }.sum
        sgpa = total_credit_hour == 0 ? 0 : (total_grade_point / total_credit_hour).round(1)

        cumulative_total_credit_hour = GradeReport.where(student_id: self.student_id).order("created_at ASC").last.cumulative_total_credit_hour + total_credit_hour
        cumulative_total_grade_point = GradeReport.where(student_id: self.student_id).order("created_at ASC").last.cumulative_total_grade_point + total_grade_point
        cgpa = (cumulative_total_grade_point / cumulative_total_credit_hour).round(1)

        academic_status = self.program.grade_systems.last.academic_statuses.where("min_value <= ?", cgpa).where("max_value >= ?", cgpa).last.status

        self.course_registration.semester_registration.grade_report.update(total_credit_hour: total_credit_hour, total_grade_point: total_grade_point, sgpa: sgpa, cumulative_total_credit_hour: cumulative_total_credit_hour, cumulative_total_grade_point: cumulative_total_grade_point, cgpa: cgpa)

        if (self.course_registration.semester_registration.course_registrations.joins(:student_grade).pluck(:letter_grade).include?("I").present?) || (self.course_registration.semester_registration.course_registrations.joins(:student_grade).pluck(:letter_grade).include?("NG").present?)
          academic_status = "Incomplete"
        else
          academic_status = self.program.grade_systems.last.academic_statuses.where("min_value <= ?", cgpa).where("max_value >= ?", cgpa).last.status
        end

        if self.course_registration.semester_registration.grade_report.academic_status != academic_status
          if ((self.course_registration.semester_registration.grade_report.academic_status == "Dismissal") || (self.course_registration.semester_registration.grade_report.academic_status == "Incomplete")) && ((academic_status != "Dismissal") || (academic_status != "Incomplete"))
            if self.program.program_semester > self.student.semester
              promoted_semester = self.student.semester + 1
              self.student.update_columns(semester: promoted_semester)
            elsif (self.program.program_semester == self.student.semester) && (self.program.program_duration > self.student.year)
              promoted_year = self.student.year + 1
              self.student.update_columns(semester: 1)
              self.student.update_columns(year: promoted_year)
            end
          end
          self.course_registration.semester_registration.grade_report.update_columns(academic_status: academic_status)
        end
      end
    end
  end

  def moodle_grade
    url = URI("https://lms.premiercollege.edu.et/webservice/rest/server.php")
    moodle = MoodleRb.new('18425a712e7668d6339fa671fa05db04', 'https://lms.premiercollege.edu.et/webservice/rest/server.php')
    lms_student = moodle.users.search(email: "#{self.student.email}")
    user = lms_student[0]["id"]
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    form_data = [['wstoken', '92dac7334a9d4aee7cc3474b81f15c45'],['wsfunction', 'gradereport_overview_get_course_grades'],['moodlewsrestformat', 'json'],['userid', "#{user}"]]
    request.set_form form_data, 'multipart/form-data'
    response = https.request(request)
    # puts response.read_body
    results =  JSON.parse(response.read_body)
    course_code = moodle.courses.search("#{self.course_registration.course.course_code}")
    course = course_code["courses"][0]["id"]
    
    total_grade = results["grades"].map {|h1| h1['rawgrade'] if h1['courseid']== course}.compact.first
    grade_letter = results["grades"].map {|h1| h1['grade'] if h1['courseid']== course}.compact.first
    # self.update_columns(grade_in_letter: grade_letter)
    self.update(assesment_total: total_grade.to_f)
  end
  
end

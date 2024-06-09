class StudentTemporaryController < ApplicationController
  add_flash_types :success

  def index
    @disable_nav = true
    @program = Program.select(:program_name, :id)
  end

  def approved
    ids = session[:student_ids]
    graduation_status = Student.where(id: ids).update(graduation_status: "approved", graduation_year: Date.current.year)
    if graduation_status
      redirect_to admin_graduation_url, notice: "#{ids.size} #{"student".pluralize(ids.size)} got approved for graduation"
    else
      redirect_to graduation_approval_form_url, alert: "Something went wrong for the selected student"
    end
  end

  def graduation_approval
    program_id = params[:program][:name]
    study = params[:study]
    program = Program.find(program_id)
    student_ids = filter_student(program, study)
    if student_ids.empty?
      redirect_to graduation_approval_form_url, alert: "We could not find a student matching your search criteria"
    else
      session[:student_ids] = student_ids
      redirect_to graduation_approval_form_url, success: "#{student_ids.size} #{"student".pluralize(student_ids.size)} in #{program.program_name} program with #{study} study level are ready for graduation"
    end
  end

  def graduation_approval_form
    @disable_nav = true
    @program = Program.select(:program_name, :id)
  end

  def generate_pdf
    program_id = params[:program][:name]
    degree = params[:degree]
    gc_date = params[:gc][:date]
    study = params[:study]

    program = Program.find(program_id)
    students = filter_student_for_tempo(program, study)
    redirect_to student_temporary_url, alert: "We could not find a student matching your search criteria. Please please check student graduation status is approved" if students.empty?
    if students.any?
      respond_to do |format|
        format.html
        format.pdf do
          pdf = StudentTemporary.new(students, degree, gc_date)
          send_data pdf.render, filename: "#{study}_#{program.program_name}_program.pdf", type: "application/pdf", disposition: "inline"
        end
      end
    end
  end

  private

  def filter_student(program, study)
    grade_system = GradeSystem.select(:min_cgpa_value_to_graduate).find_by(program: program)
    curriculum = Curriculum.select(:total_course).find_by(program: program)
    min_cgpa_value_to_graduate = grade_system.min_cgpa_value_to_graduate if grade_system.present?
    students = Student.where(program: program).where(year: program.program_duration).where(graduation_status: "pending").where(semester: program.program_semester).where(study_level: study).includes(:grade_reports).includes(:student_grades)
    number_of_course_in_curriculum = curriculum.total_course if curriculum.present?
    all_student_ids = []
    students.each do |stud|
      total_course = stud.grade_reports.last.total_course if stud.grade_reports.last.present?
      cgpa = stud.grade_reports.last.cgpa if stud.grade_reports.last.present?
      major = Major.major_point_and_hour(stud.course_registrations)
      if study == "undergraduate"
        number_of_f = stud.student_grades.where(letter_grade: "F").where(letter_grade: "f").size
        if total_course == number_of_course_in_curriculum && cgpa >= 2.0 && number_of_f == 0 && major[1] >= 2
          all_student_ids << stud.id
        end
      else
        number_of_c = stud.student_grades.where(letter_grade: "c").where(letter_grade: "C").size
        if total_course == number_of_course_in_curriculum && cgpa >= min_cgpa_value_to_graduate && number_of_c <= 2
          all_student_ids << stud.id
        end
      end
    end
    all_student_ids
  end

  def filter_student_for_tempo(program, study)
    students = Student.where(program: program).where(study_level: study).where(graduation_status: "approved").includes(:grade_reports).includes(:student_grades)
    students
  end
end

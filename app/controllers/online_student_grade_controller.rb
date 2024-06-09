class OnlineStudentGradeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def prepare
    year = params[:year]
    semester = params[:year]
    #ImportOnlineStudentGradeJob.perform_later(year, semester)
    ids = Student.get_online_student(year, semester)
    crs = CourseRegistration.get_course_per_student(ids)
    result = StudentGrade.create_student_grade(crs)
    redirect_to admin_onlinestudentgrade_path, notice: "Successfuly import #{result} students grade from LMS" if result > 0
    redirect_to admin_onlinestudentgrade_path, alert: "No student grades have been imported. This may be because the student is not available or their grade has already been imported." if result.zero?
  end

  def online_grade
    department ||= params[:department_id]
    year ||= params[:year]
    semester ||= params[:semester]
    status ||= params[:status]
    student_grades = StudentGrade.online_student_grade(department, year, semester, status)
    respond_to do |format|
      format.html
      format.json { render json: student_grades.to_json(only: [:letter_grade, :assesment_total, :grade_point, :department_approval], include: { student: { only: [:first_name, :last_name, :year, :semester] }, course: { only: :course_title } }) }
    end
  end

  def approve_grade
    department ||= params[:department]
    year ||= params[:year]
    semester ||= params[:semester]
    status ||= params[:status]

    student_grades = StudentGrade.online_student_grade(department, year, semester, status)
    redirect_to admin_onlinestudentgrade_path, alert: "There is no student with the given search criteria" if student_grades.empty?
    if student_grades.any?
      if student_grades.update(department_approval: "approved", approved_by: current_admin_user.name.full, approval_date: Date.current)
        redirect_to admin_onlinestudentgrade_path, notice: "Succssfuly Approved #{student_grades.size} students"
      else
        redirect_to admin_onlinestudentgrade_path, alert: "Something went wrong please contact support center!"
      end
    end
  end
end

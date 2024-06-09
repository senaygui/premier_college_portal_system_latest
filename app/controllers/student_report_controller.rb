class StudentReportController < ApplicationController
  skip_before_action :verify_authenticity_token # To skip authenticity verification

  def get_student_list
    graduation_status ||= params[:graduation_status]
    students = Student.fetch_student_for_report(graduation_status)
    respond_to do |format|
      format.html
      format.json { render json: students }
    end
  end

  def student_report_year
    program_id ||= params[:program]
    each_year = Student.distinct.where(program_id: program_id).select(:year)
    respond_to do |format|
      format.html
      format.json { render json: each_year.to_json(only: [:year]) }
    end
  end

  def student_report_program
    graduation_status ||= params[:graduation_status]
    # program
    each_program = Student.distinct.where(graduation_status: graduation_status).select(:program_id)
    respond_to do |format|
      format.html
      format.json { render json: each_program.to_json(include: { program: { only: [:program_id, :program_name] } }) }
    end
  end

  def student_report_gc
    gc_year ||= params[:gc_year]
    each_program = Student.distinct.where(graduation_year: gc_year).select(:program_id)
    respond_to do |format|
      format.html
      format.json { render json: each_program.to_json(include: { program: { only: [:program_id, :program_name] } }) }
    end
  end

  def student_report_gc_year
    graduation_status ||= params[:graduation_status]
    each_gc_year = Student.distinct.where(graduation_status: graduation_status).select(:graduation_year)
    respond_to do |format|
      format.html
      format.json { render json: each_gc_year }
    end
  end

  def student_report_semester
    year ||= params[:year]
    each_semester = Student.report_semester(year)
    respond_to do |format|
      format.html
      format.json { render json: each_semester.to_json(only: [:semester]) }
    end
  end

  def student_report_pdf
    graduation_status ||= params[:graduation_status]
    graduation_year ||= params[:gc_year]
    program_id ||= params[:report_program]
    year ||= params[:report_year]
    semester ||= params[:report_semester]
    study_level ||= params[:study_report_level]
    admission_type ||= params[:admission_report_type]
    if graduation_status == "approved"
      @students = Student.get_gc_students(graduation_status, graduation_year, program_id, study_level, admission_type)
      redirect_to admin_studentreport_url, alert: "We could not find a student matching your search criteria. Please try again" if @students.empty?
      if @students.any?
        respond_to do |format|
          format.html
          format.pdf do
            pdf = GcStudentReport.new(@students)
            send_data pdf.render, filename: "report #{Time.zone.now}.pdf", type: "application/pdf", disposition: "inline"
          end
        end
      end
    else
      @students = Student.get_admitted_student("pending", program_id, year, semester, study_level, admission_type)
      redirect_to admin_studentreport_url, alert: "We could not find a student matching your search criteria. Please try again" if @students.empty?
      if @students.any?
        respond_to do |format|
          format.html
          format.pdf do
            pdf = NonGcStudentReport.new(@students)
            send_data pdf.render, filename: "report #{Time.zone.now}.pdf", type: "application/pdf", disposition: "inline"
          end
        end
      end
    end
  end
end

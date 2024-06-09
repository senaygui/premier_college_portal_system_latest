class PaymentReportController < ApplicationController
  skip_before_action :verify_authenticity_token # To skip authenticity verification

  def fetch_student
    departement ||= params[:department_id]

    semester_registrations = SemesterRegistration.fetch_student_semester_registrations(departement)
    respond_to do |format|
      format.html
      format.json { render json: semester_registrations.to_json(only: [:semester, :year, :total_price, :study_level, :admission_type, :remaining_amount, :mode_of_payment, :actual_payment], include: { student: { only: [:first_name, :last_name] } }) }
    end
  end

  def get_year
    dept ||= params[:dept]
    each_year = SemesterRegistration.distinct.where(department_id: dept).select(:year)
    respond_to do |format|
      format.html
      format.json { render json: each_year.to_json(only: [:year]) }
    end
  end

  def get_semester
    year ||= params[:year]
    each_semester = SemesterRegistration.distinct.where(year: year).select(:semester)
    respond_to do |format|
      format.html
      format.json { render json: each_semester.to_json(only: [:semester]) }
    end
  end

  def generate_payment_report
    department ||= params[:departement]
    year ||= params[:year]
    semester ||= params[:semester]
    study_level ||= params[:study_level]
    admission_type ||= params[:admission_type]
    remaining_status ||= params[:remaining_status]

    if remaining_status =="true"
      @students = SemesterRegistration.where(admission_type: admission_type).where(study_level: study_level).where(department_id: department).where(year: year).where(semester: semester).where("remaining_amount = ?", 0.0)
    else
      @students = SemesterRegistration.where(admission_type: admission_type).where(study_level: study_level).where(department_id: department).where(year: year).where(semester: semester).where("remaining_amount > ?", 0.0)
    end
    redirect_to admin_financereport_url, alert: "We could not find a student matching your search criteria. Please try again" if @students.empty?
    if @students.any?
      respond_to do |format|
        format.html
        format.pdf do
          pdf = FinancialReport.new(@students)
          send_data pdf.render, filename: "report #{Time.zone.now}.pdf", type: "application/pdf", disposition: "inline"
        end
      end
    end
  end
end

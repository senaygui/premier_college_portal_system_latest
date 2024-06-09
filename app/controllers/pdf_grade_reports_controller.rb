class PdfGradeReportsController < ApplicationController
  # before_action :set_filter
  def index
    @disable_nav = true
    @department = Department.select(:department_name, :id)
  end

  def prepare_pdf
    department = params[:department][:name]
    year = params[:student][:year]
    #section = params[:section][:id]
    semester = params[:semester]
    students = GradeReport.where(department_id: department).where(year: year).where(semester: semester)
    redirect_to pdf_gread_report_url, alert: "We could not find a student matching your search criteria. Please try again" if students.empty?
    if students.any?
      respond_to do |format|
        format.html
        format.pdf do
          pdf = StudentGradeReport.new(students)
          send_data pdf.render, filename: "student grade #{Time.zone.now}.pdf", type: "application/pdf", disposition: "inline"
        end
      end
    end
  end
end

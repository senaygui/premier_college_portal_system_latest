class StudentCopyController < ApplicationController
    add_flash_types :success
  def index
    @disable_nav =true
    @department = Department.select(:department_name, :id)
    @year = Student.distinct.select(:graduation_year).where.not(graduation_year: nil)
  end

  def generate_student_copy
    graduation_year = params[:year][:name]
    department_id = params[:department][:name]
    gc_date = params[:gc][:date]
    students = Student.where(department_id: department_id).where(graduation_year: graduation_year).where(graduation_status: 'approved').includes(:course_registrations).includes(:student_grades)
    redirect_to student_copy_url, alert: "We could not find a student matching your search criteria. Did you check student graduation status is approved?" if students.empty?
    if students.any?
      respond_to do |format|
      format.html 
      format.pdf do
        pdf = StudentCopy.new(students, gc_date)
        send_data pdf.render, filename: "Student copy at #{Time.now}.pdf", type: "application/pdf", disposition: 'inline'  
      end
    end
  end
end
end

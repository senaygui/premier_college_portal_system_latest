class PagesController < ApplicationController
  before_action :authenticate_student!, only: [:enrollement, :documents, :profile, :dashboard, :create_semester_registration]
  # layout false, only: [:home]
  def home
    # authenticate_student!
  end

  def admission
  end

  def documents
  end

  def digital_iteracy_quiz
  end

  def requirement
  end

  def profile
    @address = current_student.student_address
    @emergency_contact = current_student.emergency_contact
  end

  def dashboard
    @address = current_student.student_address
    @emergency_contact = current_student.emergency_contact
    @invoice = Invoice.find_by(student: current_student, semester: current_student.semester, year: current_student.year)
    @smr = current_student.semester_registrations.where(year: current_student.year, semester: current_student.semester).last
    @payment_remaining = current_student.semester_registrations.where("remaining_amount > ?", 0).last if @smr.nil?
  end

  def enrollement
    @total_course = current_student.get_current_courses
    @registration_fee = current_student.get_registration_fee
    @tution_fee = current_student.get_tution_fee
    # @total = @registration_fee + tution_fee
  end

  def create_semester_registration
    mode_of_payment = params[:mode_of_payment]
    # total_course = Student.get_current_courses(current_student).size
    registration = current_student.add_student_registration(mode_of_payment: mode_of_payment)
    respond_to do |format|
      if registration.save
        format.html { redirect_to invoice_path(registration.invoices.last.id), notice: "Registration was successfully created." }
        format.json { render :show, status: :ok, location: registration }
      else
        format.html { redirect_to :enrollement_path, alert: "Something went wrong please try again" }
        format.json { render json: registration.errors, status: :unprocessable_entity }
      end
    end
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true, with: :exception

  def home
    render html: "Welcome to Premier College Online"
  end

  def access_denied(exception)
    flash[:error] = exception.message

    redirect_to admin_root_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    redirect_to root_path
  end

  def current_ability
    if current_admin_user.kind_of?(AdminUser)
      @current_ability ||= Ability.new(current_admin_user)
    else
      @current_ability ||= UserAbility.new(current_student)
    end
  end

  # def after_sign_in_path_for(resource)
  #  if current_admin_user.present?
  #   admin_root_path
  #  elsif current_student.sign_in_count == 1
  #   edit_student_registration_path(update_pwd: "update_pwd")
  #  else
  #   root_path
  #  end
  # end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |student_params|
      student_params.permit(:batch, :nationality, :undergraduate_transcript, :highschool_transcript, :grade_10_matric, :grade_12_matric, :coc, :diploma_certificate, :degree_certificate, :place_of_birth, :sponsorship_status, :entrance_exam_result_status, :student_id_taken_status, :old_id_number, :curriculum_version, :current_occupation, :tempo_status, :created_by, :last_updated_by, :photo, :email, :password, :first_name, :last_name, :middle_name, :gender, :student_id, :date_of_birth, :program_id, :department, :admission_type, :study_level, :marital_status, :year, :semester, :account_verification_status, :document_verification_status, :account_status, :graduation_status, student_address_attributes: [:id, :country, :city, :region, :zone, :sub_city, :house_number, :special_location, :moblie_number, :telephone_number, :pobox, :woreda, :created_by, :last_updated_by], emergency_contact_attributes: [:id, :full_name, :relationship, :cell_phone, :email, :current_occupation, :name_of_current_employer, :pobox, :email_of_employer, :office_phone_number, :created_by, :last_updated_by], school_or_university_information_attributes: [:id, :level, :coc_attendance_date, :college_or_university, :phone_number, :address, :field_of_specialization, :cgpa, :last_attended_high_school, :school_address, :grade_10_result, :grade_10_exam_taken_year, :grade_12_exam_result, :grade_12_exam_taken_year, :created_by, :updated_by])
    end
    devise_parameter_sanitizer.permit(:account_update) do |student_params|
      student_params.permit(:password, :password_confirmation, :first_name, :last_name, :middle_name, :gender, :student_id, :date_of_birth, :program_id, :department, :admission_type, :study_level, :marital_status, :year, :semester, :account_verification_status, :document_verification_status, :account_status, :graduation_status, student_address_attributes: [:id, :country, :city, :region, :zone, :sub_city, :house_number, :cell_phone, :house_phone, :pobox, :woreda, :created_by, :last_updated_by], emergency_contact_attributes: [:id, :full_name, :relationship, :cell_phone, :email, :current_occupation, :name_of_current_employer, :pobox, :email_of_employer, :office_phone_number, :created_by, :last_updated_by], documents: [])
    end
    devise_parameter_sanitizer.permit(:sign_in) do |student_params|
      student_params.permit(:email, :password, :remember_me)
    end
  end
end

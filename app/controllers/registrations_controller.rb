class RegistrationsController < Devise::RegistrationsController
  before_action :check_permit, only: [:update_document]
  # private

  # def after_sign_up_path_for(resource)
  # 	# if user_signed_in?
  # 	# 	payment_path
  # 	# end
  # end
  # def new
  #    super do |resource|
  #      resource.build_student_address
  #    end
  #  endp
  def new

    # Override Devise default behaviour and create a profile as well
    build_resource({})
    resource.build_emergency_contact
    resource.build_student_address
    respond_with self.resource
  end

  def update_profile_photo
    current_student.photo.attach(check_permit[:photo])
    redirect_to profile_url
  end

  def update_highschool_transcript
    current_student.highschool_transcript.attach(check_permit[:highschool_transcript])
    redirect_to documents_url
  end

  def update_grade_10_matric
    current_student.grade_10_matric.attach(check_permit[:grade_10_matric])
    redirect_to documents_url
  end

  def update_grade_12_matric
    current_student.grade_12_matric.attach(check_permit[:grade_12_matric])
    redirect_to documents_url
  end

  def update_coc
    current_student.coc.attach(check_permit[:coc])
    redirect_to documents_url
  end

  def update_diploma_certificate
    current_student.diploma_certificate.attach(check_permit[:diploma_certificate])
    redirect_to documents_url
  end

  def update_degree_certificate
    current_student.degree_certificate.attach(check_permit[:degree_certificate])
    redirect_to documents_url
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params.except("current_password"))
  end

  private

  def check_permit
    params.require(:student).permit(:highschool_transcript, :photo, :grade_10_matric, :grade_12_matric, :coc, :diploma_certificate, :degree_certificate)
  end

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up) do |student_params|
  #     student_params.permit(:original_degree_submission_date,:original_degree_status,:created_by,:last_updated_by,:photo,:email,:password,:password_confirmation,:first_name,:last_name,:middle_name,:gender,:student_id,:date_of_birth,:program_id,:department,:admission_type,:study_level,:marital_status,:year,:semester,:account_verification_status,:document_verification_status,:account_status,:graduation_status,student_address_attributes: [:id,:country,:city,:region,:zone,:sub_city,:house_number,:cell_phone,:house_phone,:pobox,:woreda,:created_by,:last_updated_by],emergency_contact_attributes: [:id,:full_name,:relationship,:cell_phone,:email,:current_occupation,:name_of_current_employer,:pobox,:email_of_employer,:office_phone_number,:created_by,:last_updated_by], documents: [])
  #   end
  #   devise_parameter_sanitizer.permit(:account_update) do |student_params|
  #     # student_params.permit(:original_degree_submission_date,:original_degree_status,:created_by,:last_updated_by,:photo,:email,:password,:password_confirmation,:first_name,:last_name,:middle_name,:gender,:student_id,:date_of_birth,:program_id,:department,:admission_type,:study_level,:marital_status,:year,:semester,:account_verification_status,:document_verification_status,:account_status,:graduation_status,student_address_attributes: [:id,:country,:city,:region,:zone,:sub_city,:house_number,:cell_phone,:house_phone,:pobox,:woreda,:created_by,:last_updated_by],emergency_contact_attributes: [:id,:full_name,:relationship,:cell_phone,:email,:current_occupation,:name_of_current_employer,:pobox,:email_of_employer,:office_phone_number,:created_by,:last_updated_by], documents: [])
  #   end
  #   devise_parameter_sanitizer.permit(:sign_in) do |student_params|
  #     student_params.permit(:email, :password)
  #   end
  # end
end

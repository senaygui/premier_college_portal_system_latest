ActiveAdmin.register EmergencyContact do
menu parent: "Student managment"
active_admin_import 

#validate: true,
 #                     headers_rewrites: { 'Email': :student_id },
  #                    before_batch_import: ->(importer) {
    #                    email = importer.values_at(:student_id)
                       # replacing author name with author id
   #                     students   = Student.where(email: email).pluck(:email, :id)
    #                    options = Hash[*students.flatten] # #{"Jane" => 2, "John" => 1}
     #                   importer.batch_replace(:student_id, options)
      #                }
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :student_id, :full_name, :relationship, :cell_phone, :email, :current_occupation, :name_of_current_employer, :pobox, :email_of_employer, :office_phone_number, :created_by, :last_updated_by
  #
  # or
  #
  # permit_params do
  #   permitted = [:student_id, :full_name, :relationship, :cell_phone, :email, :current_occupation, :name_of_current_employer, :pobox, :email_of_employer, :office_phone_number, :created_by, :last_updated_by]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end

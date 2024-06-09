ActiveAdmin.register StudentAddress do
menu parent: "Student managment"
 active_admin_import validate: true,
                      headers_rewrites: { 'Email': :student_id },
                      before_batch_import: ->(importer) {
                        emails = importer.values_at(:student_id)
                        # replacing author name with author id
                        students   = Student.where(email: emails).pluck(:email, :id)
                        options = Hash[*students.flatten] # #{"Jane" => 2, "John" => 1}
                        importer.batch_replace(:student_id, options)
                      }
 permit_params :special_location, :moblie_number, :telephone_number, :country, :student_id,:city,:region,:zone,:sub_city,:house_number,:cell_phone,:house_phone,:pobox,:woreda,:created_by,:last_updated_by,:created_at
  
end

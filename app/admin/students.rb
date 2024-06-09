ActiveAdmin.register Student do
  menu parent: "Student managment"
  # config.batch_actions = true
  permit_params :payment_version, :password_confirmation, :batch, :nationality, :undergraduate_transcript, :highschool_transcript,
                :grade_10_matric, :grade_12_matric, :coc, :diploma_certificate, :degree_certificate, :place_of_birth, :sponsorship_status, :entrance_exam_result_status, :student_id_taken_status, :old_id_number, :curriculum_version, :current_occupation, :tempo_status, :created_by, :last_updated_by, :photo, :email, :password, :first_name, :last_name, :middle_name, :gender, :student_id, :date_of_birth, :program_id, :department, :admission_type, :study_level, :marital_status, :year, :semester, :account_verification_status, :document_verification_status, :account_status, :graduation_status, student_address_attributes: %i[id country city region zone sub_city house_number special_location moblie_number telephone_number pobox woreda created_by last_updated_by], emergency_contact_attributes: %i[id full_name relationship cell_phone email current_occupation name_of_current_employer pobox email_of_employer office_phone_number created_by last_updated_by], school_or_university_information_attributes: %i[id level coc_attendance_date college_or_university phone_number address field_of_specialization cgpa last_attended_high_school school_address grade_10_result grade_10_exam_taken_year grade_12_exam_result grade_12_exam_taken_year created_by updated_by]

  active_admin_import validate: false,
                      before_batch_import: proc { |import|
                        import.csv_lines.length.times do |i|
                          import.csv_lines[i][1] =
                            Student.new(password: import.csv_lines[i][1]).encrypted_password
                        end
                      },
                      timestamps: true,
                      batch_size: 1000
  scoped_collection_action :scoped_collection_update, title: "Batch Approve", form: lambda {
                               {
                                                               document_verification_status: %w[pending approved denied incomplete],
                              
                                                             }
                             }
  batch_action "Approve document verification status for", method: :put, confirm: "Are you sure?" do |ids|
    Student.where(id: ids).update(document_verification_status: "approved")
    #  add_student_registration  
    redirect_to admin_students_path, notice: "#{"student".pluralize(ids.size)} document verification status Approved"
  end

  batch_action "Denie document verification status for", method: :put, confirm: "Are you sure?" do |ids|
    Student.where(id: ids).update(document_verification_status: "denied")
    redirect_to admin_students_path, notice: "#{"student".pluralize(ids.size)} document verification status denied"
  end
  batch_action "Incomplete document verification status for", method: :put, confirm: "Are you sure?" do |ids|
    Student.where(id: ids).update(document_verification_status: "incomplete")
    redirect_to admin_students_path, notice: "#{"student".pluralize(ids.size)} document verification status incompleted "
  end

  batch_action "Denie account verification status for", method: :put, confirm: "Are you sure?" do |ids|
    Student.where(id: ids).update(account_verification_status: "denied")
    redirect_to admin_students_path, notice: "#{"student".pluralize(ids.size)} account verification status denied"
  end
  batch_action "Approve account verification status for", method: :put, confirm: "Are you sure?" do |ids|
    Student.where(id: ids).update(account_verification_status: "approved")
    redirect_to admin_students_path, notice: "#{"student".pluralize(ids.size)} account verification status Approved"
  end
  batch_action "Incomplete account verification status for", method: :put, confirm: "Are you sure?" do |ids|
    Student.where(id: ids).update(account_verification_status: "incomplete")
    redirect_to admin_students_path, notice: "#{"student".pluralize(ids.size)} account verification status incompleted "
  end

  batch_action "Allow to edit their profile for", method: :put, confirm: "Are you sure?" do |ids|
    Student.where(id: ids).update(allow_editing: true)
    redirect_to admin_students_path, notice: "#{"student".pluralize(ids.size)} allowed to edit their profile"
  end

  batch_action "Denie to edit their profile for", method: :put, confirm: "Are you sure?" do |ids|
    Student.where(id: ids).update(allow_editing: false)
    redirect_to admin_students_path, notice: "#{"student".pluralize(ids.size)} denied to edit their profile"
  end

  controller do
    def update_resource(object, attributes)
      update_method = attributes.first[:password].present? ? :update : :update_without_password
      object.send(update_method, *attributes)
    end
  end

  index do
    selectable_column
    column :student_id
    column "Full Name", sortable: true do |n|
      "#{n.first_name.upcase} #{n.middle_name.upcase} #{n.last_name.upcase}"
    end
    column "Department", sortable: true do |d|
      link_to d.program.department.department_name, [:admin, d.program.department] if d.program.present?
    end
    column "Program", sortable: true do |d|
      if d.program.present?
        link_to d.program.program_name, [:admin, d.program]
      else
        link_to "Please add program type", edit_admin_student_path(d)
      end
    end
    column :study_level do |level|
      level.study_level.capitalize
    end
    column :admission_type do |type|
      type.admission_type.capitalize
    end
    # column :year
    column "Document Verification" do |s|
      status_tag s.document_verification_status
    end
    column "Account Verification" do |s|
      status_tag s.account_verification_status
    end
    column "Admission", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :student_id, label: "Student ID"
  filter :first_name
  filter :last_name
  filter :middle_name
  filter :gender
  filter :program_id, as: :search_select_filter, url: proc { admin_programs_path },
                      fields: %i[program_name id], display_name: "program_name", minimum_input_length: 2,
                      order_by: "id_asc"
  filter :study_level, as: :select, collection: %w[undergraduate graduate]
  filter :admission_type, as: :select, collection: %w[online regular extention distance]
  filter :department_id, as: :search_select_filter, url: proc { admin_departments_path },
                         fields: %i[department_name id], display_name: "department_name", minimum_input_length: 2,
                         order_by: "id_asc"
  filter :year
  filter :semester
  filter :batch
  filter :current_occupation
  filter :nationality

  filter :account_verification_status, as: :select, collection: %w[pending approved denied incomplete]
  filter :document_verification_status, as: :select, collection: %w[pending approved denied incomplete]
  filter :entrance_exam_result_status
  filter :account_status, as: :select, collection: %w[active suspended]
  filter :graduation_status
  filter :created_by
  filter :last_updated_by
  filter :created_at
  filter :updated_at

  # TODO: color label scopes
  scope :recently_added
  scope :pending
  scope :approved
  scope :denied
  scope :incomplete
  scope :undergraduate
  scope :graduate

  scope :online, if: proc { current_admin_user.role == "admin" }
  scope :regular, if: proc { current_admin_user.role == "admin" }
  scope :extention, if: proc { current_admin_user.role == "admin" }
  scope :distance, if: proc { current_admin_user.role == "admin" }

  form do |f|
    f.semantic_errors
    f.semantic_errors(*f.object.errors.attribute_names)
    # if f.object.errors.key?
    # if f.object.new_record? || current_admin_user.role == "registrar head"
    f.inputs "Student basic information" do
      div class: "avatar-upload" do
        div class: "avatar-edit" do
          f.input :photo, as: :file, label: "Upload Photo"
        end
        div class: "avatar-preview" do
          if f.object.photo.attached?
            image_tag(f.object.photo, resize: "100x100", class: "profile-user-img img-responsive img-circle",
                                      id: "imagePreview")
          else
            image_tag("blank-profile-picture-973460_640.png", class: "profile-user-img img-responsive img-circle",
                                                              id: "imagePreview")
          end
        end
      end
      f.input :first_name
      f.input :last_name
      f.input :middle_name
      f.input :gender, as: :select, collection: %w[Male Female], include_blank: false
      f.input :nationality, as: :country, selected: "ET", priority_countries: %w[ET US],
                            include_blank: "select country"
      f.input :date_of_birth, as: :date_time_picker
      f.input :place_of_birth
      f.input :marital_status, as: :select, collection: %w[Single Married Widowed Separated Divorced],
                               include_blank: false
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :semester
      f.input :year
      if f.object.new_record?
        f.input :created_by, as: :hidden, input_html: { value: current_admin_user.name.full }
        f.input :year, as: :hidden, input_html: { value: 1 }
        f.input :semester, as: :hidden, input_html: { value: 1 }
      else
        f.input :current_password
      end
      f.input :current_occupation
    end
    f.inputs "Student admission information" do
      f.input :study_level, as: :select, collection: %w[undergraduate graduate], include_blank: false
      f.input :admission_type, as: :select, collection: %w[online regular extention distance],
                               include_blank: false
      f.input :program_id, as: :search_select, url: admin_programs_path,
                           fields: %i[program_name id], display_name: "program_name", minimum_input_length: 2,
                           order_by: "id_asc"
    end
    f.inputs "Student address information",
             for: [:student_address, f.object.student_address || StudentAddress.new] do |a|
      a.input :country, as: :country, selected: "ET", priority_countries: %w[ET US],
                        include_blank: "select country"
      # TODO: add select list to city,sub_city,state,region,zone
      a.input :city
      a.input :sub_city
      a.input :region
      a.input :zone
      a.input :woreda
      a.input :house_number
      a.input :special_location
      a.input :moblie_number
      a.input :telephone_number
      a.input :pobox
    end
    f.inputs "Student emergency contact person information",
             for: [:emergency_contact, f.object.emergency_contact || EmergencyContact.new] do |a|
      a.input :full_name
      a.input :relationship, as: :select,
                             collection: ["Husband", "Wife", "Father", "Mother", "Legal guardian", "Son", "Daughter", "Brother", "Sister", "Friend", "Uncle", "Aunt", "Cousin", "Nephew", "Niece", "Grandparent"], include_blank: false
      a.input :cell_phone
      a.input :email
      a.input :current_occupation
      a.input :name_of_current_employer,
              hint: "current employer company name or person name of the student emergency contact person"
      a.input :email_of_employer,
              hint: "current employer company email or person email of the student emergency contact person"
      a.input :office_phone_number,
              hint: "current employer company phone number or person phone number of the student emergency contact person"
      a.input :pobox
    end
    f.inputs "School And University Information",
             for: [:school_or_university_information,
                   f.object.school_or_university_information || SchoolOrUniversityInformation.new] do |a|
      a.input :last_attended_high_school
      a.input :school_address
      a.input :grade_10_result
      a.input :grade_10_exam_taken_year, as: :date_time_picker
      a.input :grade_12_exam_result
      a.input :grade_12_exam_taken_year, as: :date_time_picker

      a.input :college_or_university, label: "Last college or university attended"
      a.input :phone_number
      a.input :address
      a.input :field_of_specialization
      a.input :level
      a.input :coc_attendance_date, as: :date_time_picker
      a.input :cgpa
    end

    f.inputs "Student Documents", multipart: true do
      f.input :highschool_transcript, as: :file, label: "Grade 9, 10, 11,and 12 transcripts"
      f.input :grade_10_matric, as: :file, label: "Grade 10 matric certificate"
      f.input :grade_12_matric, as: :file, label: "Grade 12 matric certificate"
      f.input :coc, as: :file, label: "Certificate of competency (COC)"
      f.input :diploma_certificate, as: :file, label: "TVET/Diploma certificate"
      f.input :degree_certificate, as: :file, label: "Undergraduate degree certificate"
      f.input :undergraduate_transcript, as: :file
      f.input :tempo_status
    end
    # end
    f.inputs "Student account and document verification" do
      f.input :curriculum_version
      f.input :account_verification_status, as: :select, collection: %w[pending approved denied incomplete],
                                            include_blank: false
      f.input :document_verification_status, as: :select,
                                             collection: %w[pending approved denied incomplete], include_blank: false
    end
    if !f.object.new_record? && !(params[:page_name] == "approval")
      f.inputs "Entrance Exam Result" do
        f.input :entrance_exam_result_status, as: :select, collection: %w[Pass Failed]
      end
      f.inputs "Student ID Information" do
        f.input :student_id_taken_status
        f.input :old_id_number
        f.input :student_id if current_admin_user.role == "registrar"
      end
      f.inputs "Student Account Status" do
        f.input :account_status, as: :select, collection: %w[active suspended]
      end
      f.input :last_updated_by, as: :hidden, input_html: { value: current_admin_user.name.full }
    end
    f.actions
  end

  action_item :edit, only: :show, priority: 0 do
    link_to "Approve Student", edit_admin_student_path(student.id, page_name: "approval")
  end

  show title: proc { |student|
    truncate("#{student.first_name.upcase} #{student.middle_name.upcase} #{student.last_name.upcase}",
             length: 50)
  } do
    tabs do
      tab "student General information" do
        columns do
          column do
            panel "Student Main information" do
              attributes_table_for student do
                row "photo" do |pt|
                  span image_tag(pt.photo, size: "150x150", class: "img-corner") if pt.photo.attached?
                end
                row "full name", sortable: true do |n|
                  "#{n.first_name.upcase} #{n.middle_name.upcase} #{n.last_name.upcase}"
                end
                row "Student ID" do |si|
                  si.student_id
                end
                row "Program" do |pr|
                  link_to pr.program.program_name, admin_program_path(pr.program.id)
                end
                row :curriculum_version
                row :payment_version
                row "Department" do |pr|
                  if pr.department.present?
                    link_to(pr.department.department_name,
                            admin_department_path(pr.department.id))
                  end
                end
                row :admission_type
                row :study_level
                row "Academic year" do |si|
                  if si.academic_calendar.present?
                    link_to(si.academic_calendar.calender_year_in_gc,
                            admin_academic_calendar_path(si.academic_calendar))
                  end
                end
                row :year
                row :semester
                row :batch
                row :account_verification_status do |s|
                  status_tag s.account_verification_status
                end
                row :entrance_exam_result_status
                row "admission Date" do |d|
                  d.created_at.strftime("%b %d, %Y")
                end
                row :student_id_taken_status
                row :old_id_number

                # row :graduation_status
              end
            end
          end
          column do
            panel "Basic information" do
              attributes_table_for student do
                row :email
                row :gender
                row :date_of_birth, sortable: true do |c|
                  c.date_of_birth.strftime("%b %d, %Y")
                end
                row :nationality
                row :place_of_birth
                row :marital_status
                row :current_occupation
                row :student_password
              end
            end
            panel "Account status information" do
              attributes_table_for student do
                row :account_verification_status do |s|
                  status_tag s.account_verification_status
                end
                row :document_verification_status do |s|
                  status_tag s.document_verification_status
                end
                row :account_status do |s|
                  status_tag s.account_status
                end
                row :sign_in_count, default: 0, null: false
                row :current_sign_in_at
                row :last_sign_in_at
                row :current_sign_in_ip
                row :last_sign_in_ip
                row :created_by
                row :last_updated_by
                row :created_at
                row :updated_at
              end
            end
          end
        end
      end
      tab "Student Documents " do
        columns do
          column do
            panel "High School Information" do
              attributes_table_for student.school_or_university_information do
                row :last_attended_high_school
                row :school_address
                row :grade_10_result
                row :grade_10_exam_taken_year
                row :grade_12_exam_result
                row :grade_12_exam_taken_year
              end
            end
          end
          column do
            panel "University/College Information" do
              attributes_table_for student.school_or_university_information do
                row :college_or_university
                row :phone_number
                row :address
                row :field_of_specialization
                row :level
                row :coc_attendance_date
                row :cgpa
              end
            end
          end
        end
        columns do
          column do
            panel "Highschool Transcript" do
              if student.highschool_transcript.attached?
                if student.highschool_transcript.variable?
                  div class: "preview-card text-center" do
                    span link_to image_tag(student.highschool_transcript, size: "200x270"), student.highschool_transcript
                  end
                elsif student.highschool_transcript.previewable?
                  div class: "preview-card text-center" do
                    span link_to "view document", rails_blob_path(student.highschool_transcript, disposition: "preview")
                    # span link_to image_tag(student.highschool_transcript.preview(resize: '200x200')), student.highschool_transcript
                  end
                else
                  # span link_to "view document", student.highschool_transcript.service_url
                  span link_to "view document", rails_blob_path(student.highschool_transcript, disposition: "preview")
                end
              else
                h3 class: "text-center no-recent-data" do
                  "Document Not Uploaded Yet"
                end
              end
            end
            panel "TVET/Diploma Certificate" do
              if student.diploma_certificate.attached?
                if student.diploma_certificate.variable?
                  div class: "preview-card text-center" do
                    span link_to image_tag(student.diploma_certificate, size: "200x270"), student.diploma_certificate
                  end
                elsif student.diploma_certificate.previewable?
                  div class: "preview-card text-center" do
                    span link_to "view document", rails_blob_path(student.diploma_certificate, disposition: "preview")
                    # span link_to image_tag(student.diploma_certificate.preview(resize: '200x200')), student.diploma_certificate
                  end
                else
                  span link_to "view document", rails_blob_path(student.diploma_certificate, disposition: "preview")
                end
              else
                h3 class: "text-center no-recent-data" do
                  "Document Not Uploaded Yet"
                end
              end
            end
          end
          column do
            panel "Grade 10 Matric Certificate" do
              if student.grade_10_matric.attached?
                if student.grade_10_matric.variable?
                  div class: "preview-card text-center" do
                    span link_to image_tag(student.grade_10_matric, size: "200x270"), student.grade_10_matric
                  end
                elsif student.grade_10_matric.previewable?
                  div class: "preview-card text-center" do
                    span link_to "view document", rails_blob_path(student.grade_10_matric, disposition: "preview")
                    # span link_to image_tag(student.grade_10_matric.preview(resize: '200x200')), student.grade_10_matric
                  end
                else
                  span link_to "view document", rails_blob_path(student.grade_10_matric, disposition: "preview")
                end
              else
                h3 class: "text-center no-recent-data" do
                  "Document Not Uploaded Yet"
                end
              end
            end
            panel "Certificate Of Competency(COC)" do
              if student.coc.attached?
                if student.coc.variable?
                  div class: "preview-card text-center" do
                    span link_to image_tag(student.coc, size: "200x270"), student.coc
                  end
                elsif student.coc.previewable?
                  div class: "preview-card text-center" do
                    span link_to "view document", rails_blob_path(student.coc, disposition: "preview")
                    # span link_to image_tag(student.coc.preview(resize: '200x200')), student.coc
                  end
                else
                  span link_to "view document", rails_blob_path(student.coc, disposition: "preview")
                end
              else
                h3 class: "text-center no-recent-data" do
                  "Document Not Uploaded Yet"
                end
              end
            end
          end
          column do
            panel "Grade 12 Matric Certificate" do
              if student.grade_12_matric.attached?
                if student.grade_12_matric.variable?
                  div class: "preview-card text-center" do
                    span link_to image_tag(student.grade_12_matric, size: "200x270"), student.grade_12_matric
                  end
                elsif student.grade_12_matric.previewable?
                  div class: "preview-card text-center" do
                    span link_to "view document", rails_blob_path(student.grade_12_matric, disposition: "preview")
                    # span link_to image_tag(student.grade_12_matric.preview(resize: '200x200')), student.grade_12_matric
                  end
                else
                  span link_to "view document", rails_blob_path(student.grade_12_matric, disposition: "preview")
                end
              else
                h3 class: "text-center no-recent-data" do
                  "Document Not Uploaded Yet"
                end
              end
            end
            panel "Undergraduate Degree Transcript" do
              if student.undergraduate_transcript.attached?
                if student.undergraduate_transcript.variable?
                  div class: "preview-card text-center" do
                    span link_to image_tag(student.undergraduate_transcript, size: "200x270"), student.undergraduate_transcript
                  end
                elsif student.undergraduate_transcript.previewable?
                  div class: "preview-card text-center" do
                    span link_to "view document", rails_blob_path(student.undergraduate_transcript, disposition: "preview")
                    # span link_to image_tag(student.undergraduate_transcript.preview(resize: '200x200')), student.undergraduate_transcript
                  end
                else
                  span link_to "view document", rails_blob_path(student.undergraduate_transcript, disposition: "preview")
                end
              else
                h3 class: "text-center no-recent-data" do
                  "Document Not Uploaded Yet"
                end
              end
            end
          end
          column do
            panel "Undergraduate Degree Certificate" do
              if student.degree_certificate.attached?
                if student.degree_certificate.variable?
                  div class: "preview-card text-center" do
                    span link_to image_tag(student.degree_certificate, size: "200x270"), student.degree_certificate
                  end
                elsif student.degree_certificate.previewable?
                  div class: "preview-card text-center" do
                    span link_to "view document", rails_blob_path(student.degree_certificate, disposition: "preview")
                    # span link_to image_tag(student.degree_certificate.preview(resize: '200x200')), student.degree_certificate
                  end
                else
                  span link_to "view document", rails_blob_path(student.degree_certificate, disposition: "preview")
                end

                div class: "text-center" do
                  span "Temporary Degree Status"
                  status_tag student.tempo_status
                end
              else
                h3 class: "text-center no-recent-data" do
                  "Not Uploaded Yet"
                end
              end
            end
          end
        end
      end
      tab "Student Address" do
        columns do
          column do
            panel "Student Address" do
              attributes_table_for student.student_address do
                row :country
                row :city
                row :region
                row :zone
                row :sub_city
                row :house_number
                row :special_location
                row :moblie_number
                row :telephone_number
                row :pobox
                row :woreda
              end
            end
          end
          column do
            panel "Student Emergency Contact information" do
              attributes_table_for student.emergency_contact do
                row :full_name
                row :relationship
                row :cell_phone
                row :email
                row :current_occupation
                row :name_of_current_employer
                row :email_of_employer
                row :office_phone_number
                row :pobox
              end
            end
          end
        end
      end
      tab "Student Course" do
        panel "Course list" do
          table_for student.student_courses.order("year ASC, semester ASC") do
            ## TODO: wordwrap titles and long texts
            column :course_title
            column :course_code
            column :credit_hour
            column :ects
            column :semester
            column :year
            column :letter_grade
            column :grade_point
          end
        end
      end
      tab "Grade Report" do
        panel "Grade Report", html: { loading: "lazy" } do
          table_for student.grade_reports.order("year ASC, semester ASC") do
            column "Academic Year", sortable: true do |n|
              link_to n.academic_calendar.calender_year_in_gc, admin_academic_calendar_path(n.academic_calendar)
            end
            column :year
            column :semester
            column "SGPA", :sgpa
            column "CGPA", :cgpa
            column :academic_status
            column "Issue Date", sortable: true do |c|
              c.created_at.strftime("%b %d, %Y")
            end
            column "Actions", sortable: true do |c|
              link_to "view", admin_grade_report_path(c.id)
            end
          end
        end
      end
    end
  end
end

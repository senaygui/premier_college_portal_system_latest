ActiveAdmin.register Transfer do
menu parent: "Add-ons",label: "Program Transfer"
  permit_params :student_id,:program_id,:new_program,:section_id,:department_id,:academic_calendar_id,:student_full_name,:id_number,:semester,:year,:new_department,:modality_transfer,:reason,:date_of_transfer,:formal_department_head,:formal_department_head_approval,:formal_department_head_approval_date,:remark,:new_department_head,:new_department_head_approval,:new_department_head_approval_date,:dean_name,:dean_approval,:dean_approval_date,:registrar_name,:registrar_approval,:registrar_approval_date,:created_by,:updated_by, course_exemptions_attributes: [:id,:course_id,:letter_grade,:credit_hour,:course_taken,:exemption_approval,:exemption_type,:transfer,:exemptible_type,:exemptible_id,:created_by,:updated_by, :_destroy]

  index do
    selectable_column
    column :student_name, sortable: true do |n|
      n.student_full_name
    end
    column :ID, sortable: true do |n|
      n.id_number
    end
    column "Academic Year", sortable: true do |n|
      link_to n.academic_calendar.calender_year_in_gc, admin_academic_calendar_path(n.academic_calendar)
    end
    column :year
    column :semester
    column "Program" do |pd|
      pd.program.program_name
    end
    column "Department" do |pd|
      pd.department.department_name
    end
    column :section do |pd|
      pd.section.section_short_name
    end
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end
  filter :student_id, as: :search_select_filter, url: proc { admin_students_path },
         fields: [:student_id, :id], display_name: 'student_id', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :department_id, as: :search_select_filter, url: proc { admin_departments_path },
         fields: [:department_name, :id], display_name: 'department_name', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :program_id, as: :search_select_filter, url: proc { admin_programs_path },
         fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :section_id, as: :search_select_filter, url: proc { admin_program_sections_path },
         fields: [:section_full_name, :id], display_name: 'section_full_name', minimum_input_length: 2,
         order_by: 'created_at_asc' 
  filter :academic_calendar_id, as: :search_select_filter, url: proc { admin_academic_calendars_path },
         fields: [:calender_year, :id], display_name: 'calender_year', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :year
  filter :semester
  filter :new_department
  filter :modality_transfer
  filter :reason
  filter :date_of_transfer
  filter :formal_department_head
  filter :formal_department_head_approval
  filter :formal_department_head_approval_date
  filter :remark
  filter :new_department_head
  filter :new_department_head_approval
  filter :new_department_head_approval_date
  filter :dean_name
  filter :dean_approval
  filter :dean_approval_date
  filter :registrar_name
  filter :registrar_approval
  filter :registrar_approval_date
  filter :created_at
  filter :updated_at
  filter :created_by
  filter :updated_by

  form do |f|
    f.semantic_errors
    if ((current_admin_user.role == "registrar head") || (current_admin_user.role == "admin"))
      columns do
        column do
          f.inputs "Student Information" do
              f.input :student_id, as: :search_select, url: admin_students_path,
              fields: [:student_id, :id], display_name: 'student_id', minimum_input_length: 2,
              order_by: 'id_asc'
              f.input :department_id, as: :search_select, url: admin_departments_path,
                  fields: [:department_name, :id], display_name: 'department_name', minimum_input_length: 2, order_by: 'id_asc'
              f.input :program_id, as: :search_select, url: admin_programs_path,
                    fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2, order_by: 'id_asc'
              f.input :section_id, as: :search_select, url: admin_program_sections_path,
                    fields: [:section_full_name, :id], display_name: 'section_full_name', minimum_input_length: 2, order_by: 'id_asc'
              f.input :academic_calendar_id, as: :search_select, url: admin_academic_calendars_path,
                  fields: [:calender_year, :id], display_name: 'calender_year', minimum_input_length: 2,order_by: 'id_asc'
              f.input :year
              f.input :semester
          end
        end
        column do
            f.inputs "Transfer Request" do
              f.input :modality_transfer , as: :select, :collection => ["Regular to Extention Program", "Extention to Regular Program", "Distance division to Regular Program", "Distance division to Extention Program"]
              f.input :new_department, as: :select, :collection => Department.all.pluck(:department_name)
              f.input :new_program, as: :select, :collection => Program.all.pluck(:program_name)
              f.input :reason, :input_html => { :class => 'autogrow', :rows => 12, :cols => 20, :maxlength => 250  }
              if f.object.new_record?
                f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
              else
                f.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full} 
              end
            end
        end
      end
    end
    if (params[:page_name] == "course_exemption") && ((current_admin_user.role == "registrar head") || (current_admin_user.role == "admin"))
      if f.object.course_exemptions.empty?
        f.object.course_exemptions << CourseExemption.new
      end
      panel "Course Exemptions" do
              f.has_many :course_exemptions, heading: " ",remote: true , allow_destroy: true, new_record: true do |a|
                a.input :course_taken
                a.input :letter_grade
                a.input :credit_hour
                a.input :course_id, as: :search_select, url: admin_courses_path,
                fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,order_by: 'id_asc'
                a.input :exemption_approval, as: :select, :collection => ["pending","approved", "denied"], :include_blank => false
                a.input :exemptible_type, as: :hidden, :input_html => { :value => "Transfer"} 
                a.input :exemption_type, as: :hidden, :input_html => { :value => "Transfer"} 
                if a.object.new_record?
                  a.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full} 
                else
                  a.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}      
                end  
                a.label :_destroy
              end
      end
    end
    if !f.object.new_record? && (params[:page_name] == "approve")
      f.inputs "Transfer Request Approval" do
        if (current_admin_user.role == "department head") || (current_admin_user.role == "admin")
            f.input :formal_department_head, as: :hidden, :input_html => { :value => current_admin_user.name.full}
            f.input :formal_department_head_approval, as: :select, :collection => ["pending","approved", "denied"], :include_blank => false
            f.input :formal_department_head_approval_date, as: :hidden, :input_html => { :value => Time.zone.now}
            f.input :remark
        end
        if (current_admin_user.role == "department head") || (current_admin_user.role == "admin")
            f.input :new_department_head, as: :hidden, :input_html => { :value => current_admin_user.name.full}
            f.input :new_department_head_approval, as: :select, :collection => ["pending","approved", "denied"], :include_blank => false
            f.input :new_department_head_approval_date, as: :hidden, :input_html => { :value => Time.zone.now}
        end
        if (current_admin_user.role == "dean") || (current_admin_user.role == "admin")
            f.input :dean_approval, as: :select, :collection => ["pending","approved", "denied"], :include_blank => false
            f.input :dean_name, as: :hidden, :input_html => { :value => current_admin_user.name.full}
            f.input :dean_approval_date, as: :hidden, :input_html => { :value => Time.zone.now}
        end
        if (current_admin_user.role == "registrar head") || (current_admin_user.role == "admin")
            f.input :registrar_approval, as: :select, :collection => ["pending","approved", "denied"], :include_blank => false
            f.input :registrar_name, as: :hidden, :input_html => { :value => current_admin_user.name.full}
            f.input :registrar_approval_date, as: :hidden, :input_html => { :value => Time.zone.now}
        end
        if (transfer.registrar_approval == "approved") && (!f.date_of_transfer.present?)
          f.input :date_of_transfer, as: :hidden, :input_html => { :value => Time.zone.now}
        end
        f.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full} 
      end  
    end 
    f.actions
  end

  action_item :edit, only: :show, priority: 1  do
    if (current_admin_user.role == "registrar head") || (current_admin_user.role == "admin")
      link_to 'Add Course Exemptions', edit_admin_transfer_path(transfer.id, page_name: "course_exemption")
    end
  end
  action_item :edit, only: :show, priority: 1  do
    if (current_admin_user.role == "dean") || (current_admin_user.role == "department head") || (current_admin_user.role == "registrar head") || (current_admin_user.role == "admin")
      link_to 'Approve Transfer', edit_admin_transfer_path(transfer.id, page_name: "approve")
    end
  end

  show :title => proc{|transfer| truncate("#{transfer.student.first_name.upcase} #{transfer.student.middle_name.upcase} #{transfer.student.last_name.upcase}", length: 50) } do
    columns do
      column do
        panel "Student information" do
          attributes_table_for transfer do
            row :student_name, sortable: true do |n|
              "#{n.student.first_name.upcase} #{n.student.middle_name.upcase} #{n.student.last_name.upcase}"
            end
            row :ID, sortable: true do |n|
              n.student.student_id
            end
            row "Faculty" do |pd|
              pd.department.faculty.faculty_name
            end
            row "Department" do |pd|
              pd.department.department_name
            end
            row "Program" do |pd|
              pd.program.program_name
            end
            row :admission_type do |pd|
              pd.program.admission_type
            end
            row :study_level do |pd|
              pd.program.study_level
            end
            row "Academic Year", sortable: true do |n|
              link_to n.academic_calendar.calender_year, admin_academic_calendar_path(n.academic_calendar)
            end
            row :year
            row :semester
            row "Section" do |pd|
              pd.section.section_short_name
            end
          end
        end
      end
      column do
        panel "Transfer Request information" do
          attributes_table_for transfer do
            
            row :new_department
            row :new_program
            row :modality_transfer
            row :reason
            row :date_of_transfer
            row :created_by
            row :updated_by
            row :created_at
            row :updated_at
          end
        end
      end
      column do
        panel "Transfer Request Approval Status" do
          attributes_table_for transfer do
            row :formal_department_head
            row :formal_department_head_approval_date
            row :formal_department_head_approval do |c|
              status_tag c.formal_department_head_approval
            end

            row :new_department_head
            row :new_department_head_approval_date
            row :new_department_head_approval do |c|
              status_tag c.new_department_head_approval
            end

            row :dean_name
            row :dean_approval_date
            row :dean_approval do |c|
              status_tag c.dean_approval
            end
            
            row :registrar_name
            row :registrar_approval_date
            row :registrar_approval do |c|
              status_tag c.registrar_approval
            end
            
          end
        end
      end
    end
  end
end

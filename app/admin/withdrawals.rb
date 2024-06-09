ActiveAdmin.register Withdrawal do
  menu parent: "Add-ons", label: "Clearance/Withdrawal"
  permit_params :program_id,:department_id,:student_id,:section_id,:academic_calendar_id,:student_id_number,:semester,:year,:fee_status,:reason_for_withdrawal,:last_class_attended,:finance_head_approval,:finance_head_name,:finance_head_date_of_response,:registrar_approval,:registrar_name,:registrar_date_of_response,:dean_approval,:dean_name,:dean_date_of_response,:department_approval,:department_head_name,:department_head_date_of_response,:library_head_approval,:library_head_name,:library_head_date_of_response,:store_head_approval,:store_head_name,:store_head_date_of_response,:created_by,:updated_by

  index do
    selectable_column
    column :student_name, sortable: true do |n|
      "#{n.student.first_name.upcase} #{n.student.middle_name.upcase} #{n.student.last_name.upcase}"
    end
    column :ID, sortable: true do |n|
      n.student.student_id
    end
    column "Academic Year", sortable: true do |n|
      link_to n.academic_calendar.calender_year, admin_academic_calendar_path(n.academic_calendar)
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
  
  filter :last_class_attended   
  filter :fee_status    

  filter :finance_head_approval
  filter :registrar_approval
  filter :dean_approval
  filter :department_approval
  filter :library_head_approval
  filter :store_head_approval
  
  filter :created_at
  filter :updated_at

  filter :created_by
  filter :updated_by

  form do |f|
    f.semantic_errors
    f.inputs "Clearance/Withdrawal Request" do
      if f.object.new_record? && ((current_admin_user.role == "registrar head") || (current_admin_user.role == "admin"))
        f.input :student_id, as: :search_select, url: admin_students_path,
          fields: [:student_id, :id], display_name: 'student_id', minimum_input_length: 2,
          order_by: 'id_asc'
        f.input :department_id, as: :search_select, url: admin_departments_path,
          fields: [:department_name, :id], display_name: 'department_name', minimum_input_length: 2,
          order_by: 'id_asc'
        f.input :program_id, as: :search_select, url: admin_programs_path,
            fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
            order_by: 'id_asc'
        f.input :section_id, as: :search_select, url: admin_program_sections_path,
            fields: [:section_full_name, :id], display_name: 'section_full_name', minimum_input_length: 2,
            order_by: 'id_asc'
        f.input :academic_calendar_id, as: :search_select, url: admin_academic_calendars_path,
          fields: [:calender_year, :id], display_name: 'calender_year', minimum_input_length: 2,
          order_by: 'id_asc'
        f.input :year
        f.input :semester
        f.input :last_class_attended, as: :date_time_picker 
        f.input :fee_status , as: :select, :collection => ["Deferred", "100% fee payer", "50% fee payer"], :include_blank => false
        f.input :reason_for_withdrawal , as: :select, :collection => ["Graduating Student","Academic Dismissal","Medical Case","Disciplinary Case","Transfer to other Institution","Personal Problem","Financial Problem"], :include_blank => false
        f.input :other_reason
      end
      if !f.object.new_record?
        if (current_admin_user.role == "department head") || (current_admin_user.role == "admin")
          f.input :department_approval, as: :select, :collection => ["pending","approved", "denied"], :include_blank => false
          f.input :department_head_name, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          f.input :department_head_date_of_response, as: :hidden, :input_html => { :value => Time.zone.now}
        end
        if (current_admin_user.role == "registrar head") || (current_admin_user.role == "admin")
          f.input :registrar_approval, as: :select, :collection => ["pending","approved", "denied"], :include_blank => false
          f.input :registrar_name, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          f.input :registrar_date_of_response, as: :hidden, :input_html => { :value => Time.zone.now}
        end
        if (current_admin_user.role == "dean") || (current_admin_user.role == "admin")
          f.input :dean_approval, as: :select, :collection => ["pending","approved", "denied"], :include_blank => false
          f.input :dean_name, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          f.input :dean_date_of_response, as: :hidden, :input_html => { :value => Time.zone.now}
        end
        if (current_admin_user.role == "finance head") || (current_admin_user.role == "admin")
          f.input :finance_head_approval, as: :select, :collection => ["pending","approved", "denied"], :include_blank => false
          f.input :finance_head_name, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          f.input :finance_head_date_of_response, as: :hidden, :input_html => { :value => Time.zone.now}
        end 
        if (current_admin_user.role == "library head") || (current_admin_user.role == "admin")
          f.input :library_head_approval, as: :select, :collection => ["pending","approved", "denied"], :include_blank => false
          f.input :library_head_name, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          f.input :library_head_date_of_response, as: :hidden, :input_html => { :value => Time.zone.now}
          # f.input :add_mark, lebel: "Mark Added"
        end  
        if (current_admin_user.role == "store head") || (current_admin_user.role == "admin")
          f.input :store_head_approval, as: :select, :collection => ["pending","approved", "denied"], :include_blank => false
          f.input :store_head_name, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          f.input :store_head_date_of_response, as: :hidden, :input_html => { :value => Time.zone.now}
        end  
      end 
      if f.object.new_record?
        f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      else
        f.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full} 
      end 
    end
    f.actions
  end

  show :title => proc{|withdrawal| truncate("#{withdrawal.student.first_name.upcase} #{withdrawal.student.middle_name.upcase} #{withdrawal.student.last_name.upcase}", length: 50) } do
    columns do
      column do
        panel "Student information" do
          attributes_table_for withdrawal do
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
        panel "Withdrawal Request information" do
          attributes_table_for withdrawal do
            
            row :last_class_attended
            row :fee_status
            row :reason_for_withdrawal
            row :other_reason
            row :created_by
            row :updated_by
            row :created_at
            row :updated_at
          end
        end
      end
      column do
        panel "Withdrawal Request Approval Status" do
          attributes_table_for withdrawal do
            row :dean_name
            row :dean_date_of_response
            row :dean_approval do |c|
              status_tag c.dean_approval
            end

            row :library_head_name
            row :library_head_date_of_response
            row :library_head_approval do |c|
              status_tag c.library_head_approval
            end

            row :finance_head_name
            row :finance_head_approval
            row :finance_head_approval do |c|
              status_tag c.finance_head_approval
            end

            row :store_head_name
            row :store_head_date_of_response
            row :store_head_approval do |c|
              status_tag c.store_head_approval
            end
            
            row :department_head_name
            row :department_head_date_of_response
            row :department_approval do |c|
              status_tag c.department_approval
            end
            
            row :registrar_name
            row :registrar_date_of_response
            row :registrar_approval do |c|
              status_tag c.registrar_approval
            end
            
          end
        end
      end
    end
    
    # panel "grade Information" do
    #   table_for grade_rule.grades do
    #     column :grade
    #     column :min_value
    #     column :max_value
    #     column :grade_value
    #   end
    # end
  end

  
end

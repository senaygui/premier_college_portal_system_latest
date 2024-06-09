ActiveAdmin.register AddAndDrop do
  menu parent: "Add-ons",label: "Add/Drops"

  permit_params :student_id,:academic_calendar_id,:semester_registration_id,:department_id,:program_id,:section_id,:semester,:year,:registrar_approval,:registrar_name,:registrar_date_of_response,:advisor_approval,:advisor_name,:advisor_date_of_response,:created_by,:updated_by, add_and_drop_courses_attributes: [:id,:add_and_drop_id,:course_id,:add_or_drop,:advisor_approval,:advisor_name,:advisor_date_of_response,:created_by,:updated_by, :_destroy]

  index do
    selectable_column
    column :student_name, sortable: true do |n|
      n.student_full_name
    end
    column :ID, sortable: true do |n|
      n.student.student_id
    end
    column "Academic Year", sortable: true do |n|
      link_to n.academic_calendar.calender_year, admin_academic_calendar_path(n.academic_calendar)
    end
    column :year
    column :semester
    column :section do |pd|
      pd.section.section_short_name
    end
    column "Program" do |pd|
      pd.program.program_name
    end
    column "Department" do |pd|
      pd.department.department_name
    end
    
    column "Registrar Approval" do |pd|
      status_tag pd.registrar_approval
    end
    
    column "Advisor Approval" do |pd|
      status_tag pd.advisor_approval
    end
    column "Status" do |pd|
      status_tag pd.status
    end
    
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end


  filter :student_id, as: :search_select_filter, url: proc { admin_students_path },
         fields: [:student_id, :id], display_name: 'student_id', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :student_full_name
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
  filter :registrar_approval
  filter :registrar_name
  filter :registrar_date_of_response
  filter :advisor_approval
  filter :advisor_name
  filter :advisor_date_of_response
  filter :status
  filter :created_at
  filter :updated_at

  filter :created_by
  filter :updated_by

  scope :recently_added
  
  scope :pending, if: -> { current_admin_user.role != "registrar head" } 
  scope :approved, if: -> { current_admin_user.role != "registrar head" } 
  scope :denied, if: -> { current_admin_user.role != "registrar head" } 
  scope :registrar_pending, if: -> { current_admin_user.role == "registrar head" } 
  scope :registrar_approved, if: -> { current_admin_user.role == "registrar head" } 
  scope :registrar_denied, if: -> { current_admin_user.role == "registrar head" } 

  form do |f|
    f.semantic_errors
    if f.object.new_record? && ((current_admin_user.role == "registrar head") || (current_admin_user.role == "admin"))
      f.inputs "Add/Drop Form" do
        f.input :student_id, as: :search_select, url: admin_students_path,
          fields: [:student_id, :id], display_name: 'student_id', minimum_input_length: 2,
          order_by: 'id_asc'
        # f.input :department_id, as: :search_select, url: admin_departments_path,
        #   fields: [:department_name, :id], display_name: 'department_name', minimum_input_length: 2, order_by: 'id_asc'
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
        if f.object.new_record?
          f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
        else
          f.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
        end
      end
      if f.object.add_and_drop_courses.empty?
        f.object.add_and_drop_courses << AddAndDropCourse.new
      end
      panel "Courses to add or drop" do
        f.has_many :add_and_drop_courses, heading: " ",remote: true , allow_destroy: true, new_record: true do |a|
              a.input :course_id, as: :search_select, url: admin_courses_path,
                  fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,
                  order_by: 'id_asc'
              a.input :add_or_drop, as: :select, :collection => ["Add Course", "Drop Course"], :include_blank => false
              
              if a.object.new_record?
                a.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full} 
              else
                a.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}      
              end  
              a.label :_destroy
        end
      end 
    elsif !f.object.new_record? && ((current_admin_user.role == "registrar head") || (current_admin_user.role == "admin")) && (add_and_drop.created_by != "self") && (params[:page_name] != "advisor_approve")
      f.inputs "Add/Drop Form" do
        f.input :student_id, as: :search_select, url: admin_students_path,
          fields: [:student_id, :id], display_name: 'student_id', minimum_input_length: 2,
          order_by: 'id_asc'
        # f.input :department_id, as: :search_select, url: admin_departments_path,
        #   fields: [:department_name, :id], display_name: 'department_name', minimum_input_length: 2, order_by: 'id_asc'
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
        if f.object.new_record?
          f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
        else
          f.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
        end
      end
      if f.object.add_and_drop_courses.empty?
        f.object.add_and_drop_courses << AddAndDropCourse.new
      end
      panel "Courses to add or drop" do
        f.has_many :add_and_drop_courses, heading: " ",remote: true , allow_destroy: true, new_record: true do |a|
              a.input :course_id, as: :search_select, url: admin_courses_path,
                  fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,
                  order_by: 'id_asc'
              a.input :add_or_drop, as: :select, :collection => ["Add Course", "Drop Course"], :include_blank => false
              
              if a.object.new_record?
                a.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full} 
              else
                a.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}      
              end  
              a.label :_destroy
        end
      end         
    end

    if !f.object.new_record?
      if (params[:page_name] == "advisor_approve") || ((current_admin_user.role == "department head") || (current_admin_user.role == "admin"))
        panel "Courses to add or drop" do
          table(class: 'form-table') do
            tr do
              th 'Course Title', class: 'form-table__col'
              th 'Add/Drop', class: 'form-table__col'
              th 'Advisor Approval Status', class: 'form-table__col'
            end
            f.semantic_fields_for :add_and_drop_courses, f.object.add_and_drop_courses do |d|
              render 'form', d: d
            end
          end
        end
        f.inputs "Advisor Approval" do
          
          f.input :advisor_approval, as: :select, :collection => ["pending","approved", "denied"], :include_blank => false
          f.input :advisor_name, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          f.input :advisor_date_of_response, as: :hidden, :input_html => { :value => Time.zone.now}
        end
      end
      if (params[:page_name] == "registrar_approve") && ((current_admin_user.role == "registrar head") || (current_admin_user.role == "admin"))
        f.inputs "Registrar Approval" do
          f.input :registrar_approval, as: :select, :collection => ["pending","approved", "denied"], :include_blank => false
          f.input :registrar_name, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          f.input :registrar_date_of_response, as: :hidden, :input_html => { :value => Time.zone.now}
        end
      end
    end 
    f.actions
  end

  action_item :edit, only: :show, priority: 1  do
    if (current_admin_user.role == "department head") || (current_admin_user.role == "admin")
      link_to 'Advisor Approval', edit_admin_add_and_drop_path(add_and_drop.id, page_name: "advisor_approve")
    end
  end
  action_item :edit, only: :show, priority: 1  do
    if (current_admin_user.role == "registrar head") || (current_admin_user.role == "admin")
      link_to 'Registrar Approval', edit_admin_add_and_drop_path(add_and_drop.id, page_name: "registrar_approve")
    end
  end

  show :title => proc{|add_and_drop| truncate("#{add_and_drop.student.first_name.upcase} #{add_and_drop.student.middle_name.upcase} #{add_and_drop.student.last_name.upcase}", length: 50) } do
    columns do
      column max_width: "30%" do
        panel "Student information" do
          attributes_table_for add_and_drop do
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
            
            row "Academic Year", sortable: true do |n|
              link_to n.academic_calendar.calender_year, admin_academic_calendar_path(n.academic_calendar)
            end
            row :year
            row :semester
            row "Section" do |pd|
              pd.section.section_short_name
            end
            row :admission_type do |pd|
              pd.program.admission_type
            end
            row :study_level do |pd|
              pd.program.study_level
            end
            row "Add/Drop Status" do |pd|
              status_tag pd.status
            end
            row :created_by
            row :updated_by
            row :created_at
            row :updated_at
          end
        end
      end

      column min_width: "67%" do
        panel "Add And Drop Course Request information" do
          table_for add_and_drop.add_and_drop_courses do
            column "Course title" do |pr|
              link_to pr.course.course_title, admin_course_path(pr.course)
            end
            column "CR. HR" do |pr|
              pr.course.credit_hour
            end
            column "Contact HR" do |pr|
              pr.course.lecture_hour
            end
            column "course code" do |item|
              item.course.course_code
            end
            column "add/drop",:add_or_drop
            column :advisor_name
            # column "RESPONDED DATE",:advisor_date_of_response
            column "status" do |c|
              status_tag c.advisor_approval
            end
          end
        end
        panel "Add And Drop Request Approval Status" do
          columns do
            column do
              table(class: 'form-table') do
                tr do
                  th 'Advisor Information',colspan: "2", class: 'form-table__col'
                end
                tr class: "form-table__row" do
                  th 'Advisor Name', class: 'form-table__col'
                  td add_and_drop.advisor_name, class: 'form-table__col'
                end
                tr class: "form-table__row" do
                  th 'Approval Status', class: 'form-table__col'
                  td class: 'form-table__col' do
                    status_tag add_and_drop.advisor_approval
                  end
                end
                tr class: "form-table__row" do
                  th 'Responded At', class: 'form-table__col'
                  td "#{add_and_drop.advisor_date_of_response.strftime("%b %d, %Y") if add_and_drop.advisor_date_of_response.present?}", class: 'form-table__col'
                end
              end
            end
            column do
              table(class: 'form-table') do
                tr do
                  th 'Registrar Information',colspan: "2", class: 'form-table__col'
                end
                tr class: "form-table__row" do
                  th 'Registrar Name', class: 'form-table__col'
                  td add_and_drop.registrar_name, class: 'form-table__col'
                end
                tr class: "form-table__row" do
                  th 'Approval Status', class: 'form-table__col'
                  td class: 'form-table__col' do
                    status_tag add_and_drop.registrar_approval
                  end
                end
                tr class: "form-table__row" do
                  th 'Responded At', class: 'form-table__col'
                  td "#{add_and_drop.registrar_date_of_response.strftime("%b %d, %Y") if add_and_drop.registrar_date_of_response.present?}", class: 'form-table__col'
                end
              end
            end
          end
        end
      end
    end
  end 
end

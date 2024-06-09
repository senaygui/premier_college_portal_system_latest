ActiveAdmin.register Section , as: "ProgramSection"do
permit_params :program_id, :section_short_name ,:section_full_name, :total_capacity,:semester,:year,:created_by,:updated_by
menu parent: "Program"
  index do
    selectable_column
    column :section_short_name
    column :section_full_name
    column "Program" do |pr|
      link_to pr.program.program_name, admin_program_path(pr.program.id)
    end
    column :semester
    column :year
    
    column :total_capacity
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end 

  filter :program_id, as: :search_select_filter, url: proc { admin_programs_path },fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,order_by: 'id_asc'
  filter :section_short_name
  filter :section_full_name
  filter :semester
  filter :year
  filter :total_capacity
  filter :updated_by
  filter :created_by
  filter :created_at
  filter :updated_at

  form do |f|
    f.semantic_errors
    f.inputs "Section information" do
      f.input :program_id, as: :search_select, url: admin_programs_path,
              fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,lebel: "attendance title",
              order_by: 'created_at_asc'
      f.input :section_short_name
      f.input :section_full_name
      f.input :total_capacity
      f.input :year
      f.input :semester
      if f.object.new_record?
        f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      else
        f.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      end 
    end
    f.actions
  end

  show title: :section_short_name do
    columns do
      column do
        panel "Section information" do
          attributes_table_for program_section do
            row "Program" do |pr|
              link_to pr.program.program_name, admin_program_path(pr.program.id)
            end
            row :section_short_name
            row :section_full_name
            row :year
            row :semester
            row :total_capacity
            row :created_by
            row :updated_by
            row :created_at
            row :updated_at
          end
        end

        panel "Currently registered students" do
          table_for program_section.semester_registrations.where(academic_calendar_id: current_academic_calendar(program_section.program.study_level, program_section.program.admission_type)) do
            column "Student Full Name" do |n|
              link_to n.student_full_name, admin_student_path(n.student)
            end
            column "Student ID" do |n|
              n.student.student_id
            end
            column "Academic calendar" do |n|
              n.academic_calendar.calender_year
            end
            column "Year" do |n|
              n.year
            end
            column "Semester" do |n|
              n.semester
            end
            column "ccc" do |n|
              current_academic_calendar(program_section.program.study_level, program_section.program.admission_type)
            end
            #TODO: add a remove btn first create a member action the delete section id from course registration
            # column "Remove" do |n|
            #   link_to 'Destroy', admin_course_registrations_path(n), data: {:confirm => 'Are you sure?'}, :method => :delete 
            # end
          end
        end

      end
      column do
        panel "Section report" do
          table(class: 'form-table') do
            tr do
              th 'Academic calendar', class: 'form-table__col'
              th 'Registered Students', class: 'form-table__col'
              th 'Semester', class: 'form-table__col'
              th 'Asign section', class: 'form-table__col'
            end
            
            AcademicCalendar.where(study_level: program_section.program.study_level, admission_type: program_section.program.admission_type).map do |item|
              (1..program_section.program.program_semester).map do |ps|
                tr class: "form-table__row" do
                  
                  th class: 'form-table__col' do 
                    link_to item.calender_year, admin_semester_registrations_path(:q => { :program_id_eq => "#{program_section.program.id}", academic_calendar_id_eq: item.id })
                  end
                  th class: 'form-table__col' do 
                    program_section.semester_registrations.where(academic_calendar_id: item.id, semester: ps).count
                  end
                  th class: 'form-table__col' do 
                    ps
                  end
                  th class: 'form-table__col' do 
                    link_to "Asign", admin_semester_registrations_path(:q => { :program_id_eq => "#{program_section.program.id}", academic_calendar_id_eq: item.id, registrar_approval_status_eq: "approved", semester_eq: ps})
                  end
                end
              end
            end
          end
        end 
      end 
    end
  end
  
end

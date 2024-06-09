ActiveAdmin.register Session do
  # before_action :left_sidebar!, collapsed: true
menu parent: "Attendance"
   permit_params :academic_calendar_id,:semester,:year,:attendance_id,:starting_date,:ending_date,:session_title,:created_by,:updated_by,student_attendances_attributes: [:id,:student_id,:course_registration_id,:present,:absent,:remark,:created_by,:updated_by, :_destroy]

  index do
    selectable_column
    
    column :session_title
    column :attendance_title do |pd|
      pd.attendance.attendance_title
    end
    column :program do |pd|
      pd.attendance.program.program_name
    end
    column :course do |pd|
      pd.attendance.course_title
    end
    column "Academic Year", sortable: true do |n|
      link_to n.academic_calendar.calender_year, admin_academic_calendar_path(n.academic_calendar)
    end
    column "Session Date", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end 

  form do |f|
    f.semantic_errors
    if !(params[:page_name] == "add") 
      f.inputs "Session information" do
        f.input :session_title
        f.input :starting_date, as: :date_time_picker 
        f.input :ending_date, as: :date_time_picker 
        f.input :attendance_id, as: :search_select, url: admin_attendances_path,
              fields: [:attendance_title, :id], display_name: 'attendance_title', minimum_input_length: 2,lebel: "attendance title",
              order_by: 'id_asc'

        if f.object.new_record?
          f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
        else
          f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
        end 
      end
    end

    if (params[:page_name] == "add") 
      inputs 'Student Attendances' do
        table(class: 'form-table') do
          tr do
            th 'Student', class: 'form-table__col'
            th 'present', class: 'form-table__col'
            th 'absent', class: 'form-table__col'
            th 'remark', class: 'form-table__col'
            if !(current_admin_user.role == "instructor")
              th 'destroy', class: 'form-table__col'
            end
          end
          f.semantic_fields_for :student_attendances, f.object.student_attendances do |r|
            render 'rate', r: r
          end
        end
      end
    end
    f.actions
  end

  action_item :edit, only: :show, priority: 0 do
    link_to 'Take Attendance', edit_admin_session_path(session.id, page_name: "add")
  end
  action_item :edit, only: :show, priority: 0 do
    button_tag 'Print Attendance Sheet',onClick: "window.print()", class: "print-button"
  end

  show title: :session_title do
    tabs do
      tab "Attendance Session Information" do
        columns do
          column max_width: "37%" do
            panel "Attendance Session Details" do
              attributes_table_for session do
                row :session_title
                row :attendance_title do |pr|
                  pr.attendance.attendance_title
                end
                row :program do |pr|
                  pr.attendance.program.program_name
                end
                row :course do |pr|
                  pr.attendance.course_title
                end
                row :section do |pr|
                  pr.attendance.section.section_short_name
                end
                row :starting_date
                row :ending_date
                row :created_by
                row :updated_by
                row :created_at
                row :updated_at
              end
            end
          end
          column min_width: "60%" do
            panel "Attendance Session" do
              table_for session.student_attendances do
                column "student",:student_full_name
                column "Sex" do |d|
                  d.student.gender
                end
                column "Student ID" do |d|
                  d.student.student_id
                end
                column :present
                column :absent
                column :remark
              end
            end 
          end 
        end
      end
    end
    
  end
end

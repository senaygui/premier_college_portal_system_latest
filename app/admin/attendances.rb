ActiveAdmin.register Attendance do
menu parent: "Attendance"
  permit_params :program_id,:section_id,:academic_calendar_id,:course_title,:attendance_title,:year,:semester,:created_by,:updated_by,:course_id,sessions_attributes: [:id,:attendance_id,:starting_date,:ending_date,:academic_calendar_id,:semester,:year,:session_title,:created_by,:updated_by, :_destroy]

  index do
    selectable_column
    
    column :attendance_title
    column :course_title
    column "Program" do |pd|
      pd.program.program_name
    end
    column "academic year", sortable: true do |n|
      link_to n.academic_calendar.calender_year, admin_academic_calendar_path(n.academic_calendar)
    end
    column :year
    column :semester
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end 

  form do |f|
    f.semantic_errors
    if !(params[:page_name] == "add") && !(current_admin_user.role == "instructor")
      f.inputs "Attendance information" do
        f.input :attendance_title
        
        f.input :course_id, as: :search_select, url: admin_courses_path,
              fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,lebel: "course title",
              order_by: 'id_asc'
        f.input :section_id, as: :search_select, url: admin_program_sections_path,
              fields: [:section_full_name, :id], display_name: 'section_full_name', minimum_input_length: 2,
              order_by: 'id_asc'
        f.input :academic_calendar_id, as: :search_select, url: admin_academic_calendars_path,
              fields: [:calender_year, :id], display_name: 'calender_year', minimum_input_length: 2,
              order_by: 'id_asc'
        f.input :year
        f.input :semester
        f.input :created_at, as: :date_time_picker
        if f.object.new_record?
          f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
        else
          f.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
        end
      end
    else
      if f.object.sessions.empty?
        f.object.sessions << Session.new
      end
      panel "Session Information" do
        f.has_many :sessions,heading: " ", remote: true, allow_destroy: true, new_record: true do |a|
          # a.input :attendance_id, as: :search_select, url: admin_attendances_path,
          # fields: [:attendance_title, :id], display_name: 'attendance_title', minimum_input_length: 2,
          # order_by: 'id_asc'
          a.input :session_title
          a.input :starting_date, as: :date_time_picker 
          a.input :ending_date, as: :date_time_picker 
          # a.input :session_title
          
          if a.object.new_record?
            a.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          else
            a.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          end 
          a.label :_destroy
        end
      end
    end
    f.actions
  end

  action_item :edit, only: :show, priority: 0 do
    link_to 'Add Session', edit_admin_attendance_path(attendance.id, page_name: "add")
  end

  show title: :attendance_title do
    tabs do
      tab "Attendance Information" do
        columns do
          column max_width: "37%" do
            panel "Attendance information" do
              attributes_table_for attendance do
                row :attendance_title
                row :program do |pr|
                  pr.program.program_name
                end
                row :course_title
                row :section do |pr|
                  pr.section.section_short_name
                end
                row :academic_calendar do |pr|
                  pr.academic_calendar.calender_year
                end
                row :year
                row :semester
                row :created_by
                row :updated_by
                row :created_at
                row :updated_at
              end
            end
          end
          column min_width: "60%" do
            panel "Attendance Session" do
              table_for attendance.sessions do
                column :session_title
                column :starting_date
                column :ending_date
                column :created_at
                column "links" do |c|
                  "#{link_to("Take Attendance", edit_admin_session_path(c, page_name: "add"))}".html_safe
                end
              end
            end 
          end 
        end
      end
      tab "Student List" do
        panel "Student List" do
          table_for attendance.section.course_registrations.where(academic_calendar_id: attendance.academic_calendar, course_id: attendance.course ) do
            column :student_full_name
            column "STUDENT ID" do |s|
              s.student.student_id
            end
            column :section do |sec|
              sec.section.section_short_name
            end
            column :total_session do |section|
              attendance.sessions.count
            end
            column :total_present_days do |section|
              attendance.sessions.map {|session| session.student_attendances.where(student_id: section.student, present: true).count}.sum
              # section.student.student_attendances.where(present: true).count
            end
            column :total_absent_days do |section|
              attendance.sessions.map {|session| session.student_attendances.where(student_id: section.student, absent: true).count}.sum
            end
            # column :avg_present_days do |section|
            #   span ((attendance.sessions.map {|session| session.student_attendances.where(student_id: section.student, present: true).count}.sum).to_i / attendance.sessions.count.to_i)
            # end
            # column :ending_date
            # column :created_at
          end
        end 
      end
      tab "Attendance Report" do
      end
    end
    
  end

  
end

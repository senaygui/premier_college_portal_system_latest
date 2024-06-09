ActiveAdmin.register GradeReport do
  menu parent: "Grade"
  actions :all, :except => [:new]
  permit_params :semester_registration_id, :student_id, :academic_calendar_id, :program_id, :department_id, :section_id, :admission_type, :study_level, :total_course, :total_credit_hour, :total_grade_point, :cumulative_total_credit_hour, :cumulative_total_grade_point, :cgpa, :sgpa, :semester, :year, :academic_status, :registrar_approval, :registrar_name, :dean_approval, :dean_name, :department_approval, :approved_by, :updated_by, :created_by

  collection_action :pdf_report, method: :get do
    students = GradeReport.all
    respond_to do |format|
      format.html
      format.pdf do
        pdf = StudentGradeReport.new(students)
        send_data pdf.render, filename: "student grade #{Time.zone.now}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end

  action_item :pdf, method: :get, priority: 0 do

    # link_to 'Generate Pdf Report', pdf_report_admin_grade_reports_path(format: 'pdf'), notice: "CSV imported successfully!"

    link_to "Generate Pdf Report", pdf_gread_report_path, target: "_blank"
  end

  batch_action "Approve Grade Report For", if: proc { current_admin_user.role == "department head" }, method: :put, confirm: "Are you sure?" do |ids|
    GradeReport.find(ids).each do |grade_report|
      grade_report.update(department_approval: "approved", department_head_name: "#{current_admin_user.name.full}")
    end
    redirect_to collection_path, notice: "Grade Report Is Approved Successfully"
  end
  batch_action "Registrar Grade Report Approval For", if: proc { current_admin_user.role == "registrar head" }, method: :put, confirm: "Are you sure?" do |ids|
    GradeReport.find(ids).each do |grade_report|
      grade_report.update(registrar_approval: "approved", registrar_name: "#{current_admin_user.name.full}")
    end
    redirect_to collection_path, notice: "Grade Report Is Approved Successfully"
  end
  batch_action "Dean Grade Report Approval For", if: proc { current_admin_user.role == "dean" }, method: :put, confirm: "Are you sure?" do |ids|
    GradeReport.find(ids).each do |grade_report|
      grade_report.update(dean_approval: "approved", dean_name: "#{current_admin_user.name.full}")
    end
    redirect_to collection_path, notice: "Grade Report Is Approved Successfully"
  end

  # batch_action "Update Incomplete Grade Report For", method: :put, if: proc{ current_admin_user.role == "registrar head" }, confirm: "Are you sure?" do |ids|
  #   GradeReport.find(ids).each do |grade_report|
  #     grade_report.update_grade_report
  #     grade_report.update(updated_by: current_admin_user.name.full)
  #   end
  #   redirect_to collection_path, notice: "Grade Report Update Successfully"
  # end
  index do
    selectable_column
    column "Student Name", sortable: true do |n|
      "#{n.student.first_name.upcase} #{n.student.middle_name.upcase} #{n.student.last_name.upcase}"
    end
    column "Student ID", sortable: true do |n|
      n.student.student_id
    end
    column :program, sortable: true do |pro|
      pro.program.program_name
    end
    column :department, sortable: true do |pro|
      pro.department.department_name
    end
    # column :admission_type
    # column :study_level
    column :academic_status
    column "Academic Year", sortable: true do |n|
      link_to n.academic_calendar.calender_year, admin_academic_calendar_path(n.academic_calendar)
    end
    column "Year, Semester", sortable: true do |n|
      "Year #{n.year}, Semester #{n.semester}"
    end
    column "SGPA", :sgpa
    column "CGPA", :cgpa
    column "Issue Date", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :student_id, as: :search_select_filter, url: proc { admin_students_path },
                      fields: [:student_id, :id], display_name: "student_id", minimum_input_length: 2,
                      order_by: "id_asc"
  filter :department_id, as: :search_select_filter, url: proc { admin_departments_path },
                         fields: [:department_name, :id], display_name: "department_name", minimum_input_length: 2,
                         order_by: "id_asc"
  filter :admission_type
  filter :study_level
  filter :program_id, as: :search_select_filter, url: proc { admin_programs_path },
                      fields: [:program_name, :id], display_name: "program_name", minimum_input_length: 2,
                      order_by: "id_asc"
  filter :section_id, as: :search_select_filter, url: proc { admin_program_sections_path },
                      fields: [:section_full_name, :id], display_name: "section_full_name", minimum_input_length: 2,
                      order_by: "created_at_asc"
  filter :academic_calendar_id, as: :search_select_filter, url: proc { admin_academic_calendars_path },
                                fields: [:calender_year, :id], display_name: "calender_year", minimum_input_length: 2,
                                order_by: "id_asc"
  filter :year
  filter :semester
  filter :total_credit_hour
  filter :total_grade_point
  filter :cumulative_total_credit_hour
  filter :cumulative_total_grade_point
  filter :cgpa
  filter :sgpa
  filter :academic_status
  filter :registrar_approval
  filter :registrar_name
  filter :department_approval
  filter :approved_by
  filter :dean_approval
  filter :dean_name
  filter :updated_by
  filter :created_by
  filter :created_at
  filter :updated_at

  # filter :admission_type
  # filter :study_level
  # filter :min_cgpa_value_to_pass
  # filter :created_at
  # filter :updated_at

  form :title => "Grade Report Approval" do |f|
    f.semantic_errors
    f.inputs "Grade Report Approval" do
      if (current_admin_user.role == "department head") || (current_admin_user.role == "admin")
        f.input :department_approval, as: :select, :collection => ["pending", "approved", "denied"], :include_blank => false
        f.input :approved_by, as: :hidden, :input_html => { :value => current_admin_user.name.full }
      end
      if (current_admin_user.role == "regular_registrar") || (current_admin_user.role == "extention_registrar") || (current_admin_user.role == "online_registrar") || (current_admin_user.role == "distance_registrar") || (current_admin_user.role == "admin")
        f.input :registrar_approval, as: :select, :collection => ["pending", "approved", "denied"], :include_blank => false
        f.input :registrar_name, as: :hidden, :input_html => { :value => current_admin_user.name.full }
      end
      if (current_admin_user.role == "dean") || (current_admin_user.role == "admin")
        f.input :dean_approval, as: :select, :collection => ["pending", "approved", "denied"], :include_blank => false
        f.input :dean_name, as: :hidden, :input_html => { :value => current_admin_user.name.full }
      end

      if !f.object.new_record?
        f.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full }
      end
    end
    f.actions
  end

  show title: "Grade Report" do
    columns do
      column max_width: "30%" do
        panel "Grade Report Information" do
          attributes_table_for grade_report do
            row "Student Name" do |n|
              link_to "#{n.student.first_name.upcase} #{n.student.middle_name.upcase} #{n.student.last_name.upcase}", admin_student_path(n.student)
            end
            row "Student ID" do |n|
              n.student.student_id
            end
            row :program do |pro|
              pro.program.program_name
            end
            row :department do |pro|
              pro.department.department_name
            end
            row "Faculty" do |pro|
              pro.department.faculty.faculty_name
            end
            row "Academic Year" do |n|
              link_to n.academic_calendar.calender_year, admin_academic_calendar_path(n.academic_calendar)
            end
            row "Year, Semester" do |n|
              "Year #{n.year}, Semester #{n.semester}"
            end
            row :dean_approval do |s|
              status_tag s.dean_approval
            end
            row :department_approval do |s|
              status_tag s.department_approval
            end
            row :registrar_approval do |s|
              status_tag s.registrar_approval
            end
            row :academic_status
            row "Issue Date", sortable: true do |c|
              c.created_at.strftime("%b %d, %Y")
            end
            row "updated At", sortable: true do |c|
              c.updated_at.strftime("%b %d, %Y")
            end
          end
        end
      end
      column min_width: "67%" do
        panel "Course Registration" do
          table_for grade_report.semester_registration.course_registrations do
            column "Course title" do |pr|
              link_to pr.course_title, admin_course_path(pr.course)
            end
            column "Course code" do |pr|
              pr.course.course_code
            end
            column "Course module" do |pr|
              link_to pr.course.course_module.module_code, admin_course_module_path(pr.course.course_module.id)
            end
            column "Credit hour" do |pr|
              pr.course.credit_hour
            end
            column "Letter Grade" do |pr|
              pr.student_grade.letter_grade
            end
            column "Grade Point" do |pr|
              pr.student_grade.grade_point
            end
          end
        end
        panel "report" do
          table(class: "form-table") do
            tr do
              th "  ", class: "form-table__col"
              th "Cr Hrs", class: "form-table__col"
              th "Grade Point", class: "form-table__col"
              th "Average (GPA)", class: "form-table__col"
            end
            tr class: "form-table__row" do
              th "Current Semester Total", class: "form-table__col"
              td "#{grade_report.total_credit_hour}", class: "form-table__col"
              td "#{grade_report.total_grade_point}", class: "form-table__col"
              td "#{grade_report.sgpa}", class: "form-table__col"
            end
            tr class: "form-table__row" do
              th "Previous Total", class: "form-table__col"
              if grade_report.student.grade_reports.count > 1
                td "#{grade_report.student.grade_reports.last.total_credit_hour}", class: "form-table__col"
                td "#{grade_report.student.grade_reports.last.total_grade_point}", class: "form-table__col"
                td "#{grade_report.student.grade_reports.last.cgpa}", class: "form-table__col"
              end
            end
            tr class: "form-table__row" do
              th "Cumulative", class: "form-table__col"
              td "#{grade_report.cumulative_total_credit_hour}", class: "form-table__col"
              td "#{grade_report.cumulative_total_grade_point}", class: "form-table__col"
              td "#{grade_report.cgpa}", class: "form-table__col"
            end
          end
        end
      end
    end
  end
end

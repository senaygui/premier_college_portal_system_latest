ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }
 
  content title: proc { I18n.t("active_admin.dashboard") } do
  
    div class: "blank_slate_container", id: "dashboard_default_message" do
      tabs do
        tab :student_related_report do
          div class: "widget-container" do
            div class: "widget widgetContainer", id: "admission" do
              div class: "left" do
                span "admission type ", class: "widget-title"
                div class: "each" do
                  DashboardReport.admission_report.each do |key, value|
                    div do
                      span "#{key}: "
                      span "#{value} student".pluralize(value)
                    end
                  end
                end
              end
              div class: "right" do
                div class: "icon" do
                  fa_icon("address-card")
                end
                div class: "" do
                  link_to "See More", "/admin/dashboard#chart", class: "link", id: "student"
                end
              end
            end if RoleFilter.allowed_for_common(current_admin_user) || current_admin_user.role == "department head"

            div class: "widget widgetContainer" do
              div class: "left" do
                span "study level", class: "widget-title"
                div class: "each" do
                  DashboardReport.graduation_status.each do |key, value|
                    div do
                      span "#{key}: "
                      span "#{value} student".pluralize(value)
                    end
                  end
                end
              end
              div class: "right" do
                div class: "icon" do
                  fa_icon("address-card")
                end
                div class: "" do
                  link_to "See More", "/admin/dashboard#study_level", class: "link"
                end
              end
            end if RoleFilter.allowed_for_common(current_admin_user) || current_admin_user.role == "department head"

            div class: "widget widgetContainer" do
              div class: "left" do
                span "departement", class: "widget-title"
                div class: "each" do
                  DashboardReport.departement.each do |key, value|
                    div do
                      span "#{key}: "
                      span "#{value} student".pluralize(value)
                    end
                  end
                end
              end
              div class: "right" do
                div class: "icon" do
                  fa_icon "object-group"
                end
                div class: "" do
                  link_to "See More", "/admin/dashboard#student_in_dept", class: "link"
                end
              end
            end if RoleFilter.allowed_for_common(current_admin_user) || current_admin_user.role == "department head"

            div class: "widget widgetContainer" do
              div class: "left" do
                span "Program", class: "widget-title"
                div class: "each" do
                  DashboardReport.program.each do |key, value|
                    div do
                      span "#{key}: "
                      span "#{value} student".pluralize(value)
                    end
                  end
                end
              end
              div class: "right" do
                div class: "icon" do
                  fa_icon("calendar-days")
                end
                div class: "" do
                  link_to "See More", "/admin/dashboard#student_in_program", class: "link"
                end
              end
            end if RoleFilter.allowed_for_common(current_admin_user) || current_admin_user.role == "department head"

            div class: "widget widgetContainer" do
              div class: "left" do
                span "Document verification", class: "widget-title"
                div class: "each" do
                  DashboardReport.document_verification.each do |key, value|
                    div do
                      span "#{key}: ".camelize
                      span "#{value} document".pluralize(value)
                    end
                  end
                end
              end
              div class: "right" do
                div class: "icon" do
                  fa_icon "book"
                end
                div class: "" do
                  link_to "See More", "/admin/dashboard#document_verification", class: "link"
                end
              end
            end if RoleFilter.allowed_for_common(current_admin_user) || current_admin_user.role == "department head"

            div class: "widget widgetContainer" do
              div class: "left" do
                span "Account verification", class: "widget-title"
                div class: "each" do
                  DashboardReport.account_verification.each do |key, value|
                    div do
                      span "#{key}: ".camelize
                      span "#{value} account".pluralize(value)
                    end
                  end
                end
              end
              div class: "right" do
                div class: "icon" do
                  fa_icon("book")
                end
                div class: "" do
                  link_to "See More", "/admin/dashboard#account_verification", class: "link"
                end
              end
            end if RoleFilter.allowed_for_common(current_admin_user) || current_admin_user.role == "department head"
          end

          div class: "main-chart-container" do
            div id: "chart", class: "left" do
              div class: "main-chart1" do
                column_chart DashboardReport.chart_batch, dataset: { barThickness: 80, maxBarThickness: 100, borderColor: "#ccc", borderWidth: 6, clip: true, label: "Number of student", barPercentage: 10, backgroundColor: "red" }, title: "All Students in each batch", download: { filename: "students", background: "#fff" }, stacked: true, colors: ["#fff", "#f2f2f2"], empty: "There is no student"
              end
            end
            div class: "right" do
              div do
                pie_chart DashboardReport.chart_addmission_type, dataset: { borderRadius: 10, rotation: 10, borderJoinStyle: "miter", borderColor: "#f2f2f2" }, title: "Student Admission Type", download: { filename: "admission", background: "#fff" }
              end
            end
          end if RoleFilter.allowed_for_common(current_admin_user)
          hr
          div class: "main-chart-container" do
            div class: "other-chart", id: "study_level" do
              column_chart DashboardReport.chart_study_level, dataset: { borderRadius: 10, rotation: 10, borderJoinStyle: "miter", borderColor: "#f2f2f2" }, title: "Students study level", download: { filename: "study_level", background: "#fff" }
            end

            div class: "other-chart", id: "student_in_dept" do
              pie_chart DashboardReport.chart_departement, dataset: { borderRadius: 10, rotation: 10, borderJoinStyle: "miter", borderColor: "#f2f2f2" }, title: "Students in each departement", download: { filename: "student_in_dept", background: "#fff" }
            end

            div class: "other-chart", id: "student_in_program" do
              pie_chart DashboardReport.chart_program, dataset: { borderRadius: 10, rotation: 10, borderJoinStyle: "miter", borderColor: "#f2f2f2" }, title: "Students in each program", download: { filename: "student_in_program", background: "#fff" }
            end

            div class: "other-chart", id: "account_verification" do
              pie_chart DashboardReport.chart_account_verification, donut: true, dataset: { borderRadius: 10, rotation: 10, borderJoinStyle: "miter", borderColor: "#f2f2f2" }, title: "Account Verification Status", download: { filename: "account_verification", background: "#fff" }
            end

            div class: "other-chart", id: "document_verification" do
              pie_chart DashboardReport.chart_document_verification, donut: true, dataset: { borderRadius: 10, rotation: 10, borderJoinStyle: "miter", borderColor: "#f2f2f2" }, title: "Document Verification Status", download: { filename: "document_verification", background: "#fff" }
            end
          end
        end

        tab :general_report do
          div class: "widget-container" do
            div class: "widget widgetContainer" do
              div class: "left" do
                span "departement in faculity", class: "widget-title"
                div class: "each" do
                  DashboardReport.faculties.each do |key, value|
                    div do
                      span "#{key}: "
                      span value
                    end
                  end
                end
              end
              div class: "right" do
                div class: "icon" do
                  fa_icon("calendar-days")
                end
                div class: "" do
                  link_to "See More", "/admin/dashboard#dept_in_faculity", class: "link"
                end
              end
            end if RoleFilter.allowed_for_common(current_admin_user) || current_admin_user.role == "department head"

            div class: "widget widgetContainer" do
              div class: "left" do
                span "Courses in program", class: "widget-title"
                div class: "each" do
                  DashboardReport.courses.each do |key, value|
                    div do
                      span "#{key}: "
                      span value
                    end
                  end
                end
              end
              div class: "right" do
                div class: "icon" do
                  fa_icon("calendar-days")
                end
                div class: "" do
                  link_to "See More", "/admin/dashboard#course_in_program", class: "link"
                end
              end
            end if RoleFilter.allowed_for_common(current_admin_user) || current_admin_user.role == "department head"

            div class: "widget widgetContainer" do
              div class: "left" do
                span "Programs in department", class: "widget-title"
                div class: "each" do
                  if current_admin_user.role == "department head"
                    DashboardReport.department_head_filter(current_admin_user).each do |key, value|
                      div do
                        span "#{key}: "
                        span "#{value} program".pluralize(value)
                      end
                    end
                  else
                    DashboardReport.departement_and_program.each do |key, value|
                      div do
                        span "#{key}: "
                        span "#{value} program".pluralize(value)
                      end
                    end
                  end
                end
              end
              div class: "right" do
                div class: "icon" do
                  fa_icon("user-pen")
                end
                div class: "" do
                  link_to "See More", "/admin/dashboard#program_in_dept", class: "link"
                end
              end
            end if RoleFilter.allowed_for_common(current_admin_user) || current_admin_user.role == "department head"

            div class: "widget widgetContainer" do
              div class: "left" do
                span "Curriculums in program", class: "widget-title"
                div class: "each" do
                  if current_admin_user.role == "department head"
                    DashboardReport.department_curriculum_filter(current_admin_user).each do |key, value|
                      div do
                        span "#{key}: "
                        span "#{value} program".pluralize(value)
                      end
                    end
                  else
                    DashboardReport.program_and_curriculum.each do |key, value|
                      div do
                        span "#{key}: "
                        span "#{value} curriculum".pluralize(value)
                      end
                    end
                  end
                end
              end
              div class: "right" do
                div class: "icon" do
                  fa_icon("id-card")
                  # fa_icon ('fa-regular', 'calendar-days')
                end
                div class: "" do
                  link_to "See More", "/admin/dashboard#curriculum_in_program", class: "link"
                end
              end
            end if RoleFilter.allowed_for_common(current_admin_user) || current_admin_user.role == "department head"
          end

          div class: "main-chart-container" do
            div id: "dept_in_faculity", class: "left" do
              div class: "main-chart1" do
                column_chart DashboardReport.chart_departement_and_faculity, dataset: { barThickness: 80, maxBarThickness: 100, borderColor: "#ccc", borderWidth: 6, clip: true, label: "Number of departement", barPercentage: 10, backgroundColor: "red" }, title: "All departement in each faculity", download: { filename: "departements", background: "#fff" }, stacked: true, colors: ["#fff", "#f2f2f2"], empty: "There is no departement"
              end
            end
            div class: "right", id: "course_in_program" do
              div do
                pie_chart DashboardReport.chart_course_and_program, dataset: { borderRadius: 10, rotation: 10, borderJoinStyle: "miter", borderColor: "#f2f2f2" }, title: "Course in each program", download: { filename: "course", background: "#fff" }
              end
            end
          end if RoleFilter.allowed_for_common(current_admin_user)
          div class: "main-chart-container" do
            div class: "other-chart", id: "program_in_dept" do
              pie_chart DashboardReport.chart_departement_program, dataset: { borderRadius: 10, rotation: 10, borderJoinStyle: "miter", borderColor: "#f2f2f2" }, title: "Programs in each department", download: { filename: "department", background: "#fff" }
            end

            div class: "other-chart", id: "curriculum_in_program" do
              pie_chart DashboardReport.chart_program_and_curriculum, dataset: { borderRadius: 10, rotation: 10, borderJoinStyle: "miter", borderColor: "#f2f2f2" }, title: "Curriculums in each Program", download: { filename: "curriculum_in_program", background: "#fff" }
            end
          end
        end

        tab :invoice do
          div class: "widget widgetContainer" do
            div class: "left" do
              span "Invoice Report ", class: "widget-title"
              div class: "each" do
                DashboardReport.invoice_report.each do |key, value|
                  div do
                    span "#{key[0]}: #{key[1]}"
                    span "#{value} student".pluralize(value)
                  end
                end
              end
            end
            div class: "right" do
              div class: "icon" do
                fa_icon("address-card")
              end
              div class: "" do
                link_to "See More", "/admin/dashboard#invoive_report", class: "link"
              end
            end
          end if RoleFilter.allowed_for_common(current_admin_user) || current_admin_user.role == "department head"
          div class: "main-chart-container" do
            div class: "other-chart", id: "invoive_report" do
              pie_chart DashboardReport.chart_invoice_report, dataset: { borderRadius: 10, rotation: 10, borderJoinStyle: "miter", borderColor: "#f2f2f2" }, title: "Invoice report in each program", download: { filename: "invoice", background: "#fff" }
            end
          end
        end
      end
    end

    hr
  end
end

# end

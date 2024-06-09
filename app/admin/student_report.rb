# frozen_string_literal: true
ActiveAdmin.register_page "StudentReport" do
  menu parent: "student managment", priority: 11, label: "Student Report"
  breadcrumb do
    ["Student ", "Report"]
  end

  content title: "Payment Report" do
    panel "Student Payment Report" do
      div do
        render "admin/student_report/student_report"
      end
    end
  end
end

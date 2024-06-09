# frozen_string_literal: true
ActiveAdmin.register_page "FinanceReport" do
  menu parent: "Student Payments", priority: 1, label: "Payment Report"
  breadcrumb do
    ["Financial ", "Report"]
  end
  content title: "Payment Report" do
    panel "Student Payment Report" do
      div do
        render "admin/FinanceReports/search_user"
      end
    end
  end
end

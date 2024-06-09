# frozen_string_literal: true
ActiveAdmin.register_page "OnlineStudentGrade" do
  menu parent: "Grade", priority: 11, label: "Online Student Grade"
  breadcrumb do
    ["LMS ", "Student", "Grade"]
  end
  content title: "Online Student Grade" do
     tabs do
      #tab "Online Student List" do
       # render "admin/online_student_grade/student_list"
      #end

      tab "Prepare Online Student Grade" do
        render "admin/online_student_grade/prepare_grade"
      end
     end
  end
end

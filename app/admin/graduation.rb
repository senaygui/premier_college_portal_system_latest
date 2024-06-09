# frozen_string_literal: true
ActiveAdmin.register_page "Graduation" do
  menu parent: 'Student managment', priority: 10 
 

  content do

    columns do
  column  do
    panel "Generate Student Temporary and Student Copy" do
      div do
        link_to "Student Graduation Approval", graduation_approval_form_path, target: "_blank"
       end
      div do
       link_to "Generate Student Temporary", student_temporary_path, target: "_blank"
      end
      div do
       link_to "Generate Student Copy", student_copy_path, target: "_blank"
      end
    end
  end
end
  end
end


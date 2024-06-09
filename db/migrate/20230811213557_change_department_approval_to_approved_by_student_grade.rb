class ChangeDepartmentApprovalToApprovedByStudentGrade < ActiveRecord::Migration[7.0]
  def change
    rename_column :student_grades, :department_head_name, :approved_by
    rename_column :student_grades, :department_head_date_of_response, :approval_date
    add_column :student_grades, :approving_person_role, :string
  end
end

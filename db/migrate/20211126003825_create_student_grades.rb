class CreateStudentGrades < ActiveRecord::Migration[5.2]
  def change
    create_table :student_grades, id: :uuid do |t|
      t.belongs_to :course_registration, index: true, type: :uuid
      t.belongs_to :student, index: true, type: :uuid
      t.belongs_to :course, index: true, type: :uuid
      t.belongs_to :department, index: true, type: :uuid
      t.belongs_to :program, index: true, type: :uuid
      t.string :letter_grade
      # t.string :grade_point
      t.decimal :assesment_total
      t.decimal :grade_point
      t.string :updated_by
      t.string :created_by
      t.string :department_approval, default: "pending"
      t.string :department_head_name
      t.datetime :department_head_date_of_response

      t.timestamps
    end
  end
end

class CreateGradeChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :grade_changes, id: :uuid do |t|
      t.belongs_to :academic_calendar, index: true, type: :uuid
      t.belongs_to :program, index: true, type: :uuid
      t.belongs_to :department, index: true, type: :uuid
      t.belongs_to :student, index: true, type: :uuid
      t.belongs_to :course, index: true, type: :uuid
      t.belongs_to :section, index: true, type: :uuid
      # t.belongs_to :course_section, index: true, type: :uuid
      t.belongs_to :course_registration, index: true, type: :uuid
      t.belongs_to :student_grade, index: true, type: :uuid
      t.belongs_to :assessment, index: true, type: :uuid
      t.integer :semester
      t.integer :year
      t.decimal :add_mark

      t.decimal :previous_result_total
      t.string :previous_letter_grade

      t.decimal :current_result_total
      t.string :current_letter_grade

      t.string :reason 

      t.string :instructor_approval, default: "pending"
      t.string :instructor_name
      t.datetime :instructor_date_of_response

      t.string :registrar_approval, default: "pending"
      t.string :registrar_name
      t.datetime :registrar_date_of_response

      t.string :dean_approval, default: "pending"
      t.string :dean_name
      t.datetime :dean_date_of_response

      t.string :department_approval, default: "pending"
      t.string :department_head_name
      t.datetime :department_head_date_of_response

      t.string :academic_affair_approval, default: "pending"
      t.string :academic_affair_name
      t.datetime :academic_affair_date_of_response

      t.string :status

      t.timestamps
    end
  end
end

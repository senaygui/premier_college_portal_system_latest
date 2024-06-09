class CreateStudentCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :student_courses, id: :uuid do |t|
      t.belongs_to :student, index: true, type: :uuid
      t.belongs_to :course, index: true, type: :uuid
      t.string :course_title, null: false
      t.integer :semester, null: false
      t.integer :year, null: false
      t.integer :credit_hour, null: false
      t.integer :ects, null: false
      t.string :course_code, null: false
      t.string :letter_grade
      t.decimal :grade_point
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end

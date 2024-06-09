class CreateGradeReports < ActiveRecord::Migration[5.2]
  def change
    create_table :grade_reports, id: :uuid do |t|
      t.belongs_to :semester_registration, index: true, type: :uuid
      t.belongs_to :student, index: true, type: :uuid
      t.belongs_to :academic_calendar, index: true, type: :uuid
      t.belongs_to :program, index: true, type: :uuid
      t.belongs_to :department, index: true, type: :uuid
      t.belongs_to :section, index: true, type: :uuid
      t.string :admission_type, null: false
      t.string :study_level, null: false
      t.integer :total_course, null: false
      t.decimal :total_credit_hour, null: false
      t.decimal :total_grade_point, null: false
      t.decimal :cumulative_total_credit_hour, null: false
      t.decimal :cumulative_total_grade_point, null: false
      t.decimal :cgpa, null: false
      t.decimal :sgpa, null: false
      t.integer :semester, null: false
      t.integer :year, null: false
      t.string :academic_status
      t.string :registrar_approval, default: "pending"
      t.string :registrar_name
      t.string :dean_approval, default: "pending"
      t.string :dean_name
      t.string :department_approval, default: "pending"
      t.string :department_head_name
      t.string :updated_by
      t.string :created_by
      t.timestamps
    end
  end
end

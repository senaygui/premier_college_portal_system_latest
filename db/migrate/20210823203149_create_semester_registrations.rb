class CreateSemesterRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :semester_registrations, id: :uuid do |t|
      t.belongs_to :student, index: true, type: :uuid
      t.belongs_to :program, index: true, type: :uuid
      t.belongs_to :section, index: true, type: :uuid
      t.belongs_to :department, index: true, type: :uuid
      t.string :student_full_name
      t.string :student_id_number
      t.string :program_name
      t.string :admission_type
      t.string :study_level
      t.belongs_to :academic_calendar, index: true, type: :uuid
      t.decimal :total_price, default: 0.0
      t.decimal :registration_fee, default: 0.0
      t.decimal :late_registration_fee, default: 0.0
      t.decimal :remaining_amount, default: 0.0
      t.decimal :penalty, default: 0.0
      t.string :mode_of_payment
      t.integer :semester, null: false
      t.integer :year, null: false
      t.integer :total_enrolled_course
      t.string :registrar_approval_status, default: "pending"
      t.string :finance_approval_status, default: "pending"
      t.string :last_updated_by
      t.string :created_by
      t.timestamps
    end
  end
end

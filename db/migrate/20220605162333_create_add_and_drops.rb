class CreateAddAndDrops < ActiveRecord::Migration[5.2]
  def change
    create_table :add_and_drops, id: :uuid do |t|
      t.belongs_to :student, index: true, type: :uuid
      t.belongs_to :academic_calendar, index: true, type: :uuid
      t.belongs_to :semester_registration, index: true, type: :uuid
      t.belongs_to :department, index: true, type: :uuid
      t.belongs_to :program, index: true, type: :uuid
      t.belongs_to :section, index: true, type: :uuid

      t.integer :semester
      t.integer :year
      t.string :student_full_name
      t.string :student_id_number

      t.string :registrar_approval, default: "pending"
      t.string :registrar_name
      t.datetime :registrar_date_of_response

      t.string :advisor_approval, default: "pending"
      t.string :advisor_name
      t.datetime :advisor_date_of_response

      t.string :status,  default: "pending"

      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end

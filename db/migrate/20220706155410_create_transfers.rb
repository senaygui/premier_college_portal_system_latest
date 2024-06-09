class CreateTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :transfers, id: :uuid do |t|
      t.belongs_to :student, index: true, type: :uuid
      t.belongs_to :program, index: true, type: :uuid
      t.belongs_to :section, index: true, type: :uuid
      t.belongs_to :department, index: true, type: :uuid
      t.belongs_to :academic_calendar,index: true, type: :uuid

      t.string :student_full_name
      t.string :id_number
      t.integer :semester, null: false
      t.integer :year, null: false
      t.string :new_department
      t.string :modality_transfer
      t.text :reason

      t.datetime :date_of_transfer

      t.string :formal_department_head
      t.string :formal_department_head_approval, default: "pending"
      t.datetime :formal_department_head_approval_date
      t.string :remark
      
      t.string :new_department_head
      t.string :new_department_head_approval, default: "pending"
      t.datetime :new_department_head_approval_date

      t.string :dean_name
      t.string :dean_approval, default: "pending"
      t.datetime :dean_approval_date

      t.string :registrar_name
      t.string :registrar_approval, default: "pending"
      t.datetime :registrar_approval_date

      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end

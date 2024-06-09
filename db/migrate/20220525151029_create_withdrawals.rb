class CreateWithdrawals < ActiveRecord::Migration[5.2]
  def change
    create_table :withdrawals, id: :uuid do |t|
      t.belongs_to :program, index: true, type: :uuid
      t.belongs_to :department, index: true, type: :uuid
      t.belongs_to :student, index: true, type: :uuid
      t.belongs_to :section, index: true, type: :uuid
      t.belongs_to :academic_calendar, index: true, type: :uuid
      t.string :student_id_number
      t.integer :semester, null: false
      t.integer :year, null: false
      t.string :fee_status, null: false
      t.string :reason_for_withdrawal, null: false
      t.string :other_reason
      t.datetime :last_class_attended, null: false

      t.string :finance_head_approval, default: "pending"
      t.string :finance_head_name
      t.datetime :finance_head_date_of_response

      t.string :registrar_approval, default: "pending"
      t.string :registrar_name
      t.datetime :registrar_date_of_response

      t.string :dean_approval, default: "pending"
      t.string :dean_name
      t.datetime :dean_date_of_response

      t.string :department_approval, default: "pending"
      t.string :department_head_name
      t.datetime :department_head_date_of_response

      t.string :library_head_approval, default: "pending"
      t.string :library_head_name
      t.datetime :library_head_date_of_response

      t.string :store_head_approval, default: "pending"
      t.string :store_head_name
      t.datetime :store_head_date_of_response


      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end

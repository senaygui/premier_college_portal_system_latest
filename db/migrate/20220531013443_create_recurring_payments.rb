class CreateRecurringPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :recurring_payments, id: :uuid do |t|
      t.belongs_to :semester_registration, index: true, type: :uuid
      t.belongs_to :student, index: true, type: :uuid
      t.belongs_to :academic_calendar, index: true, type: :uuid
      t.belongs_to :department, index: true, type: :uuid
      t.belongs_to :program, index: true, type: :uuid
      t.belongs_to :section, index: true, type: :uuid

      t.integer :semester
      t.integer :year
      t.string :student_full_name
      t.string :student_id_number
      t.string :invoice_number, null: false
      t.decimal :total_price
      t.decimal :penalty, default: 0.0
      t.decimal :daily_penalty, default: 0.0
      t.string :invoice_status, default: "unpaid"
      t.string :mode_of_payment
      t.datetime :due_date
      t.string :last_updated_by
      t.string :created_by
      t.timestamps
    end
  end
end

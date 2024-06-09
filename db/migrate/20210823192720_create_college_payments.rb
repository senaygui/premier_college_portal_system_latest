class CreateCollegePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :college_payments, id: :uuid do |t|
      t.string :study_level, null: false
      t.string :admission_type, null: false
      t.string :student_nationality
      t.decimal :total_fee, default: 0
      t.decimal :registration_fee, default: 0
      t.decimal :late_registration_fee, default: 0
      t.decimal :starting_penalty_fee, default: 0
      t.decimal :daily_penalty_fee, default: 0
      t.decimal :makeup_exam_fee, default: 0
      t.decimal :add_drop, default: 0
      t.decimal :tution_per_credit_hr, default: 0
      t.decimal :readmission, default: 0
      t.decimal :reissuance_of_grade_report, default: 0
      t.decimal :student_copy, default: 0
      t.decimal :additional_student_copy, default: 0
      t.decimal :tempo, default: 0
      t.decimal :original_certificate, default: 0
      t.decimal :original_certificate_replacement, default: 0
      t.decimal :tempo_replacement, default: 0
      t.decimal :letter, default: 0
      t.decimal :student_id_card, default: 0
      t.decimal :student_id_card_replacement, default: 0
      t.decimal :name_change, default: 0
      t.decimal :transfer_fee, default: 0
      t.string :last_updated_by
      t.string :created_by
      t.timestamps
    end
  end
end

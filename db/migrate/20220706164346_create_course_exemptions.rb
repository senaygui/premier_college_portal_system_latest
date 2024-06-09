class CreateCourseExemptions < ActiveRecord::Migration[5.2]
  def change
    create_table :course_exemptions, id: :uuid do |t|
      t.belongs_to :course, index: true, type: :uuid
      t.string :letter_grade, null: false
      t.integer :credit_hour, null: false
      t.string :course_taken, null: false
      t.string :exemption_approval, default: "pending"
      t.string :exemption_type
      # t.belongs_to :transfer, index: true, type: :uuid
      t.references :exemptible, polymorphic: true, type: :uuid
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end

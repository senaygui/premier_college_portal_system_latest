class CreateCurriculums < ActiveRecord::Migration[5.2]
  def change
    create_table :curriculums, id: :uuid do |t|
      t.belongs_to :program, index: true, type: :uuid
      t.string :curriculum_title, null: false
      t.string :curriculum_version, null:false
      t.integer :total_course
      t.integer :total_ects
      t.integer :total_credit_hour
      t.string :active_status, default: "active"
      t.datetime :curriculum_active_date, null:false
      t.datetime :depreciation_date
      ##created and updated by
      t.string :created_by
      t.string :last_updated_by
      t.timestamps
    end
  end
end

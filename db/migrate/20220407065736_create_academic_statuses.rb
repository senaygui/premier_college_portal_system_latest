class CreateAcademicStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :academic_statuses, id: :uuid  do |t|
      t.belongs_to :grade_system, index: true, type: :uuid
      t.string :status
      t.decimal :min_value
      t.decimal :max_value
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end

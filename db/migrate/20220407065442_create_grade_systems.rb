class CreateGradeSystems < ActiveRecord::Migration[5.2]
  def change
    create_table :grade_systems, id: :uuid  do |t|
      t.belongs_to :program, index: true, type: :uuid
      t.belongs_to :curriculum, index: true, type: :uuid
      t.decimal :min_cgpa_value_to_pass
      t.decimal :min_cgpa_value_to_graduate
      t.string :remark
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end

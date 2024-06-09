class CreateGrades < ActiveRecord::Migration[5.2]
  def change
    create_table :grades, id: :uuid do |t|
    	t.belongs_to :grade_system, index: true, type: :uuid
    	t.string :letter_grade, null: false
      t.decimal :grade_point, null: false
    	t.integer :min_row_mark, null: false
    	t.integer :max_row_mark, null: false
      t.string :updated_by
      t.string :created_by
      t.timestamps
    end
  end
end

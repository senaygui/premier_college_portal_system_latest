class CreateSections < ActiveRecord::Migration[5.2]
  def change
    create_table :sections, id: :uuid do |t|
    	t.belongs_to :program, index: true, type: :uuid
    	t.string :section_short_name, null: false
      t.string :section_full_name, null: false
      t.integer :semester, null: false
      t.integer :year, null: false
    	t.integer :total_capacity
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end

class CreateCourseSections < ActiveRecord::Migration[5.2]
  def change
    create_table :course_sections, id: :uuid do |t|
      t.string :section_short_name, null: false
      t.string :section_full_name, null: false
      t.belongs_to :course, index: true, type: :uuid
      t.string :course_title
      t.string :program_name
      t.integer :total_capacity
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end

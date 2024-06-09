class CreateCourseModules < ActiveRecord::Migration[5.2]
  def change
    create_table :course_modules, id: :uuid do |t|
      t.string :module_title, null: false
      t.belongs_to :department, index: true, type: :uuid
      t.string :module_code, null: false
      t.text :overview
      t.text :description

      ##created and updated by
      t.string :created_by
      t.string :last_updated_by
      t.timestamps
    end
  end
end

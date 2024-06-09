class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses, id: :uuid do |t|
      t.belongs_to :course_module, index: true, type: :uuid
      t.belongs_to :curriculum, index: true, type: :uuid
      t.belongs_to :program, index: true, type: :uuid
      t.string :course_title, null: false
      t.string :course_code, null: false
      t.text :course_description
      
      t.integer :year, null: false, default: 1
      t.integer :semester, null: false, default: 1
      t.datetime :course_starting_date
      t.datetime :course_ending_date
      
      t.integer :credit_hour, null: false
      t.integer :lecture_hour, null: false
      t.integer :lab_hour, default: 0
      t.integer :ects, null: false
      ##created and updated by
      t.string :created_by
      t.string :last_updated_by

      t.timestamps
    end
  end
end

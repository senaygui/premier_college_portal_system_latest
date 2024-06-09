class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances, id: :uuid do |t|
      t.belongs_to :program, index: true, type: :uuid
      t.belongs_to :section, index: true, type: :uuid
      t.belongs_to :course, index: true, type: :uuid
      t.belongs_to :academic_calendar, index: true, type: :uuid
      t.string :course_title
      t.string :attendance_title
      t.integer :year
      t.integer :semester
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end

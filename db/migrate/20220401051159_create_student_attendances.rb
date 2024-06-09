class CreateStudentAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :student_attendances, id: :uuid do |t|
      t.belongs_to :session, index: true, type: :uuid
      t.belongs_to :student, index: true, type: :uuid
      t.belongs_to :course_registration, index: true, type: :uuid
      t.string :student_full_name
      t.boolean :present
      t.boolean :absent
      t.string :remark
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end

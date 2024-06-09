class CreateAddAndDropCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :add_and_drop_courses, id: :uuid do |t|
      t.belongs_to :add_and_drop, index: true, type: :uuid
      t.belongs_to :course, index: true, type: :uuid
      t.string :add_or_drop, null: false

      t.string :advisor_approval, default: "pending"
      t.string :advisor_name
      t.datetime :advisor_date_of_response
      
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end

class CreateSemesters < ActiveRecord::Migration[5.2]
  def change
    create_table :semesters, id: :uuid do |t|
      t.belongs_to :academic_calendar, index: true, type: :uuid
      t.integer :semester, null:false
      t.datetime :starting_date, null:false
      t.datetime :ending_date, null:false
      t.timestamps
    end
  end
end

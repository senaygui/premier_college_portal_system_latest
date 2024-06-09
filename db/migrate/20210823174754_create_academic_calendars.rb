class CreateAcademicCalendars < ActiveRecord::Migration[5.2]
  def change
    create_table :academic_calendars, id: :uuid do |t|
      t.string :calender_year, null:false
    	t.string :calender_year_in_gc, null:false
      t.string :calender_year_in_ec, null:false
      t.datetime :starting_date, null:false
      t.datetime :ending_date, null:false
      t.string :admission_type, null:false
      t.string :study_level, null:false
      t.integer :from_year
      t.integer :to_year
      t.string :remark
      t.string :last_updated_by
      t.string :created_by
      t.timestamps
    end
  end
end

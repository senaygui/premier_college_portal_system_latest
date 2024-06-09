class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities, id: :uuid do |t|
    	t.belongs_to :academic_calendar, index: true, type: :uuid
      t.string :activity, null:false
      t.integer :semester, null:false
      t.string :description
      t.string :category, null:false
      t.datetime :starting_date, null:false
      t.datetime :ending_date, null:false
      t.string :last_updated_by
      t.string :created_by
      t.timestamps
    end
  end
end

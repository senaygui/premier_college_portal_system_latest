class CreateFaculties < ActiveRecord::Migration[5.2]
  def change
    create_table :faculties, id: :uuid do |t|
      t.string :faculty_name, null: false
      t.text :overview
      t.text :background
      
      ## college address
      t.string :location
      t.string :phone_number
      t.string :alternative_phone_number
      t.string :email
      t.string :facebook_handle
      t.string :twitter_handle
      t.string :telegram_handle
      t.string :instagram_handle
      t.string :map_embed

      ##created and updated by
    	t.string :created_by
    	t.string :last_updated_by
      t.timestamps
    end
  end
end

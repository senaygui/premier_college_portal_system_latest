class CreateDepartments < ActiveRecord::Migration[5.2]
  def change
    create_table :departments, id: :uuid do |t|
    	t.belongs_to :faculty, index: true, foreign_key: true, type: :uuid
      t.string :department_name
      t.text :overview
      t.text :background
      t.text :facility
      
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

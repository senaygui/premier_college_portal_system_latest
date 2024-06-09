class CreateColleges < ActiveRecord::Migration[5.2]
  def change
    create_table :colleges, id: :uuid do |t|
    	## collage basic information
    	t.string :college_name, null: false
    	t.text :background
    	t.text :mission
    	t.text :vision
    	t.text :mission
    	t.text :overview

    	## collage address
    	t.string :headquarter
        t.string :sub_city
        t.string :state
        t.string :region
        t.string :zone
        t.string :worda
    	t.string :city
    	t.string :country
    	t.string :phone_number
        t.string :alternative_phone_number
    	t.string :email
    	t.string :facebook_handle
    	t.string :twitter_handle
    	t.string :instagram_handle
    	t.string :map_embed

    	##created and updated by
    	t.string :created_by
    	t.string :last_updated_by
      t.timestamps
    end
  end
end

class CreateStudentAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :student_addresses, id: :uuid do |t|
      t.belongs_to :student, index: true, type: :uuid
      t.string :country, null: false
      # t.string :current_address
      t.string :city
      t.string :region
      t.string :zone
      t.string :sub_city
      t.string :woreda
      t.string :special_location
      t.string :house_number
      t.string :moblie_number, null: false
      t.string :telephone_number
      t.string :pobox
      ##created and updated by
      t.string :created_by, default: "self"
      t.string :last_updated_by
      t.timestamps
    end
  end
end

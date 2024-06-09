class CreateEmergencyContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :emergency_contacts, id: :uuid do |t|
      t.belongs_to :student, index: true, type: :uuid
      t.string :full_name, null: false
      t.string :relationship
      t.string :cell_phone, null: false
      t.string :email
      t.string :current_occupation
      t.string :name_of_current_employer
      t.string :pobox
      t.string :email_of_employer
      t.string :office_phone_number
      ##created and updated by
      t.string :created_by, default: "self"
      t.string :last_updated_by
      t.timestamps
    end
  end
end

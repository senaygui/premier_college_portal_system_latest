class CreateAlmunis < ActiveRecord::Migration[5.2]
  def change
    create_table :almunis, id: :uuid do |t|
      t.string :fullname, null: false
      t.string :sex, null: false
      t.string :phone_number, null: false
      t.string :modality
      t.string :study_level
      t.datetime :graduation_date
      t.string :program_name
      t.timestamps
    end
  end
end

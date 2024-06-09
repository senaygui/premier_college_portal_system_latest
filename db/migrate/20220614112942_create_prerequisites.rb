class CreatePrerequisites < ActiveRecord::Migration[5.2]
  def change
    create_table :prerequisites, id: :uuid do |t|
      t.belongs_to :course, index: true, type: :uuid
      t.belongs_to :prerequisite, index: true, type: :uuid
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end

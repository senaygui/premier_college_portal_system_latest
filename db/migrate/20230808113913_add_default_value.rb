class AddDefaultValue < ActiveRecord::Migration[7.0]
  def change
    change_column :students, :graduation_status, :string, default: 'pending'
  end
end

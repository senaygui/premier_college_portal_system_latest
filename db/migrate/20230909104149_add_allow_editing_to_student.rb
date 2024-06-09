class AddAllowEditingToStudent < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :allow_editing, :boolean, default: false
  end
end

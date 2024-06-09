class AddMajorToCourse < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :major, :boolean, default: false
  end
end

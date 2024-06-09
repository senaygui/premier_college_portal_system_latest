class AddGraduationYearToStudent < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :graduation_year, :integer
  end
end

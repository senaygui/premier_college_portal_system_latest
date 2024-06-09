class AddAdmissionDateToStudent < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :admission_date, :date
  end
end

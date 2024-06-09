class AddActualPaymentToSemesterRegistration < ActiveRecord::Migration[7.0]
  def change
    add_column :semester_registrations, :actual_payment, :integer
  end
end

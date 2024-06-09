class ChangeActualPaymentToDecimalInSemesterRegistration < ActiveRecord::Migration[7.0]
  def change
    change_column :semester_registrations, :actual_payment, :decimal
  end
end

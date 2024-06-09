class AddBackInvoiceToSemesterRegistration < ActiveRecord::Migration[7.0]
  def change
    add_column :semester_registrations, :is_back_invoice_created, :boolean, default: false
  end
end

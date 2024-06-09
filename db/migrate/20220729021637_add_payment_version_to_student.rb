class AddPaymentVersionToStudent < ActiveRecord::Migration[5.2]
  def change
  	add_column :students, :payment_version, :string
  end
end

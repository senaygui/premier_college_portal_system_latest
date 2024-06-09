class CreatePaymentMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_methods, id: :uuid do |t|
			t.string :bank_name, null: false
			t.string :account_full_name, null: false
      t.string :account_number
      t.string :phone_number
      t.string :account_type
      t.string :payment_method_type, null: false
      t.string :last_updated_by
      t.string :created_by
      t.timestamps
    end
  end
end

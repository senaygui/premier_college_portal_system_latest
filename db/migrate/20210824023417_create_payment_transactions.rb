class CreatePaymentTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_transactions, id: :uuid do |t|
      # t.belongs_to :invoice, index: true, type: :uuid
      t.references :invoiceable, polymorphic: true, index: false, type: :uuid
      t.belongs_to :payment_method, index: true, type: :uuid
      t.string :account_holder_fullname, null: false
      t.string :phone_number
      t.string :account_number
      t.string :transaction_reference
      t.string :finance_approval_status, default: "pending"
      t.string :last_updated_by
      t.string :created_by
      t.timestamps
    end
  end
end

class CreateInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_items, id: :uuid do |t|
      t.references :itemable, polymorphic: true, type: :uuid
      t.belongs_to :course_registration, index: true, type: :uuid
      t.belongs_to :course, index: true, type: :uuid
      t.string :item_title
      t.decimal :price, default: 0
      t.string :last_updated_by
      t.string :created_by
      t.timestamps
    end
  end
end

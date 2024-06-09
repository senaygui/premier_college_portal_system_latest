class PaymentTransaction < ApplicationRecord
	after_create :set_invoice_status
	##validations
    #validates :account_holder_fullname , :presence => true, :length => { :within => 2..50 }, format: { with: /\A[a-zA-Z]+\z/, message: "Only letters are allowed" }
    #validates :transaction_reference , :presence => true, :length => { :within => 2..50 }
	#validates :phone_number, :presence => true, format: { with: /\A[1-9]\d*\z/, message: "Only positive numbers are allowed" }
	#validates :account_number, :presence => true, format: { with: /\A[1-9]\d*\z/, message: "Only positive numbers are allowed" }
	##associations
  	# belongs_to :invoice
    belongs_to :invoiceable, polymorphic: true
  	belongs_to :payment_method
  	has_one_attached :receipt_image
  	

  private
		def set_invoice_status
	  	self.invoiceable.update_columns(invoice_status: "pending")
	  end
end

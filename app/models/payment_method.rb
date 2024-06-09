class PaymentMethod < ApplicationRecord
	##validations
    validates :bank_name , :presence => true
    validates :account_full_name , :presence => true
    validates :payment_method_type , :presence => true
    validates :bank_logo,
            content_type: ['image/gif', 'image/png', 'image/jpg', 'image/jpeg'], attached: true
  ##scope
  	scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}
  	scope :bank, lambda { where(payment_method_type: "bank")}
  	scope :mobile_banking, lambda { where(payment_method_type: "mobile banking")}

  ##associations
  	has_one_attached :bank_logo
    has_many :payment_transactions
end

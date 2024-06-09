class Almuni < ApplicationRecord
  after_save :generate_qr
  ##validations
		validates :fullname, :presence => true 
		validates :sex, :presence => true
		validates :phone_number, :presence => true
    # validates :qr_code, attached: true
		has_many_attached :documents
		has_one_attached :qr_code

    has_one_attached :barcode
    has_one_attached :photo

  
  def generate_qr
    GenerateQr.call(self)
    GenerateBarcode.call(self)
  end
end

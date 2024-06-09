class EmergencyContact < ApplicationRecord
	##validations
	    #validates :full_name, :presence => true, format: { with: /\A[a-zA-Z]+\z/, message: "Only letters are allowed" }
		# validates :cell_phone, :presence => true
		validate :email_format
  ##associations
  belongs_to :student
  def email_format
	  if self.email_of_employer.present?
	  	if !email_of_employer.match(/\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/) 
	      errors.add :email_of_employer, "invalid email format"
	    end
	  end
	end
end

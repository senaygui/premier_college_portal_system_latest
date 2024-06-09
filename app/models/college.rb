class College < ApplicationRecord
	##validations
    validates :college_name , :presence => true,:length => { :within => 2..100 }
end

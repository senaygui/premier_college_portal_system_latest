ActiveAdmin.register PaymentTransaction do
menu parent: "Student Payments"
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :invoiceable_type, :invoiceable_id, :payment_method_id, :account_holder_fullname, :phone_number, :account_number, :transaction_reference, :finance_approval_status, :last_updated_by, :created_by
  #
  # or
  #
  # permit_params do
  #   permitted = [:invoiceable_type, :invoiceable_id, :payment_method_id, :account_holder_fullname, :phone_number, :account_number, :transaction_reference, :finance_approval_status, :last_updated_by, :created_by]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  scoped_collection_action :scoped_collection_update, title: 'Batch Action', form: -> do
                                         { 
                                          finance_approval_status: ["pending","approved", "denied", "incomplete"],
                                          invoice_status: ["pending","approved", "denied", "incomplete"]
                                          }
                                        end
  
end

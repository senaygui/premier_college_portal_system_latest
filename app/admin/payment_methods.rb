ActiveAdmin.register PaymentMethod do
  menu parent: "Finance Setting"
permit_params :bank_name,:account_number,:phone_number,:account_type,:payment_method_type,:created_by,:bank_logo ,:account_full_name, :last_updated_by

  index do
    selectable_column
    column "Bank logo" do |pt|
      span image_tag(pt.bank_logo, size: '50x50')
    end
    column :account_full_name
    column :bank_name
    column :account_number
    column :phone_number
    column :payment_method_type
    ## TODO: add word wraper to created_by and last_updated_by
    # column :created_by
    # column :last_updated_by
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end
  filter :bank_name
  filter :account_full_name
  filter :account_number
  filter :phone_number
  filter :account_type
  filter :payment_method_type
  filter :last_updated_by
  filter :created_by
  filter :created_at
  filter :updated_at

  scope :recently_added
  scope :bank
  scope :mobile_banking
  
  form do |f|
    f.semantic_errors
    f.inputs "Payment method information" do
      div class: "avatar-upload" do
        div class: "avatar-edit" do
          f.input :bank_logo, as: :file, label: "Upload Logo"
        end
        div class: "avatar-preview" do
          if f.object.bank_logo.attached? 
            image_tag(f.object.bank_logo,resize: '100x100',class: "profile-user-img img-responsive img-circle", id: "imagePreview")
          else
            image_tag("bank-logo.png",class: "profile-user-img img-responsive img-circle", id: "imagePreview")
          end
        end
      end
      f.input :bank_name
      f.input :account_full_name
      f.input :account_number
      f.input :phone_number
      f.input :account_type, as: :select, :collection => ["current","saving"]
      f.input :payment_method_type, as: :select, :collection => ["bank","mobile banking"]
      if f.object.new_record?
        f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      else
        f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      end      
    end
    f.actions
  end

  show title: :bank_name do
    panel "Payment method information" do
      attributes_table_for payment_method do
        row "Bank logo" do |pt|
          span image_tag(pt.bank_logo, size: '150x150', class: "img-corner")
        end
        row :bank_name
        row :account_full_name
        row :account_number
        row :phone_number
        row :account_type
        row :payment_method_type
        row :last_updated_by
        row :created_by
        row :created_at
        row :updated_at
      end
    end
  end 
end

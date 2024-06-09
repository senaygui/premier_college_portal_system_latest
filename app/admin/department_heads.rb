ActiveAdmin.register AdminUser, as: "DepartmentHead"  do
  menu parent: "Department"
  permit_params :photo, :email, :password, :password_confirmation,:first_name,:last_name,:middle_name,:role,:username, :department_id
  controller do
    def scoped_collection
      super.where("role = ?", "department head")
    end
    def update_resource(object, attributes)
      update_method = attributes.first[:password].present? ? :update : :update_without_password
      object.send(update_method, *attributes)
    end
  end
  index do
    selectable_column
    column "photo" do |pt|
      span image_tag(pt.photo, size: '50x50', class: "img-corner") if pt.photo.attached?
    end
    column "Full Name", sortable: true do |n|
      n.name.full 
    end
    column :email
    column :role
    column "Department", sortable: true do |d|
      # link_to d.department.department_name, [:admin, d.department] if d.department.department_name.present?
    end
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :department_id, as: :search_select_filter, url: proc { admin_departments_path },
         fields: [:department_name, :id], display_name: 'department_name', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :first_name
  filter :last_name
  filter :middle_name
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Department Head Account" do
      f.input :first_name
      f.input :last_name
      f.input :middle_name
      f.input :username
      f.input :email
      f.input :department_id, as: :search_select, url: admin_departments_path,
          fields: [:department_name, :id], display_name: 'department_name', minimum_input_length: 2,
          order_by: 'id_asc'
      if !f.object.new_record?
        f.input :current_password
      else
        f.input :role, as: :hidden, :input_html => { :value => "department head"}
      end
      f.input :password
      f.input :password_confirmation
      f.input :photo, as: :file
    end
    f.actions
  end

  show :title => proc{|department_head| department_head.name.full }  do
    panel "Department Head Information" do
      attributes_table_for department_head do
        row "photo" do |pt|
          span image_tag(pt.photo, size: '150x150', class: "img-corner") if pt.photo.attached?
        end
        row :first_name
        row :last_name
        row :middle_name
        row :username
        row :email
        row "Department", sortable: true do |d|
          link_to d.department.department_name, [:admin, d.department]
        end
        row :sign_in_count
        row :current_sign_in_at
        row :last_sign_in_at
        row :current_sign_in_ip
        row :last_sign_in_ip
        row :created_at
        row :updated_at
      end
    end
  end 

end

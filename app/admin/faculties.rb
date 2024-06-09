ActiveAdmin.register Faculty do

  menu parent: "College",priority: 2
  permit_params :faculty_name,:background,:overview,:location,:phone_number,:email,:facebook_handle,:telegram_handle,:twitter_handle,:instagram_handle,:created_by,:last_updated_by, :alternative_phone_number
  active_admin_import
  index do
    selectable_column
    column :faculty_name
    column "Departments", sortable: true do |c|
      c.departments.count
    end
    column :created_by
    column :last_updated_by
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :faculty_name
  filter :created_by
  filter :last_updated_by
  filter :created_at
  filter :updated_at

  form do |f|
    f.semantic_errors
    f.inputs "Faculty basic information" do
      f.input :faculty_name
      f.input :overview,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20}
      f.input :background,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20}
    end

    f.inputs "Faculty address" do
      f.input :location 
      #TODO: add phone number mask
      f.input :phone_number
      f.input :alternative_phone_number
      f.input :email
    end

    f.inputs "Social media address" do
      f.input :facebook_handle
      f.input :telegram_handle
      f.input :twitter_handle
      f.input :instagram_handle
    end
    if f.object.new_record?
      f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
    else
      f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
    end 
    f.actions
  end

  show title: :faculty_name do
    panel "Faculty basic information" do
      attributes_table_for faculty do
        row :faculty_name
        row :overview
        row :background
        row "Departments", sortable: true do |c|
          c.departments.count
        end
        row :location
        row :phone_number
        row :alternative_phone_number
        row :email 
        row :facebook_handle
        row :twitter_handle
        row :instagram_handle 
        row :created_by
        row :last_updated_by
        row :created_at
        row :updated_at
      end
    end
  end
  
  sidebar "Departments", :only => :show do
    table_for faculty.departments do

      column "department name" do |department|
        link_to department.department_name, admin_department_path(department.id)
      end
    end
  end
  # sidebar "modules", :only => :show do
  #   table_for department.course_modules do

  #     column "Course Modules" do |course_module|
  #       link_to course_module.module_title, admin_course_module_path(course_module.id)
  #     end
  #   end
  # end
  
  
end

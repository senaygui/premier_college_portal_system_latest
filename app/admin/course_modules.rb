ActiveAdmin.register CourseModule do
  menu parent: "Department"
permit_params :department_id,:module_title,:module_code,:overview,:description,:created_by,:last_updated_by
  active_admin_import
  index do
    selectable_column
    column :module_title
    column "Department", sortable: true do |d|
     link_to d.department.department_name, [:admin, d.department]
    end
    column "courses", sortable: true do |c|
      c.courses.count
    end
    column :module_code
    column :created_by
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :module_title
  filter :department_id, as: :search_select_filter, url: proc { admin_departments_path },
         fields: [:department_name, :id], display_name: 'department_name', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :module_code   
  filter :created_by
  filter :last_updated_by
  filter :created_at
  filter :updated_at

  scope :recently_added
  
  form do |f|
    f.semantic_errors
    f.inputs "Module information" do
      f.input :module_title
      f.input :module_code
      f.input :overview,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20}
      f.input :description,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20}
      f.input :department_id, as: :search_select, url: admin_departments_path,
          fields: [:department_name, :id], display_name: 'department_name', minimum_input_length: 2,
          order_by: 'id_asc'
      if f.object.new_record?
        f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      else
        f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      end      
    end
    f.actions
  end

  show title: :module_title do
    panel "Module information" do
      attributes_table_for course_module do
        row :module_title
        row :module_code
        row "Department" do |d|
          link_to d.department.department_name, admin_department_path(d.department.id)
        end
        row :overview
        row :description
        
        ## TODO: total number of course belongs to this module
        row "courses" do |c|
          c.courses.count
        end
        row :created_by
        row :last_updated_by
        row :created_at
        row :updated_at
      end
    end
  end
  ## TODO: add lists of courses with there links
  sidebar "courses", :only => :show do
    table_for course_module.courses do

      column "courses" do |course|
        link_to course.course_title, admin_course_path(course.id)
      end
    end
  end  
end

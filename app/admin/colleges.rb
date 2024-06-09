ActiveAdmin.register College do
  permit_params :college_name,:background,:mission,:vision,:overview,:headquarter,:city,:country,:phone_number,:email,:facebook_handle,:twitter_handle,:instagram_handle,:map_embed,:created_by,:last_updated_by,:state,:region,:zone,:worda, :sub_city, :alternative_phone_number
  menu parent: "College",priority: 2
  index do
    selectable_column
    column :college_name
    # column "Departments" do |c|
    #   c.departments.count
    # end
    column :headquarter
    column :created_by
    column :last_updated_by
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :college_name
  filter :created_by
  filter :last_updated_by
  filter :created_at
  filter :updated_at

  form do |f|
    f.semantic_errors
    f.inputs "College basic information" do
      f.input :college_name
      f.input :overview,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20}
      f.input :background,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20}
      f.input :mission,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20}
      f.input :vision,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20 }     
    end

    f.inputs "College address" do
      f.input :headquarter 
      f.input :country, as: :country, selected: 'ET', priority_countries: ["ET", "US"], include_blank: "select country"
      #TODO: add select list to city,sub_city,state,region,zone
      f.input :city
      f.input :sub_city
      f.input :state
      f.input :region
      f.input :zone
      f.input :worda
      #TODO: add phone number mask
      f.input :phone_number
      f.input :alternative_phone_number
      f.input :email
      f.input :map_embed
    end

    f.inputs "Social media address" do
      f.input :facebook_handle
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

  show title: :college_name do
    panel "College basic information" do
      attributes_table_for college do
        row :college_name
        row :overview
        row :background
        row :mission
        row :vision 
        # row "Departments" do |c|
        #   c.departments.count
        # end
        row :headquarter
        row :country
        row :city
        row :sub_city
        row :state
        row :region
        row :zone
        row :worda
        row :phone_number
        row :alternative_phone_number
        row :email 
        row "map", class: "video-responsive" do |s|
          s.map_embed.html_safe
        end
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
  
  # sidebar "Departments", :only => :show do
  #   table_for college.departments do

  #     column "department name" do |department|
  #       link_to department.department_name, admin_department_path(department.id)
  #     end
  #   end
  # end
end

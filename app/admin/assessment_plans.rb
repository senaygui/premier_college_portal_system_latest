ActiveAdmin.register AssessmentPlan do
menu parent: "Program"
  permit_params :course_id,:assessment_title,:assessment_weight, :created_by, :updated_by,:final_exam

  controller do
    def create
      super do |success,failure|
        success.html { redirect_to admin_course_path(@assessment_plan.course_id) }
      end
    end
  end
  index do
    selectable_column
    column :assessment_title
    column :assessment_weight
    column :course do |c|
      link_to c.course.course_title, admin_course_path(c.course)
    end
    column :program do |c|
      link_to c.course.program.program_name, admin_program_path(c.course.program)
    end
    
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :course_id, as: :search_select_filter, url: proc { admin_courses_path },
         fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,
         order_by: 'created_at_asc' 
  filter :assessment_title   
  filter :assessment_weight
  filter :created_at
  filter :updated_at
  filter :created_by
  filter :updated_by


  
  form do |f|
    f.semantic_errors
    f.inputs "Assessment Plan" do
      if params[:course_id].present?
        f.input :course_id, as: :hidden, :input_html => { :value => params[:course_id]}
      else
        f.input :course_id, as: :search_select, url: admin_courses_path,
        fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2, order_by: 'created_at_asc'
      end
      f.input :assessment_title
      f.input :assessment_weight,:input_html => { :min => 1, :max => 100  } 
      f.input :final_exam
      if f.object.new_record?
        f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      else
        f.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full} 
      end 
    end
    
    f.actions
  end

  show title: :assessment_title do
    panel "Assessment Plan Information" do
      attributes_table_for assessment_plan do
        row :assessment_title
        row :assessment_weight
        row :course do |c|
          link_to c.course.course_title, admin_course_path(c.course)
        end
        row :program do |c|
          link_to c.course.program.program_name, admin_program_path(c.course.program)
        end
        row :created_at
        row :updated_at
        row :created_by
        row :updated_by 
      end
    end
  end 
  
end

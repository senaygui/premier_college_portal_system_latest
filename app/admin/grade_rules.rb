ActiveAdmin.register GradeRule do
menu parent: "Grade"
  permit_params :admission_type,:study_level,:min_cgpa_value_to_pass,grades_attributes: [:id,:grade_rule_id,:grade,:min_value,:max_value,:grade_value, :_destroy]

  index do
    selectable_column
    column :admission_type
    column :study_level
    column :min_cgpa_value_to_pass
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :admission_type
  filter :study_level   
  filter :min_cgpa_value_to_pass
  filter :created_at
  filter :updated_at


  
  form do |f|
    f.semantic_errors
    f.inputs "Grade Rule information" do
      f.input :study_level, as: :select, :collection => ["undergraduate", "graduate", "TPVT"], :include_blank => false
      f.input :admission_type, as: :select, :collection => ["online", "regular", "extention", "distance"], :include_blank => false
      f.input :min_cgpa_value_to_pass     
    end

    if f.object.grades.empty?
      f.object.grades << Grade.new
    end
    panel "Grade info" do
      f.has_many :grades,heading: " ", remote: true, allow_destroy: true, new_record: true do |a|
        a.input :grade
        a.input :min_value
        a.input :max_value
        a.input :grade_value
        a.label :_destroy
      end
    end
    f.actions
  end

  show title: "Grading Rule information" do
    panel "Grading Rule information" do
      attributes_table_for grade_rule do
        row :study_level
        row :admission_type
        row :min_cgpa_value_to_pass
        row :created_at
        row :updated_at
      end
    end
    panel "grade Information" do
      table_for grade_rule.grades do
        column :grade
        column :min_value
        column :max_value
        column :grade_value
      end
    end
  end 
  
end

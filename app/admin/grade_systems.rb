ActiveAdmin.register GradeSystem do
menu parent: "Grade"
  permit_params :program_id,:curriculum_id,:min_cgpa_value_to_pass,:min_cgpa_value_to_graduate,:remark,:created_by,:updated_by,grades_attributes: [:id,:letter_grade,:grade_point,:min_row_mark,:max_row_mark, :_destroy],academic_statuses_attributes: [:id,:status,:min_value,:max_value, :_destroy]
  active_admin_import
  index do
    selectable_column
    column "Program", sortable: true do |c|
      c.program.program_name
    end
    column :admission_type, sortable: true do |c|
      c.program.admission_type
    end
    column :study_level, sortable: true do |c|
      c.program.study_level
    end
    column :curriculum, sortable: true do |c|
      c.curriculum.curriculum_version
    end
    column :min_cgpa_value_to_pass
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  form do |f|
    f.semantic_errors

    f.inputs "Grade System information" do
      f.input :program_id, as: :search_select, url: admin_programs_path,
      fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
      order_by: 'id_asc'
      f.input :curriculum_id, as: :search_select, url: admin_curriculums_path,
      fields: [:curriculum_version, :id], display_name: 'curriculum_version', minimum_input_length: 1,
      order_by: 'id_asc'
      f.input :min_cgpa_value_to_pass
      f.input :min_cgpa_value_to_graduate
      f.input :remark    
    end
    columns do
      column do
        if f.object.grades.empty?
          f.object.grades << Grade.new
        end
        panel "Grade information" do
          f.has_many :grades,heading: " ", remote: true, allow_destroy: true, new_record: true do |a|
            a.input :letter_grade
            a.input :grade_point
            a.input :min_row_mark
            a.input :max_row_mark
            a.label :_destroy
          end
        end
      end
      column do
        if f.object.academic_statuses.empty?
          f.object.academic_statuses << AcademicStatus.new
        end
        panel "Academic status informations" do
          f.has_many :academic_statuses,heading: " ", remote: true, allow_destroy: true, new_record: true do |a|
            a.input :status
            a.input :min_value
            a.input :max_value
            a.label :_destroy
          end
        end
      end
    end
    f.actions
  end

  show title: "Grading system information" do
    columns do 
      column do
        panel "Grading system information" do
          attributes_table_for grade_system do
            row "Program", sortable: true do |c|
              c.program.program_name
            end
            row :admission_type, sortable: true do |c|
              c.program.admission_type
            end
            row :study_level, sortable: true do |c|
              c.program.study_level
            end
            row :curriculum, sortable: true do |c|
              c.curriculum.curriculum_version
            end
            row :min_cgpa_value_to_pass
            row :min_cgpa_value_to_graduate
            row :remark
            row :created_at
            row :updated_at
          end
        end
        
        panel "grade Information" do
          table_for grade_system.academic_statuses do
            column :status
            column :min_value
            column :max_value
          end
        end
      end
      column do
        panel "grade Information" do
          table_for grade_system.grades do
            column :letter_grade
            column :grade_point
            column :min_row_mark
            column :max_row_mark
          end
        end
      end
    end
    
  end 
  
end

ActiveAdmin.register Curriculum do
menu parent: "Program"
 permit_params :program_id,:curriculum_title,:curriculum_version,:total_course,:total_ects,:total_credit_hour,:active_status,:curriculum_active_date,:depreciation_date,:created_by,:last_updated_by, courses_attributes: [:id,:course_module_id,:program_id,:curriculum_id,:semester,:course_starting_date,:course_ending_date,:year,:credit_hour,:lecture_hour,:lab_hour,:ects,:course_code,:course_title,:created_by,:last_updated_by, :_destroy]
 active_admin_import
 index do
  selectable_column
  column :curriculum_title
  column  "Version",:curriculum_version
  column "Program", sortable: true do |d|
    link_to d.program.program_name, [:admin, d.program]
  end
  column "Courses",:total_course
  column "Credit hours",:total_credit_hour
  column "ECTS",:total_ects
  column :active_status do |s|
    status_tag s.active_status
  end
  column "Add At", sortable: true do |c|
    c.created_at.strftime("%b %d, %Y")
  end
  actions
end

filter :program_id, as: :search_select_filter, url: proc { admin_programs_path },
fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
order_by: 'id_asc'
filter :curriculum_title
filter :curriculum_version
filter :total_course
filter :total_ects
filter :total_credit_hour
filter :active_status
filter :curriculum_active_date
filter :depreciation_date
filter :created_by
filter :last_updated_by

filter :created_at
filter :updated_at

# scope :recently_added

  form do |f|
    f.semantic_errors
    if !(params[:page_name] == "add_course")
      f.inputs "Curriculum information" do
        f.input :program_id, as: :search_select, url: admin_programs_path,
        fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
        order_by: 'id_asc'
        f.input :curriculum_title
        f.input :curriculum_version
        f.input :total_course
        f.input :total_ects
        f.input :total_credit_hour
        f.input :curriculum_active_date, as: :date_time_picker 

        if f.object.new_record?
          f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
        else
          f.input :active_status, as: :select, :collection => ["active","depreciated"]
          f.input :depreciation_date, as: :date_time_picker
          f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
        end      
      end
    end
    
    if f.object.new_record? || (params[:page_name] == "add_course")
      if f.object.courses.empty?
        f.object.courses << Course.new
      end
      panel "Course Breakdown Information" do
        f.has_many :courses,heading: " ", remote: true, allow_destroy: true, new_record: true do |a|
          a.input :course_module_id, as: :search_select, url: admin_course_modules_path,
            fields: [:module_title, :id], display_name: 'module_title', minimum_input_length: 2,
            order_by: 'id_asc'
          a.input :course_title
          a.input :course_code
          a.input :credit_hour, :required => true, min: 1, as: :select, :collection => [1, 2,3,4,5,6,7], :include_blank => false
          a.input :lecture_hour
          a.input :lab_hour
          a.input :ects
          a.input :course_description,  :input_html => { :class => 'autogrow', :rows => 5, :cols => 20}
          a.input :year, as: :select, :collection => [1, 2,3,4,5,6,7], :include_blank => false
          a.input :semester, as: :select, :collection => [1, 2,3,4], :include_blank => false
          a.input :course_starting_date, as: :date_time_picker 
          a.input :course_ending_date, as: :date_time_picker

          if a.object.new_record?
            a.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          else
            a.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          end 
          a.label :_destroy
        end
      end
    end
    f.actions
  end


  action_item :edit, only: :show, priority: 1  do
    link_to 'Add Course', edit_admin_curriculum_path(curriculum.id, page_name: "add_course")
  end
  action_item :new, only: :show, priority: 2 do
    if !curriculum.grade_system.present?
      link_to 'Add Grade System', new_admin_grade_system_path(page_name: curriculum.id)
    else
      link_to 'Edit Grade System', edit_admin_grade_system_path(curriculum.grade_system)
    end
  end
  show title: :curriculum_title do
    tabs do
      tab "Curriculum information" do
        panel "Curriculum information" do
          attributes_table_for curriculum do
            row :program_name do |pr|
              link_to pr.program.program_name, admin_program_path(pr.program)
            end
            row :curriculum_title
            row :curriculum_version
            row :total_course
            row :total_ects
            row :total_credit_hour
            row :active_status
            row :curriculum_active_date
            row :depreciation_date
            row :created_by
            row :last_updated_by

            row :created_at
            row :updated_at
          end
        end
      end
      tab "Course Breakdown" do      
        panel "Course Breakdown list" do
          (1..curriculum.program.program_duration).map do |i|
            panel "ClassYear: Year #{i}" do
              (1..curriculum.program.program_semester).map do |s|
                panel "Semester: #{s}" do
                  table_for curriculum.courses.where(year: i, semester: s).order('year ASC','semester ASC') do
                    ## TODO: wordwrap titles and long texts
                    
                    column "course title" do |item|
                      link_to item.course_title, [ :admin, item] 
                    end
                    column "module code" do |item|
                      item.course_module.module_code
                    end
                    column "course code" do |item|
                      item.course_code
                    end
                    column "credit hour" do |item|
                      item.credit_hour
                    end
                    column :lecture_hour do |item|
                      item.lecture_hour
                    end
                    column :lab_hour do |item|
                      item.lab_hour
                    end
                    column "ECTS" do |item|
                      item.ects
                    end
                    column :created_by
                    # column :last_updated_by
                    column "Add At", sortable: true do |c|
                      c.created_at.strftime("%b %d, %Y")
                    end
                    # column "Starts at", sortable: true do |c|
                    #   c.course_starting_date.strftime("%b %d, %Y") if c.course_starting_date.present?
                    # end
                    # column "ends At", sortable: true do |c|
                    #   c.course_ending_date.strftime("%b %d, %Y") if c.course_ending_date.present?
                    # end
                  end
                end
              end      
            end 
          end    
        end 
      end
      tab "Grade System" do
        columns do 
          if curriculum.grade_system.present?
            column do
              panel "Grading system information" do
                attributes_table_for curriculum.grade_system do
                  row "Program" do |c|
                    link_to c.program.program_name, admin_program_path(c.program)
                  end
                  row :admission_type do |c|
                    c.program.admission_type
                  end
                  row :study_level do |c|
                    c.program.study_level
                  end
                  row :curriculum do |c|
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
                table_for curriculum.grade_system.academic_statuses do
                  column :status
                  column :min_value
                  column :max_value
                end
              end
            end
          end
          if curriculum.grade_system.present?
            column do
              panel "grade Information" do
                table_for curriculum.grade_system.grades do
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
    end
  end

end

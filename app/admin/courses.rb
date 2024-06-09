ActiveAdmin.register Course do
    menu parent: "Program"
    # , if: proc{current_user.role=="admin"}
    # def current_academic_calendar(level, admission_type)
    #   AcademicCalendar.find_by(study_level: level, admission_type: admission_type).id
    # end

    # def current_semester(level, admission_type)
    #   SemesterRegistration.find_by(study_level: level, admission_type: admission_type).id
    # end
permit_params(:course_outline,:course_module_id, :major, :curriculum_id,:program_id,:course_title,:course_code,:course_description,:year,:semester,:course_starting_date,:course_ending_date,:credit_hour,:lecture_hour,:lab_hour,:ects,:created_by, assessment_plans_attributes: [:id,:course_id,:assessment_title,:assessment_weight,:final_exam, :created_by, :updated_by, :_destroy], course_instructors_attributes: [:id ,:section_id,:year,:admin_user_id,:course_id,:academic_calendar_id,:semester, :created_by, :updated_by, :_destroy], course_prerequisites_attributes: [:id, :course_id,:prerequisite_id,:created_by,:updated_by, :_destroy])
  active_admin_import
  index do
    selectable_column 
    column :course_title
    column :course_code
    column :module_title, sortable: true do |m|
     link_to m.course_module.module_title, [:admin, m.course_module]
    end
    column :program, sortable: true do |m|
     link_to m.program.program_name, [:admin, m.program]
    end
    column :curriculum, sortable: true do |m|
     link_to m.curriculum.curriculum_version, [:admin, m.curriculum]
    end
    column :credit_hour
    column :created_by
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :course_title
  filter :course_code 
  filter :program_id, as: :search_select_filter, url: proc { admin_programs_path },
         fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
         order_by: 'created_at_asc' 
  filter :curriculum_id, as: :search_select_filter, url: proc { admin_curriculums_path },
         fields: [:curriculum_version, :id], display_name: 'curriculum_version', minimum_input_length: 1,
         order_by: 'created_at_asc' 
  filter :course_module_id, as: :search_select_filter, url: proc { admin_course_modules_path },
         fields: [:module_title, :id], display_name: 'module_title', minimum_input_length: 2,
         order_by: 'module_code_asc' 
  
  filter :course_title
  filter :course_code
  filter :course_description
  filter :year
  filter :semester
  filter :course_starting_date
  filter :course_ending_date
  filter :credit_hour
  filter :lecture_hour
  filter :lab_hour
  filter :ects
  filter :created_by
  filter :last_updated_by
  filter :created_at
  filter :updated_at

  scope :recently_added
  
  form do |f|
    f.semantic_errors
    if !(params[:page_name] == "add_assessment") &&  !(params[:page_name] == "course_instructors") &&  !(current_admin_user.role == "instructor")
      f.inputs "Course information" do
        f.input :major
        f.input :course_title
        f.input :course_code
        f.input :course_description,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20}
        f.input :course_module_id, as: :search_select, url: admin_course_modules_path,
            fields: [:module_title, :id], display_name: 'module_title', minimum_input_length: 2,
            order_by: 'id_asc'
        f.input :program_id, as: :search_select, url: proc { admin_programs_path },
           fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
           order_by: 'created_at_asc' 
        f.input :curriculum_id, as: :search_select, url: proc { admin_curriculums_path },
           fields: [:curriculum_version, :id], display_name: 'curriculum_version', minimum_input_length: 1,
           order_by: 'created_at_asc'
        f.input :credit_hour, :required => true, min: 1, as: :select, :collection => [1, 2,3,4,5,6,7], :include_blank => false
        f.input :lecture_hour
        f.input :lab_hour
        f.input :ects, label: "Contact Hour"
        f.input :year, as: :select, :collection => [1, 2,3,4,5,6,7], :include_blank => false
        f.input :semester, as: :select, :collection => [1, 2,3,4], :include_blank => false
        f.input :course_starting_date, as: :date_time_picker 
        f.input :course_ending_date, as: :date_time_picker
        if f.object.new_record?
          f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
        else
          f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
        end      
      end
      if f.object.course_prerequisites.empty?
        f.object.course_prerequisites << Prerequisite.new
      end
      panel "Course Prerequisite" do
        f.has_many :course_prerequisites, heading: " ",remote: true , allow_destroy: true, new_record: true do |a|
          a.input :prerequisite_id, as: :search_select, url: admin_courses_path,
          fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,
          order_by: 'id_asc'
          if a.object.new_record?
            a.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full} 
          else
            a.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}      
          end
          a.label :_destroy
        end
      end
    elsif params[:page_name] == "add_assessment"
      if f.object.assessment_plans.empty?
        f.object.assessment_plans << AssessmentPlan.new
      end
      panel "Assessment Plans" do
        f.has_many :assessment_plans,heading: " ", remote: true, allow_destroy: true, new_record: true do |a|
          a.input :assessment_title
          a.input :assessment_weight,:input_html => { :min => 1, :max => 100  }
          a.input :final_exam 
          a.label :_destroy
          if a.object.new_record?
            a.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          else
            a.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full} 
          end 
        end
      end
    end

    if (params[:page_name] == "course_instructors")
      if f.object.course_instructors.empty?
        f.object.course_instructors << CourseInstructor.new
      end
      panel "Course instructors" do
        f.has_many :course_instructors,heading: " ", remote: true, allow_destroy: true, new_record: true do |a|
          a.input :admin_user_id, as: :search_select, url: proc { admin_instructors_path },
           fields: [:username, :id], display_name: 'username', minimum_input_length: 2,
           order_by: 'created_at_asc', label: "Instructor"
          # a.input :course_section_id, as: :select, :collection => course.course_sections.pluck(:section_full_name, :id), label: "Course Section" 
          a.input :section_id, as: :select, :collection => course.program.sections.pluck(:section_full_name, :id), label: "Section" 
          a.input :academic_calendar_id, as: :search_select, url: proc { admin_academic_calendars_path },
           fields: [:calender_year, :id], display_name: 'calender_year', minimum_input_length: 2,
           order_by: 'created_at_asc'
          a.input :year
          a.input :semester

          if a.object.new_record?
            a.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          else
            a.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full} 
          end 
        end
      end
    end
    if (params[:page_name] == "course_outlines")  || (current_admin_user.role == "instructor")
      panel "Add Course Outline" do
        f.inputs do
          f.input :course_outline, as: :file
        end
      end
    end
    f.actions
  end
  action_item :edit, only: :show, priority: 1  do
    if (current_admin_user.role == "department head") || (current_admin_user.role == "admin")
      link_to 'Add Assessment Plan', new_admin_assessment_plan_path(course_id: course.id) 
    end
  end
  action_item :edit, only: :show, priority: 1  do
    if (current_admin_user.role == "admin") || (current_admin_user.role == "department head")
      link_to 'Add Instructor', edit_admin_course_path(course.id, page_name: "course_instructors")
    end 
  end

  action_item :edit, only: :show, priority: 1  do
    link_to 'Add Course Outline', edit_admin_course_path(course.id, page_name: "course_outlines") if current_admin_user.role == "instructor"
  end

  show title: :course_title do
    tabs do
      tab "Course Information" do
        columns do
          column do
            panel "Course information" do
              attributes_table_for course do
                row :course_title
                row :course_code
                row "module title" do |d|
                  link_to d.course_module.module_title, admin_course_module_path(d.course_module.id)
                end
                row :program do |m|
                 link_to m.program.program_name, [:admin, m.program]
                end
                row :curriculum_version do |m|
                 link_to m.curriculum.curriculum_version, [:admin, m.curriculum]
                end
                row :course_description
                row "Course Outline" do |pr|
                  link_to "attachement", rails_blob_path(pr.course_outline, disposition: 'preview') if pr.course_outline.attached?
                end
                row :credit_hour
                row :lecture_hour
                row :lab_hour
                row "Contact Hour" do |c|
                  c.ects
                end
                # row :ects
                row :year
                row :semester
                row :course_starting_date
                row :course_ending_date
                row :created_by
                row :last_updated_by
                row :created_at
                row :updated_at
              end
            end
          end
          column do
            panel "Course Prerequisites" do
              table_for course.course_prerequisites do
                column :course_title do |c|
                  link_to c.prerequisite.course_title, admin_courses_path(c.prerequisite)
                end
                column :course_code do |c|
                  c.prerequisite.course_code
                end
                column "Added by", :created_by
                column "Added" do |c|
                  c.created_at.strftime("%b %d, %Y")
                end
              end
            end
          end
        end
        
      end
      # if (current_admin_user.role == "admin")
      #   tab "Course section" do
      #   end
      # end
      # 
      if (course.course_registrations.where(enrollment_status: "enrolled").present?)
      tab "Currently enrolled students" do
        panel "currently enrolled students" do
          table_for course.course_registrations.where(enrollment_status: "enrolled").where(academic_calendar_id: current_academic_calendar(course.program.study_level, course.program.admission_type)).where(semester: SemesterRegistration.find_by(study_level: course.program.study_level, admission_type: course.program.admission_type).semester).order('student_full_name ASC') do
            column "Student Full Name" do |n|
              link_to n.student_full_name, admin_student_path(n.student)
            end
            column "Student ID" do |n|
              n.student.student_id
            end
            column "Academic calendar" do |n|
              n.academic_calendar.calender_year
            end
            column "Year" do |s|
              s.year
            end
            column "Semester" do |n|
              n.semester
            end
            column "Section" do |n|
              n.section.section_short_name if n.section.present?
            end
            column "Program Section" do |n|
              n.semester_registration.section.section_short_name if n.semester_registration.section.present?
            end
            column "Add At", sortable: true do |c|
              c.created_at.strftime("%b %d, %Y")
            end

            # column "links", sortable: true do |c|
            #     "#{link_to("View", admin_assessment_plan_path(c))} #{link_to "Edit", edit_admin_course_path(course.id, page_name: "add_assessment")}".html_safe     
            # end
          end
        end
      end 
    end

      tab "Assessment Plan" do
        columns do
          column min_width: "70%" do
            panel "Assessment Plan Information" do
              table_for course.assessment_plans.order('created_at ASC') do
                column  :assessment_title
                column  :assessment_weight
                column "Added At", sortable: true do |c|
                  c.created_at.strftime("%b %d, %Y")
                end
                column "Updated At", sortable: true do |c|
                  c.updated_at.strftime("%b %d, %Y")
                end
                
                column  :created_by
                column  :updated_by 
                column "links", sortable: true do |c|
                    "#{link_to("View", admin_assessment_plan_path(c))} #{link_to "Edit", edit_admin_assessment_plan_path(c)}".html_safe     
                end
              end
            end
          end
          column max_width: "27%" do
            panel "Assessment Plan Summery" do 
              attributes_table_for course do
                row :total_assesement do |s|
                  s.assessment_plans.count
                end
                row :total_assesement_weight do |s|
                  s.assessment_plans.pluck(:assessment_weight).sum
                end
              end
            end
          end
        end  
      end
      tab "Course Enrollement Report" do
      end
      tab "Instructors Information" do
        panel "Assessment Plan Information" do
          table_for course.course_instructors.order('created_at ASC') do
            column "Instructor Name" do |c|
              link_to c.admin_user.name.full, admin_instructor_path(c.admin_user)
            end
            # column "Section" do |c|
            #   link_to c.course_section.section_short_name, admin_course_section_path(c.course_section)
            # end
            column "Section" do |c|
              link_to c.section.section_short_name, admin_program_section_path(c.section)
            end
            column "Academic Calendar" do |c|
              link_to c.academic_calendar.calender_year, admin_academic_calendar_path(c.academic_calendar)
            end
            column :year
            column :semester
            column :created_by
            column :updated_by 
            column "Add At", sortable: true do |c|
              c.created_at.strftime("%b %d, %Y")
            end
          end
        end
      end
    end
  end 
  # sidebar "program belongs to", :only => :show do
  #   table_for course.course_breakdowns do

  #     column "program" do |c|
  #       link_to c.program.program_name, admin_program_path(c.program.id)
  #     end
  #   end
  # end 
end

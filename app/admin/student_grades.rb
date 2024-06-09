ActiveAdmin.register StudentGrade do
  menu parent: "Grade"
  # index download_links: [:csv,:json, :xml, :pdf]
  # index download_links: [:xml, :pdf, :csv, :json]

  permit_params :department_approval, :approved_by, :approval_date, :course_registration_id, :student_id, :letter_grade, :grade_point, :assesment_total, :grade_point, :course_id, assessments_attributes: [:id, :student_grade_id, :assessment_plan_id, :student_id, :course_id, :result, :created_by, :updated_by, :_destroy]

  active_admin_import validate: true,
                      headers_rewrites: { "ID" => :student_id },
                      timestamps: true,
                      batch_size: 1000,
                      before_batch_import: ->(importer) {
                        student_ids = importer.values_at(:student_id)
                        students = Student.where(id: student_ids).pluck(:student_id, :id)
                        options = Hash[*students.flatten]
                        importer.batch_replace(:student_id, options)
                      }

  scoped_collection_action :scoped_collection_update, title: "Approve Grade", form: -> do
                                                        {
                                                          department_approval: ["pending", "approved", "denied"],
                                                        }
                                                      end
  member_action :generate_grade, method: :put do
    @student_grade = StudentGrade.find(params[:id])
    @student_grade.generate_grade
    redirect_back(fallback_location: admin_student_grade_path)
  end

  member_action :get_grade_from_lms, method: :put do
    @student_grade= StudentGrade.find(params[:id])
    @student_grade.moodle_grade
    redirect_back(fallback_location: admin_student_grade_path)
  end
  # member_action :generate_grade, method: :put do
  #   @student_grade = StudentGrade.find(params[:id])
  #   @student_grade.generate_grade
  #   redirect_back(fallback_location: admin_student_grade_path)
  # end

  batch_action "Generate Grade for", method: :put, confirm: "Are you sure?" do |ids|
    StudentGrade.find(ids).each do |sg|
      sg.generate_grade
    end
    redirect_to collection_path, notice: "Grade Is Generated Successfully"
  end
  batch_action "Approve Grade for", method: :put, confirm: "Are you sure?" do |ids|
    StudentGrade.find(ids).each do |student_grade|
      student_grade.update(department_approval: "approved", approved_by: "#{current_admin_user.name.full}", approval_date: Time.now)
    end
    redirect_to collection_path, notice: "Grade is Approved Successfully"
  end
  batch_action "Denied Grade for", method: :put, if: proc { current_admin_user.role == "department head" }, confirm: "Are you sure?" do |ids|
    StudentGrade.find(ids).each do |student_grade|
      student_grade.update(department_approval: "denied", approved_by: "#{current_admin_user.name.full}", approval_date: Time.now)
    end
    redirect_to collection_path, notice: "Grade Is Denied Successfully"
  end
  #  index download_links: [:xml, :pdf, :csv, :json]

  index do
    
    selectable_column
    column "Full name", sortable: true do |n|
      n.student.name.full if n.student.name.present?
    end
    column "Student ID" do |si|
      si.student.student_id
    end
    column "Program" do |si|
      si.student.program.program_name if si.student.program.present?
    end
    column "Course title" do |si|
      if si.course.present?
        si.course.course_title
      end
    end
    column :letter_grade
    column :grade_point
    column :assesment_total
    column :department_approval do |c|
      status_tag c.department_approval
    end
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end
  #  index download_links: [:xml, :pdf, :csv, :json]

  filter :student_id, as: :search_select_filter, url: proc { admin_students_path },
                      fields: [:student_id, :id], display_name: "student_id", minimum_input_length: 2,
                      order_by: "created_at_asc"
  filter :course_id, as: :search_select_filter, url: proc { admin_courses_path },
                     fields: [:course_title, :id], display_name: "course_title", minimum_input_length: 2,
                     order_by: "created_at_asc"
  filter :program_id, as: :search_select_filter, url: proc { admin_programs_path },
                      fields: [:program_name, :id], display_name: "program_name", minimum_input_length: 2,
                      order_by: "created_at_asc"
  filter :department_id, as: :search_select_filter, url: proc { admin_departments_path },
                         fields: [:department_name, :id], display_name: "department_name", minimum_input_length: 2,
                         order_by: "created_at_asc"
  filter :letter_grade
  filter :grade_point
  filter :assesment_total
  filter :created_at
  filter :updated_at
  filter :updated_by
  filter :created_by

  form :title => "New Student Grade" do |f|
    f.semantic_errors

    if object.new_record?
      if f.object.assessments.empty?
        f.object.assessments << Assessment.new
      end
      panel "Assessment" do
        f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full }

        f.has_many :assessments, heading: " ", remote: true, allow_destroy: true do |a|
          a.input :student_id, as: :search_select, url: proc { admin_students_path },
                               fields: [:student_id, :id], display_name: "student_id", minimum_input_length: 2,
                               order_by: "created_at_asc"
          a.input :course_id, as: :search_select, url: proc { admin_courses_path },
                              fields: [:course_title, :id], display_name: "course_title", minimum_input_length: 2,
                              order_by: "created_at_asc"
          # a.input :assessment_plan_id, as: :search_select, url: proc { admin_assessment_plans_path },
          #    fields: [:assessment_title, :id], display_name: 'assessment_title', minimum_input_length: 2,
          #    order_by: 'created_at_asc'
          a.input :assessment_plan_id, as: :search_select, url: proc { admin_assessment_plans_path },
                                       fields: [:assessment_title, :id], display_name: "assessment_title", minimum_input_length: 2,
                                       order_by: "created_at_asc", lebel: "Assessment Plan", :input_html => { :disabled => false }
          a.input :result
          a.label :_destroy
        end
      end
    end
    # if (current_admin_user.role == "instructor") || (current_admin_user.role == "admin")
    #   inputs 'Student Assessment' do
    #     f.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
    #     table(class: 'form-table') do
    #       tr do
    #         th 'Assessment Plan', class: 'form-table__col'
    #         th 'Assessment Weight', class: 'form-table__col'
    #         th 'Result', class: 'form-table__col'
    #       end
    #       f.semantic_fields_for :assessments, f.object.assessments do |a|
    #         render 'assessment', a: a
    #         a.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
    #       end
    #     end
    #   end
    # end
    if !f.object.new_record? && (params[:page_name] == "grade_approve")
      inputs "Department Approval" do
        f.input :department_approval, as: :select, :collection => ["pending", "approved", "denied"], :include_blank => false
        f.input :approved_by, as: :hidden, :input_html => { :value => current_admin_user.name.full }
        f.input :approval_date, as: :hidden, :input_html => { :value => Time.now }
      end
    end
    f.actions
  end

  action_item :new, only: :show, priority: 0 do
    if (current_admin_user.role == "registrar head") || (current_admin_user.role == "admin")
      link_to "Add Grade Change", new_admin_grade_change_path(course_id: "#{student_grade.course.id}", section_id: "#{student_grade.course_registration.semester_registration.section.id}", academic_calendar_id: "#{student_grade.course_registration.academic_calendar.id}", semester: "#{student_grade.course_registration.semester}", year: "#{student_grade.course_registration.year}", student_id: "#{student_grade.student.id}", course_registration_id: "#{student_grade.course_registration.id}", student_grade_id: "#{student_grade.id}", department_id: "#{student_grade.student.program.department.id}", program_id: "#{student_grade.student.program.id}")
    end
  rescue NoMethodError
    flash["error"] = "There is error"
  end

  action_item :new, only: :show, priority: 0 do
    if (current_admin_user.role == "registrar head") || (current_admin_user.role == "admin")
      link_to "Add Makeup exam", new_admin_makeup_exam_path(course_id: "#{student_grade.course.id}", section_id: "#{student_grade.course_registration.semester_registration.section.id}", academic_calendar_id: "#{student_grade.course_registration.academic_calendar.id}", semester: "#{student_grade.course_registration.semester}", year: "#{student_grade.course_registration.year}", student_id: "#{student_grade.student.id}", course_registration_id: "#{student_grade.course_registration.id}", student_grade_id: "#{student_grade.id}", department_id: "#{student_grade.student.program.department.id}", program_id: "#{student_grade.student.program.id}")
    end
  end
  action_item :edit, only: :show, priority: 1 do
    if (current_admin_user.role == "department head") || (current_admin_user.role == "admin")
      link_to "Approve Grade", edit_admin_student_grade_path(student_grade.id, page_name: "grade_approve")
    end
  end

  show :title => proc { |student| student.student.name.full } do
    columns do
      column do
        panel "Grade information" do
          attributes_table_for student_grade do
            row "full name", sortable: true do |n|
              n.student.name.full
            end
            row "Student ID" do |si|
              si.student.student_id
            end
            row "Course title" do |si|
              si.course.course_title
            end
            row "Program" do |pr|
              link_to pr.student.program.program_name, admin_program_path(pr.student.program.id)
            end
            row :letter_grade
            row :grade_point
            row :assesment_total
            row :department_approval do |c|
              status_tag c.department_approval
            end
            row :approved_by
            row "approval date" do |a|
              a.approval_date
            end
            row :created_at
            row :updated_at
          end
        end
      end
      column do
        panel "Assessments Information" do
          table_for student_grade.assessments do
            column :assessment_plan do |a|
              a.assessment_plan.assessment_title
            end
            column :assessment_weight do |a|
              a.assessment_plan.assessment_weight
            end
            column :result
            column "Graded At", sortable: true do |c|
              c.updated_at.strftime("%b %d, %Y")
            end
            column "Graded by", sortable: true do |c|
              c.updated_by
            end
          end
        end
      end
    end
  end
end

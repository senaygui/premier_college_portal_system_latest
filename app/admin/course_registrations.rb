ActiveAdmin.register CourseRegistration do
  menu parent: "Student managment"
  config.batch_actions = true
  permit_params :course_section,:enrollment_status,:course_section_id
  # active_admin_import
  scoped_collection_action :scoped_collection_update, title: 'Set Section', form: -> do
                                         { 
                                            section_id: Section.all.map { |section| [section.section_full_name, section.id] },
                                            
                                          }
                                        end

  controller do
    def scoped_collection
      # super.where(academic_calendar_id: AcademicCalendar.where("starting_date <= ? AND ending_date >= ?",Time.zone.now, Time.zone.now).order("created_at DESC").first).where(semester: Semester.where("starting_date <= ? AND ending_date >= ?",Time.zone.now, Time.zone.now).order("created_at DESC").first.semester).where("enrollment_status = ?", "enrolled")
      super.where("enrollment_status = ?", "enrolled")
    end
  end
  batch_action "Generate Grade Sheet", method: :put, confirm: "Are you sure?" do |ids|
    CourseRegistration.find(ids).each do |course_registration|
      course_registration.add_grade
    end
    redirect_to collection_path, notice: "Grade Sheet Is Generated Successfully"
  end
  index do
    selectable_column
    column "Student Name" do |s|
      s.student.name.full
    end
    column "Academic Year" do |s|
      s.get_academic_year
    end
    column :id do |c|
      c.student.student_id
    end
    column :course_title
    column :program do |c|
      c.program.program_name
    end
    column :section_name do |c|
      c.section.section_short_name if c.section.present?
    end
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end
end

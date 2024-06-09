ActiveAdmin.register AcademicCalendar do
permit_params :created_at,:calender_year_in_gc ,:calender_year_in_ec,:calender_year,:starting_date,:ending_date,:admission_type,:study_level,:remark,:from_year,:to_year,:last_updated_by,:created_by, activities_attributes: [:id,:activity,:semester,:description,:category,:starting_date,:ending_date,:last_updated_by,:created_by, :_destroy], semesters_attributes: [:id,:semester,:starting_date,:ending_date, :_destroy]
  menu parent: "College",priority: 2

  active_admin_import
  
  index do
    selectable_column
    column :calender_year
    column :admission_type
    column :study_level
    column :from_year
    column :to_year
    column "Activities", sortable: true do |c|
      c.activities.count
    end
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :calender_year
  filter :starting_date
  filter :ending_date
  filter :calender_year_in_gc
  filter :calender_year_in_ec
  filter :admission_type
  filter :study_level
  filter :from_year
  filter :to_year
  filter :created_at
  filter :updated_at
  filter :created_by
  filter :last_updated_by
  

  scope :recently_added
  scope :undergraduate
  scope :graduate
  scope :online
  scope :regular
  scope :extention
  scope :distance
  
  form do |f|
    f.semantic_errors
    f.inputs "Academic calendar information" do
      f.input :calender_year, label: "Calender title"
      f.input :calender_year_in_gc
      f.input :calender_year_in_ec
      f.input :starting_date, as: :date_time_picker 
      f.input :ending_date, as: :date_time_picker 
      f.input :admission_type, :collection => ["online", "regular", "extention", "distance"]
      f.input :study_level, as: :select, :collection => ["undergraduate", "graduate"]
      f.input :from_year
      f.input :to_year
      f.input :remark
      f.input :created_at, as: :date_time_picker 
      if f.object.new_record?
        f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      else
        f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      end      
    end

    if f.object.semesters.empty?
      f.object.semesters << Semester.new
    end
    panel "Semesters information" do
        f.has_many :semesters,heading: " ", remote: true, allow_destroy: true, new_record: true do |a|
            a.input :semester, as: :select, :collection => [1, 2,3,4], :include_blank => false
            a.input :starting_date, as: :date_time_picker 
            a.input :ending_date, as: :date_time_picker
            a.label :_destroy  
        end
    end
    if f.object.activities.empty?
      f.object.activities << Activity.new
    end
    panel "Activities information" do
        f.has_many :activities,heading: " ", remote: true, allow_destroy: true, new_record: true do |a|
            a.input :activity
            a.input :semester, as: :select, :collection => [1, 2,3,4], :include_blank => false
            a.input :starting_date, as: :date_time_picker 
            a.input :ending_date, as: :date_time_picker
            a.input :category, as: :select, :collection => ["registration","enterance exam","enterance exam result announcement","readmission","late registration", "class begining","add/drop","class ending", "examination period", "makeup examination application","grade submission","makeup examination day","makeup examination grade submission" ,"break","other"]
            a.input :description
            a.label :_destroy
            if a.object.new_record?
              a.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
            else
              a.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
            end  
        end
    end


    f.actions
  end

  show title: :calender_year do
    columns do
      column max_width: "27%" do 
        panel "Academic calendar information" do
          attributes_table_for academic_calendar do
            row :calender_year
            row :calender_year_in_gc
            row :calender_year_in_ec
            row :starting_date
            row :ending_date
            row :admission_type
            row :study_level
            row :from_year
            row :to_year
            row :remark
            row :created_by
            row :last_updated_by
            row :created_at
            row :updated_at
          end
        end
      end
      column min_width: "70%" do
        panel "Semesters" do
          table_for academic_calendar.semesters do
            ## TODO: wordwrap titles and long texts
            column :semester
            column :starting_date, sortable: true do |c|
              c.starting_date.strftime("%b %d, %Y")
            end
            column :ending_date, sortable: true do |c|
              c.ending_date.strftime("%b %d, %Y")
            end
            column :created_at, sortable: true do |c|
              c.created_at.strftime("%b %d, %Y")
            end
            column :updated_at, sortable: true do |c|
              c.updated_at.strftime("%b %d, %Y")
            end
          end
        end
        panel "Activities" do
          table_for academic_calendar.activities do
            ## TODO: wordwrap titles and long texts
            column :activity
            column :semester
            column :starting_date, sortable: true do |c|
              c.starting_date.strftime("%b %d, %Y")
            end
            column :ending_date, sortable: true do |c|
              c.ending_date.strftime("%b %d, %Y")
            end
            column :category
            column :description
          end
        end 
      end
    end
    
    
  end 
  # sidebar "program belongs to", :only => :show do
  #   table_for course.curriculums do

  #     column "program" do |c|
  #       link_to c.program.program_name, admin_program_path(c.program.id)
  #     end
  #   end
  # end
  
end

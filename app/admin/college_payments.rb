ActiveAdmin.register CollegePayment do
  menu parent: "Finance Setting"
  permit_params :study_level,:admission_type,:student_nationality,:registration_fee,:late_registration_fee,:makeup_exam_fee,:add_drop,:tution_per_credit_hr,:readmission,:reissuance_of_grade_report,:student_copy,:additional_student_copy,:tempo,:original_certificate,:original_certificate_replacement,:tempo_replacement,:letter,:student_id_card,:student_id_card_replacement,:name_change,:transfer_fee,:created_by, :last_updated_by, :total_fee,:starting_penalty_fee,:daily_penalty_fee

  index do
    selectable_column
    column :study_level
    column :admission_type
    number_column :total_fee, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
    ## TODO: add word wraper to created_by and last_updated_by
    column :created_by
    column :last_updated_by
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :study_level
  filter :admission_type
  filter :student_nationality
  filter :total_fee
  filter :registration_fee
  filter :late_registration_fee
  filter :starting_penalty_fee
  filter :daily_penalty_fee
  filter :makeup_exam_fee
  filter :add_drop
  filter :tution_per_credit_hr
  filter :readmission
  filter :reissuance_of_grade_report
  filter :student_copy
  filter :additional_student_copy
  filter :tempo
  filter :original_certificate
  filter :original_certificate_replacement
  filter :tempo_replacement
  filter :letter
  filter :student_id_card
  filter :student_id_card_replacement
  filter :name_change
  filter :transfer_fee
  filter :last_updated_by
  filter :created_by
  filter :created_at
  filter :updated_at

  scope :recently_added
  scope :undergraduate
  scope :graduate
  scope :online
  scope :regular
  scope :extention
  scope :distance
  
  form do |f|
    f.semantic_errors
    f.inputs "College payment information" do
      f.input :study_level, as: :select, :collection => ["undergraduate", "graduate"], :include_blank => false
      f.input :admission_type, :collection => ["online", "regular", "extention", "distance"], :include_blank => false
      f.input :student_nationality, :collection => ["local", "international"], :include_blank => false
      f.input :total_fee
      f.input :registration_fee
      f.input :late_registration_fee
      f.input :starting_penalty_fee
      f.input :daily_penalty_fee
      f.input :makeup_exam_fee
      f.input :add_drop
      f.input :tution_per_credit_hr
      f.input :readmission
      f.input :reissuance_of_grade_report
      f.input :student_copy
      f.input :additional_student_copy
      f.input :tempo
      f.input :original_certificate
      f.input :original_certificate_replacement
      f.input :tempo_replacement
      f.input :letter
      f.input :student_id_card
      f.input :student_id_card_replacement
      f.input :name_change
      f.input :transfer_fee

      if f.object.new_record?
        f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      else
        f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      end      
    end
    f.actions
  end

  show :title => proc{|payment| "#{payment.admission_type}, #{payment.study_level} payment fees" } do
    panel "College Payment information" do
      attributes_table_for college_payment do
        row :study_level
        row :admission_type
        row :student_nationality
        number_row :total_fee, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :registration_fee, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :late_registration_fee, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :makeup_exam_fee, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :add_drop, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :tution_per_credit_hr, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :starting_penalty_fee, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :daily_penalty_fee, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :readmission, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :reissuance_of_grade_report, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :student_copy, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :additional_student_copy, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :tempo, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :original_certificate, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :original_certificate_replacement, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :tempo_replacement, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :letter, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :student_id_card, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :student_id_card_replacement, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :name_change, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        number_row :transfer_fee, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
        row :last_updated_by
        row :created_by
        row :created_at
        row :updated_at
      end
    end
  end
  
end

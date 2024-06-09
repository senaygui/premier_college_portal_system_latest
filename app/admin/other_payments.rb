ActiveAdmin.register OtherPayment do
menu parent: "Student Payments"
actions :all, :except => [:new]
  config.clear_action_items!
  permit_params :payable_type,:payable_id, :total_price,:payment_type,:student_full_name,:student_id_number,:student_id,:section_id, :department_id, :program_id, :academic_calendar_id,:semester_registration_id,:invoice_number,:total_price,:invoice_status,:last_updated_by,:created_by,:due_date,:semester, :year,payment_transaction_attributes: [:id,:invoice_id,:payment_method_id,:account_holder_fullname,:phone_number,:account_number,:transaction_reference,:finance_approval_status,:last_updated_by,:created_by, :receipt_image], inovice_item_ids: []


  index do
    selectable_column
    # column "Invoice NO",:invoice_number
    column "Student" do |s|
      s.student_full_name
    end
    column "ID" do |s|
      s.student_id_number
    end
    column :payment_type
    column :invoice_status do |s|
      status_tag s.invoice_status
    end
    column :due_date, sortable: true do |c|
      c.due_date.strftime("%b %d, %Y")
    end
    column "Program", sortable: true do |n|
      link_to n.program.program_name, admin_programs_path(n.program)
    end
    column "Admission Type", sortable: true do |n|
      n.department.department_name
    end    
    number_column :total_price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
    column "Academic Year", sortable: true do |n|
      link_to n.academic_calendar.calender_year, admin_academic_calendar_path(n.academic_calendar)
    end
    column :semester
    column :year
    
    # column :mode_of_payment
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end
  filter :student_full_name
  filter :student_id_number
  filter :department_id, as: :search_select_filter, url: proc { admin_departments_path },
         fields: [:department_name, :id], display_name: 'department_name', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :program_id, as: :search_select_filter, url: proc { admin_programs_path },fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,order_by: 'id_asc'
  filter :academic_calendar_id, as: :search_select_filter, url: proc { admin_academic_calendars_path },
         fields: [:calender_year, :id], display_name: 'calender_year', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :year
  filter :semester
  filter :section_id, as: :search_select_filter, url: proc { admin_program_sections_path },
         fields: [:section_full_name, :id], display_name: 'section_full_name', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :invoice_number
  filter :total_price
  filter :penalty
  filter :daily_penalty
  filter :mode_of_payment
  filter :invoice_status
  filter :due_date
  filter :payment_type
  filter :last_updated_by
  filter :created_by
  filter :created_at
  filter :updated_at

  scope :recently_added
  scope :unpaid
  scope :pending
  scope :approved
  scope :denied
  scope :incomplete
  scope :due_date_passed
  # scope :undergraduate
  # scope :graduate
  # scope :online
  # scope :regular
  # scope :extention
  # scope :distance

  form :title => proc{|invoice| "Invoice NO ##{invoice.invoice_number}" } do |f|
    f.semantic_errors
    f.inputs 'payment transaction', for: [:payment_transaction, f.object.payment_transaction || PaymentTransaction.new] do |a|
      ## TODO: find way to hide the payment_transaction form if student fill it them self
      if params[:page_name] == "payment_transaction"
        a.input :payment_method_id, as: :search_select, url: admin_payment_methods_path,
            fields: [:bank_name, :id], display_name: 'bank_name', minimum_input_length: 2,
            order_by: 'id_asc'
        a.input :account_holder_fullname
        a.input :phone_number
        a.input :account_number
        a.input :transaction_reference
        a.input :receipt_image, as: :file
      end
      a.input :finance_approval_status, as: :select, :collection => ["pending", "approved", "re-submit", "denied", "under submitted"], :include_blank => false
      if a.object.new_record?
        a.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      else
        a.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      end 
    end
    f.inputs "invoice status" do
      f.input :invoice_status, as: :select, :collection => ["pending", "approved", "re-submit", "denied", "under submitted"], :include_blank => false
    end
    
    # f.actions
    f.actions do 
      f.action :submit, as: :button, label: 'Submit'
      li class: "cancel" do
        link_to 'Cancel', :back
      end
    end
    if f.object.new_record?
      f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
    else
      f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
    end 
  end

  action_item :edit, only: :show, priority: 1  do
    if ((current_admin_user.role == "admin") || (current_admin_user.role == "finance head")) && !(other_payment.payment_transaction.present?)
      link_to 'Add Payment Information', edit_admin_other_payment_path(other_payment.id, page_name: "payment_transaction")
    elsif ((current_admin_user.role == "admin") || (current_admin_user.role == "finance head")) && (other_payment.payment_transaction.present?)
      link_to 'Edit Payment Information', edit_admin_other_payment_path(other_payment.id, page_name: "payment_transaction")  
    end 
  end

  action_item :delete, only: :show, priority: 1  do
    if (current_admin_user.role == "admin") || (current_admin_user.role == "finance head")
      link_to "Delete Payment", admin_other_payment_path(other_payment), method: :delete, 'data-confirm': 'Invoice will be deleted forever. Are You Sure?' 
    end 
  end
  action_item :delete, only: :show, priority: 1  do
    if (current_admin_user.role == "admin") || (current_admin_user.role == "finance head")
      link_to "Approve Payment", edit_admin_other_payment_path(other_payment) 
    end 
  end


  show :title => proc{|invoice| "Invoice NO ##{invoice.invoice_number}" } do
    
    columns do
      column do
        panel "invoice summery" do
          attributes_table_for other_payment do
            row :invoice_number
            row "registration academic year" do |s|
              link_to s.semester_registration.academic_calendar.calender_year, admin_semester_registration_path(s.semester_registration.id)
            end
            row :invoice_status do |s|
              status_tag s.invoice_status
            end
            
            row :payment_type
            row :due_date if other_payment.due_date.present?
            number_row :total_price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
            row :created_by
            row :last_updated_by
            row :created_at
            row :updated_at
          end
        end
      end
      column do
        panel "Sender Information" do
          attributes_table_for other_payment.payment_transaction do
            row "account name" do |a|
              a.account_holder_fullname
            end 
            row :account_number 
            row :phone_number 
            row "payment method" do |pr|
              link_to pr.payment_method.bank_name, admin_payment_method_path(pr.payment_method.id)
            end
            # row "payment type" do |pr|
            #   pr.payment_method.payment_method_type
            # end
            row "reference no." do |pr|
              pr.transaction_reference
            end
            row "attachement" do |pr|
              link_to "attachement", rails_blob_path(pr.receipt_image, disposition: 'preview')
            end
            row "finance approval" do |s|
              status_tag s.finance_approval_status
            end
            row :created_by
            row :last_updated_by
            row :created_at
            row :updated_at
          end
        end
      end
      column do
        panel "Student Information" do
          attributes_table_for other_payment.semester_registration do
            row "Student name", sortable: true do |n|
              n.student.name.full 
            end
            row "student ID" do |s|
              s.student.student_id
            end
            row "Prorgam", sortable: true do |d|
              link_to d.student.program.program_name, [:admin, d.student.program]
            end
            row "admission type", sortable: true do |n|
              n.admission_type 
            end
            row "study level", sortable: true do |n|
              n.study_level 
            end
            row "year", sortable: true do |n|
              n.year 
            end
            row "semester", sortable: true do |n|
              n.student.semester 
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Invoice Item Information" do
          table_for other_payment.invoice_items do
            if other_payment.payable_type == "AddAndDrop"
              column "Course title" do |pr|
                link_to pr.course.course_title, admin_course_path(pr.course.id)
              end
            else 
              column :item_title
            end
            column "Course code" do |pr|
              pr.course.course_code
            end
            column "Course module" do |pr|
              link_to pr.course.course_module.module_code, admin_course_module_path(pr.course.course_module.id) 
            end
            column "Credit hour" do |pr|
              pr.course.credit_hour
            end
            number_column :price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
          end
        end
      end
    end
  end 
  
end

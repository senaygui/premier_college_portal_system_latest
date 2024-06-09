ActiveAdmin.register Invoice, as: "RegistrationPayment" do
  menu parent: "Student Payments"
  actions :all, :except => [:new]
  config.clear_action_items!
  permit_params :student_full_name,:student_id_number,:student_id, :department_id, :program_id, :academic_calendar_id,:semester_registration_id,:invoice_number,:total_price,:registration_fee,:late_registration_fee,:invoice_status,:last_updated_by,:created_by,:due_date,:semester, :year,payment_transaction_attributes: [:id,:invoice_id,:payment_method_id,:account_holder_fullname,:phone_number,:account_number,:transaction_reference,:finance_approval_status,:last_updated_by,:created_by, :receipt_image], inovice_item_ids: []
   

  # batch_action "Approve invoice status for", method: :put, confirm: "Are you sure?" do |ids|
  #   invoices = Invoice.where(id: ids)
  #   invoices.update_all(invoice_status: "approved")
    
  # end

  controller do
    after_action :testmoodle, only: [:update]

    def testmoodle
      if @registration_payment.payment_transaction.finance_approval_status == "approved"
        @moodle = MoodleRb.new('18425a712e7668d6339fa671fa05db04', 'https://lms.premiercollege.edu.et/webservice/rest/server.php')
        if !(@moodle.users.search(email: "#{@registration_payment.student.email}").present?)
          student = @moodle.users.create(
              :username => "#{@registration_payment.student.student_id.downcase}",
              :password => "#{@registration_payment.student.student_password}",
              :firstname => "#{@registration_payment.student.first_name}",
              :lastname => "#{@registration_payment.student.last_name}",
              :email => "#{@registration_payment.student.email}"
            )
          lms_student = @moodle.users.search(email: "#{@registration_payment.student.email}")
          @user = lms_student[0]["id"]
          @registration_payment.semester_registration.course_registrations.each do |c|
            s = @moodle.courses.search("#{c.course.course_code}")
            @course = s["courses"].to_a[0]["id"]
            @moodle.enrolments.create(
              :user_id => "#{@user}",
              :course_id => "#{@course}"
            )
          end
        end
      end
    end
  end  

  
  index do
    selectable_column
    # column "Invoice NO",:invoice_number
    column "Student" do |s|
      s.student.name.full
    end
    column "ID" do |s|
      s.student.student_id
    end
    column "Program", sortable: true do |n|
      n.program.program_name
    end
    column "Admission Type", sortable: true do |n|
      n.semester_registration.admission_type 
    end
    column "Study Level", sortable: true do |n|
      n.semester_registration.study_level 
    end
    column :invoice_status do |s|
      status_tag s.invoice_status
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
  filter :invoice_number
  filter :total_price
  filter :registration_fee
  filter :late_registration_fee
  filter :invoice_status
  filter :due_date
  filter :last_updated_by
  filter :created_by
  filter :created_at
  filter :updated_at

  scope :recently_added
  scope :pending
  scope :approved
  scope :denied
  scope :incomplete
  scope :unpaid
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
      if f.object.new_record?
        f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      else
        f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      end
    end
    
    # f.actions
    f.actions do 
      f.action :submit, as: :button, label: 'Submit'
      li class: "cancel" do
        link_to 'Cancel', :back
      end
    end
     
  end

  action_item :edit, only: :show, priority: 1  do
    if ((current_admin_user.role == "admin") || (current_admin_user.role == "finance head")) && !(registration_payment.payment_transaction.present?)
      link_to 'Add Payment Information', edit_admin_registration_payment_path(registration_payment.id, page_name: "payment_transaction")
    elsif ((current_admin_user.role == "admin") || (current_admin_user.role == "finance head")) && (registration_payment.payment_transaction.present?) && !(registration_payment.created_by == "self")
      link_to 'Edit Payment Information', edit_admin_registration_payment_path(registration_payment.id, page_name: "payment_transaction")  
    end 
  end

  action_item :delete, only: :show, priority: 1  do
    if (current_admin_user.role == "admin") || (current_admin_user.role == "finance head")
      link_to "Delete Invoice", admin_registration_payment_path(registration_payment), method: :delete, 'data-confirm': 'Invoice will be deleted forever. Are You Sure?' 
    end 
  end
  action_item :delete, only: :show, priority: 1  do
    if (current_admin_user.role == "admin") || (current_admin_user.role == "finance head")
      link_to "Approve Invoice", edit_admin_registration_payment_path(registration_payment) 
    end 
  end


  show :title => proc{|invoice| "Invoice NO ##{invoice.invoice_number}" } do
    
    columns do
      column do
        panel "invoice summery" do
          attributes_table_for registration_payment do
            row :invoice_number
            row "registration academic year" do |s|
              link_to s.semester_registration.academic_calendar.calender_year, admin_semester_registration_path(s.semester_registration.id)
            end
            row :invoice_status do |s|
              status_tag s.invoice_status
            end
            
            row "payment mode", sortable: true do |n|
              n.semester_registration.mode_of_payment
            end
            row :due_date if registration_payment.due_date.present?
            number_row :registration_fee, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2 if registration_payment.registration_fee > 0
            number_row :late_registration_fee, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2 if registration_payment.late_registration_fee > 0 
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
          attributes_table_for registration_payment.payment_transaction do
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
          attributes_table_for registration_payment.semester_registration do
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
          table_for registration_payment.invoice_items do
            column "Course title" do |pr|
              link_to pr.course_registration.course.course_title, admin_course_path(pr.course_registration.course.id)
            end
            column "Course code" do |pr|
              pr.course_registration.course.course_code
            end
            column "Course module" do |pr|
              link_to pr.course_registration.course.course_module.module_code, admin_course_module_path(pr.course_registration.course.course_module.id) 
            end
            column "Credit hour" do |pr|
              pr.course_registration.course.credit_hour
            end
            number_column :price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
          end
        end
      end
    end
    
    
  end 
  
end

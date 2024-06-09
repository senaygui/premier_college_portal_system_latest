Rails.application.routes.draw do
  get "student_temporary/index", as: "student_temporary"
  post "student/tempo/generate", to: "student_temporary#generate_pdf", as: "generate_student_tempo"
  get "pdf_grade_reports/index", as: "pdf_gread_report"
  get "prepare_pdf.pdf", to: "pdf_grade_reports#prepare_pdf"
  get "student/tempo/generate.pdf", to: "student_temporary#generate_pdf"
  get "graduation/approval", to: "student_temporary#graduation_approval", as: "graduation_approval"
  get "graduation/approval/form", to: "student_temporary#graduation_approval_form", as: "graduation_approval_form"
  get "approved", to: "student_temporary#approved", as: "approved"
  get "student/generate/copy", to: "student_copy#index", as: "student_copy"
  post "student_copy/generate_student_copy", as: "generate_student_copy"
  get "new/semester/registration", to: "pages#enrollement", as: "enrollement"
  post "create/semester/registration", to: "pages#create_semester_registration", as: "create_semester_registration"
  get "student/grade/report/:year/:semester", to: "grade_reports#student_grade_report", as: "student_grade_report"
  get "prepare/payment/:semester_registration_id", to: "invoices#prepare_payment", as: "prepare_payment"
  post "create/invoice", to: "invoices#create_invoice_for_remaining_amount", as: "create_invoice_for_remaining_amount"
  get "payment/report/fetch/student", to: "payment_report#fetch_student", as: "payment_report_fetch_student"
  get "get/year", to: "payment_report#get_year", as: "payment_report_get_year"
  get "get/semester", to: "payment_report#get_semester", as: "payment_report_get_semester"
  get "student/report", to: "student_report#get_student_list", as: "student_report"
  get "/student/report/year", to: "student_report#student_report_year", as: "student_report_year"
  get "/student/report/program", to: "student_report#student_report_program", as: "student_report_program"
  get "/student/gc/program", to: "student_report#student_report_gc", as: "student_report_gc"
  get "/student/report/gc/year", to: "student_report#student_report_gc_year", as: "student_report_gc_year"
  get "/student/report/semester", to: "student_report#student_report_semester", as: "student_report_semester"
  get "/prepare/online/student/grade", to: "online_student_grade#prepare", as: "online_student_grade_prepare"
  post "/student/pdf/report.pdf", to: "student_report#student_report_pdf", as: "student_report_pdf"
  post "generate/payment/report.pdf", to: "payment_report#generate_payment_report", as: "generate_payment_report"
  get "/online/student/grade", to: "online_student_grade#online_grade", as: "online_grade"
  post "/approve/online/student/grade", to: "online_student_grade#approve_grade", as: "approve_online_grade"
  resources :grade_reports
  resources :academic_calendars, only: [:show, :index]
  devise_for :students, controllers: {
                          registrations: "registrations",
                        }
  authenticated :student do
    root "pages#dashboard", as: "authenticated_user_root"
  end
  devise_scope :student do
    put "update/highschool/transcript", to: "registrations#update_highschool_transcript", as: "update_highschool_transcript"
    put "update/grade/10/matric", to: "registrations#update_grade_10_matric", as: "update_grade_10_matric"
    put "update/grade/12/matric", to: "registrations#update_grade_12_matric", as: "update_grade_12_matric"
    put "update/coc", to: "registrations#update_coc", as: "update_coc"
    put "update/profile/photo", to: "registrations#update_profile_photo", as: "update_profile_photo"
    put "update/diploma/certificate", to: "registrations#update_diploma_certificate", as: "update_diploma_certificate"
    put "update/degree/certificate", to: "registrations#update_degree_certificate", as: "update_degree_certificate"
  end

  post "prepare_pdf", to: "pdf_grade_reports#prepare_pdf", as: "prepare_pdf"
  get "admission" => "pages#admission"
  get "documents" => "pages#documents", as: "documents"
  get "profile" => "pages#profile", as: "profile"
  get "grade_report" => "pages#grade_report"
  get "digital-iteracy-quiz" => "pages#digital_iteracy_quiz"
  get "requirements" => "pages#requirement"
  get "home" => "pages#home"
  resources :almunis
  resources :semester_registrations
  resources :invoices
  resources :profiles

  resources :payment_methods
  resources :payment_transactions
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: "pages#home"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root to: 'application#home'
end

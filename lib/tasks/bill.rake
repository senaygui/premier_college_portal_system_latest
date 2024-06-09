namespace :bill do
  task :monthly => :environment do
    puts "[#{Time.now}]] Create and send monthly bill to students"
    SemesterRegistration.where("remaining_amount > ?", 0.0).where(mode_of_payment: "Monthly Payment").each do |sm|
      RecurringPayment.create do |invoice|
        invoice.semester_registration_id = sm.id
        invoice.student_id = sm.student_id
        invoice.academic_calendar_id = sm.academic_calendar_id
        invoice.department_id = sm.department_id
        invoice.program_id = sm.program_id
        invoice.section_id = sm.section_id
        invoice.semester = sm.semester
        invoice.year = sm.year
        invoice.student_full_name = sm.student_full_name
        invoice.student_id_number = sm.student_id_number
        invoice.invoice_number = SecureRandom.random_number(1000..1000000)
        tution_price =  (sm.course_registrations.collect { |oi| oi.valid? ? (CollegePayment.where(study_level: sm.study_level,admission_type: sm.admission_type).first.tution_per_credit_hr * oi.course.credit_hour) : 0 }.sum) / 4       
        invoice.penalty = 0.0
        invoice.daily_penalty = 0.0
        invoice.total_price = tution_price
        invoice.invoice_status = "unpaid"
        invoice.mode_of_payment = sm.mode_of_payment
        invoice.created_by = "system"
        invoice.due_date = Time.now + 10.day 
      end
    end
  end
  task :half_semester => :environment do
    puts "[#{Time.now}]] Create and send monthly bill to students"
    SemesterRegistration.where("remaining_amount > ?", 0.0).where(mode_of_payment: "Half Semester Payment").each do |sm|
      RecurringPayment.create do |invoice|
        invoice.semester_registration_id = sm.id
        invoice.student_id = sm.student_id
        invoice.academic_calendar_id = sm.academic_calendar_id
        invoice.department_id = sm.department_id
        invoice.program_id = sm.program_id
        invoice.section_id = sm.section_id
        invoice.semester = sm.semester
        invoice.year = sm.year
        invoice.student_full_name = sm.student_full_name
        invoice.student_id_number = sm.student_id_number
        invoice.invoice_number = SecureRandom.random_number(1000..1000000)
        tution_price =  (sm.course_registrations.collect { |oi| oi.valid? ? (CollegePayment.where(study_level: sm.study_level,admission_type: sm.admission_type).first.tution_per_credit_hr * oi.course.credit_hour) : 0 }.sum) / 2       
        invoice.penalty = 0.0
        invoice.daily_penalty = 0.0
        invoice.total_price = tution_price
        invoice.invoice_status = "unpaid"
        invoice.mode_of_payment = sm.mode_of_payment
        invoice.created_by = "system"
        invoice.due_date = Time.now + 10.day 
      end
    end
  end

  task :starting_penalty_fee => :environment do
    puts "[#{Time.now}]] add starting penalty fee for due date passed recurring payment"
    RecurringPayment.where("due_date < ?", Time.now).where(invoice_status: "unpaid").where(penalty: 0.0).each do |pe|
      penalty = CollegePayment.where(study_level: pe.semester_registration.study_level,admission_type: pe.semester_registration.admission_type).first.starting_penalty_fee
      pe.update_columns(penalty: penalty)
      total = pe.total_price + penalty
      pe.update_columns(penalty: total)
    end
  end

  task :daily_penalty_fee => :environment do
    puts "[#{Time.now}]] add penalty fee for due date passed recurring payment"
    RecurringPayment.where("due_date < ?", Time.now).where(invoice_status: "unpaid").where("penalty > ?", 0).each do |pe|
      penalty = (CollegePayment.where(study_level: pe.semester_registration.study_level,admission_type: pe.semester_registration.admission_type).first.daily_penalty_fee) + pe.daily_penalty
      pe.update_columns(daily_penalty: penalty)
      total = pe.total_price + penalty + pe.penalty
      pe.update_columns(total_price: total)
      remaining_amount = penalty + pe.penalty + pe.semester_registration.remaining_amount
      pe.semester_registration.update_columns(remaining_amount: remaining_amount)
      pe.semester_registration.update_columns(penalty: penalty + pe.penalty)
    end
  end


end


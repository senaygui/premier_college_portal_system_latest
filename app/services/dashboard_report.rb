module DashboardReport
  class << self
    def admission_report
      Rails.cache.fetch(["admission", __method__], expires_in: 60.minutes) do
        Student.where(graduation_status: "pending").group(:admission_type).count
      end
    end

    def graduation_status
      Rails.cache.fetch(["graduation_status", __method__], expires_in: 60.minutes) do
        Student.where(graduation_status: "pending").group(:study_level).count
      end
    end

    def departement
      Rails.cache.fetch(["departement", __method__], expires_in: 60.minutes) do
        Student.all.joins(:department).group("departments.department_name").count
      end
    end

    def program
      Rails.cache.fetch(["program", __method__], expires_in: 60.minutes) do
        Student.all.joins(:program).group("programs.program_name").count
      end
    end

    def document_verification
      Rails.cache.fetch(["document_verification", __method__], expires_in: 60.minutes) do
        Student.group(:document_verification_status).count
      end
    end

    def account_verification
      Rails.cache.fetch(["account_verification", __method__], expires_in: 60.minutes) do
        Student.group(:account_verification_status).count
      end
    end

    def chart_batch
      Rails.cache.fetch(["chart_batch", __method__], expires_in: 60.minutes) do
        Student.group(:batch).count
      end
    end

    def chart_addmission_type
      Rails.cache.fetch(["chart_addmission_type", __method__], expires_in: 60.minutes) do
        Student.group(:admission_type).count
      end
    end

    def chart_study_level
      Rails.cache.fetch(["chart_study_level", __method__], expires_in: 60.minutes) do
        Student.group(:study_level).count
      end
    end

    def chart_departement
      Rails.cache.fetch(["chart_departement", __method__], expires_in: 60.minutes) do
        Student.all.joins(:department).group("departments.department_name").count
      end
    end

    def chart_program
      Rails.cache.fetch(["chart_program", __method__], expires_in: 60.minutes) do
        Student.all.joins(:program).group("programs.program_name").count
      end
    end

    def chart_account_verification
      Rails.cache.fetch(["chart_account_verification", __method__], expires_in: 60.minutes) do
        Student.group(:account_verification_status).count
      end
    end

    def chart_document_verification
      Rails.cache.fetch(["chart_document_verification", __method__], expires_in: 60.minutes) do
        Student.group(:document_verification_status).count
      end
    end

    def faculties
      Rails.cache.fetch(["faculties", __method__], expires_in: 60.minutes) do
        Department.all.joins(:faculty).group("faculties.faculty_name").count
      end
    end

    def courses
      Rails.cache.fetch(["courses", __method__], expires_in: 60.minutes) do
        Course.all.joins(:program).group("programs.program_name").count
      end
    end

    def department_head_filter(current_admin_user)
      Rails.cache.fetch(["department_head_filter", __method__], expires_in: 60.minutes) do
        RoleFilter.department_head_filter(current_admin_user)
      end
    end

    def departement_and_program
      Rails.cache.fetch(["departement_and_program", __method__], expires_in: 60.minutes) do
        Program.all.joins(:department).group("departments.department_name").count
      end
    end

    def department_curriculum_filter(current_admin_user)
      Rails.cache.fetch(["department_curriculum_filter", __method__], expires_in: 60.minutes) do
        RoleFilter.department_curriculum_filter(current_admin_user)
      end
    end

    def program_and_curriculum
      Rails.cache.fetch(["program_and_curriculum", __method__], expires_in: 60.minutes) do
        Program.all.joins(:curriculums).group("programs.program_name").count
      end
    end

    def chart_departement_and_faculity
      Rails.cache.fetch(["chart_departement_and_faculity", __method__], expires_in: 60.minutes) do
        Department.all.joins(:faculty).group("faculties.faculty_name").count
      end
    end

    def chart_course_and_program
      Rails.cache.fetch(["chart_course_and_program", __method__], expires_in: 60.minutes) do
        Course.all.joins(:program).group("programs.program_name").count
      end
    end

    def chart_departement_program
      Rails.cache.fetch(["chart_departement_program", __method__], expires_in: 60.minutes) do
        Program.all.joins(:department).group("departments.department_name").count
      end
    end

    def chart_program_and_curriculum
      Rails.cache.fetch(["chart_program_and_curriculum", __method__], expires_in: 60.minutes) do
        Program.all.joins(:curriculums).group("programs.program_name").count
      end
    end

    def invoice_report
      Rails.cache.fetch(["invoice_report", __method__], expires_in: 60.minutes) do
        Program.all.joins(:invoices).group("programs.program_name", :invoice_status).count
      end
    end

    def chart_invoice_report
      Rails.cache.fetch(["chart_invoice_report", __method__], expires_in: 60.minutes) do
        Program.all.joins(:invoices).group(:invoice_status).count
      end
    end
  end
end

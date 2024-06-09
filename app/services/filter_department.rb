module FilterDepartment
  class << self
    def get_online_department
      Rails.cache.fetch(["online_department", __method__], expires_in: 60.minutes) do
        Student.where(admission_type: "online").where.not(department_id: nil).distinct.select(:department_id).includes(:department)
      end
    end
  end
end

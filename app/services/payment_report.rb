module PaymentReport
  class << self
    def departements
      Rails.cache.fetch(["payment_report_smr", __method__], expires_in: 30.minutes) do
        SemesterRegistration.distinct.select(:department_id)
      end
    end
  end
end

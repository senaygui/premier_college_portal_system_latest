require "rails_helper"

RSpec.describe "StudentReportController", type: :request do
  before(:all) do
    program = Program.create!()
    Student.create!(email: "meshu@gmail.com", first_name: "Meshu", last_name: "Amare", gender: "Male", date_of_birth: "2006-03-01 00:00:00.000000000 +0000", place_of_birth: "Addis", marital_status: "Single", nationality: "ET")
  end
  headers = { "ACCEPT" => "application/json" }

  context "get_student_list action " do
    it "should return success status" do
      get "/student/report", params: { graduation_status: "approved" }, headers: headers
      expect(response).to have_http_status(:success)
    end
  end

  context "student" do
    it "should return httmp success status" do
      get "/student/report/year", headers: headers, params: {program: ""}
    end
  end
end

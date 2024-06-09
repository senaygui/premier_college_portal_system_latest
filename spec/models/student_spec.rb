require "rails_helper"

RSpec.describe Student, type: :model do
  before(:all) do
    Student.create(email: "meshu@gmail.com", first_name: "Meshu", last_name: "Amare", gender: "Male", date_of_birth: "2006-03-01 00:00:00.000000000 +0000", place_of_birth: "Addis", marital_status: "Single", nationality: "ET")
  end
  let(:student) do
    Student.find_by(email: "meshu@gmail.com")
  end

  context "When created" do
    it "should return the object" do
      expect(student).to be_nil
    end
  end
end

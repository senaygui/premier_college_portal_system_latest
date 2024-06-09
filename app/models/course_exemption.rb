class CourseExemption < ApplicationRecord
  belongs_to :course
  belongs_to :exemptible, polymorphic: true
end

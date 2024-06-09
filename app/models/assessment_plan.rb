class AssessmentPlan < ApplicationRecord
  # before_create :limit_assessment_plan
  ##validations
    validates :assessment_title, presence: true
    validates :assessment_weight, presence: true, numericality: { greater_than_or_equal_to: 1,less_than_or_equal_to: 100 }
    validate :limit_assessment_plan
  
  ##associations
    belongs_to :course
    has_many :assessments

  
  private
    def limit_assessment_plan
      if self.course.assessment_plans.pluck(:assessment_weight).sum > 101
        self.errors[:assessment_weight] << "The assessment plan reached the maximum value"
      end
    end
  
end

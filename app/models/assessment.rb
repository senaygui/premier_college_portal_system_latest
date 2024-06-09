class Assessment < ApplicationRecord
	##vaildations
		# validate :limit_assessment_result
	##associations
		belongs_to :student_grade
		belongs_to :student, optional: true
		belongs_to :course , optional: true
		belongs_to :assessment_plan, optional: true
		has_many :grade_changes
		has_many :makeup_exams

  


  private
    def limit_assessment_result
      if self.result > self.assessment_plan.assessment_weight
        self.errors[:result] << "The assessment result reached the maximum value"
      end
    end
end

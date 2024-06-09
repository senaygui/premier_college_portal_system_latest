class AddFinalExamStatusToAssessmentPlan < ActiveRecord::Migration[5.2]
  def change
  	add_column :assessment_plans, :final_exam, :boolean, default: false
  end
end

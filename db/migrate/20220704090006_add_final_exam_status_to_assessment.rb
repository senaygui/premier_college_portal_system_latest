class AddFinalExamStatusToAssessment < ActiveRecord::Migration[5.2]
  def change
  	add_column :assessments, :final_exam, :boolean, default: false
  end
end

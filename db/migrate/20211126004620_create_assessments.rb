class CreateAssessments < ActiveRecord::Migration[5.2]
  def change
    create_table :assessments, id: :uuid  do |t|
    	t.belongs_to :student, index: true, type: :uuid
    	t.belongs_to :course, index: true, type: :uuid
    	t.belongs_to :student_grade, index: true, type: :uuid
    	t.belongs_to :assessment_plan, index: true, type: :uuid
    	t.decimal :result
    	t.string :created_by
    	t.string :updated_by
      t.timestamps
    end
  end
end

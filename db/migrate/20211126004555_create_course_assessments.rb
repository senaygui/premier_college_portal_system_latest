class CreateCourseAssessments < ActiveRecord::Migration[5.2]
  def change
    create_table :course_assessments, id: :uuid do |t|
    	t.belongs_to :curriculums, index: true, type: :uuid
    	t.integer :weight
    	t.string :assessment
      t.timestamps
    end
  end
end

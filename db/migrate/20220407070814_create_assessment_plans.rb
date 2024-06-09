class CreateAssessmentPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :assessment_plans, id: :uuid  do |t|
      t.belongs_to :course, index: true, type: :uuid
      t.string :assessment_title, null: false
      t.decimal :assessment_weight, null: false
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end

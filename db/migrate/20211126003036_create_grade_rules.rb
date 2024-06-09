class CreateGradeRules < ActiveRecord::Migration[5.2]
  def change
    create_table :grade_rules, id: :uuid do |t|
    	t.string :admission_type
      t.string :study_level
      t.integer :min_cgpa_value_to_pass
      t.timestamps
    end
  end
end

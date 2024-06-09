class CreateSchoolOrUniversityInformations < ActiveRecord::Migration[5.2]
  def change
    create_table :school_or_university_informations, id: :uuid do |t|
      t.belongs_to :student, index: true, type: :uuid
      t.string :college_or_university
      t.string :phone_number
      t.string :address
      t.string :field_of_specialization
      t.decimal :cgpa
      t.string :last_attended_high_school
      t.string :school_address
      t.decimal :grade_10_result
      t.datetime :grade_10_exam_taken_year
      t.decimal :grade_12_exam_result
      t.datetime :grade_12_exam_taken_year
      t.string :level
      t.datetime :coc_attendance_date
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
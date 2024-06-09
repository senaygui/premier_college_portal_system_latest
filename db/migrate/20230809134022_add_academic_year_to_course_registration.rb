class AddAcademicYearToCourseRegistration < ActiveRecord::Migration[7.0]
  def change
    add_column :course_registrations, :academic_year, :integer
  end
end

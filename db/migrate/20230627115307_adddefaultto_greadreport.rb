class AdddefaulttoGreadreport < ActiveRecord::Migration[7.0]
  def change
    change_column_default :grade_reports, :dean_approval, from: 'pending', to: 'approved'
  end
end

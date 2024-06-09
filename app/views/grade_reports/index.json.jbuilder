json.set! :data do
  json.array! @grade_reports do |grade_report|
    json.partial! 'grade_reports/grade_report', grade_report: grade_report
    json.url  "
              #{link_to 'Show', grade_report }
              #{link_to 'Edit', edit_grade_report_path(grade_report)}
              #{link_to 'Destroy', grade_report, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end
module ApplicationHelper
	def current_class?(test_path)
    return 'nav-link active' if request.path == test_path
    ''
  end
  def status_tag(boolean, options={})
    options[:true] ||= ''
    options[:true_class] ||= 'status true'
    options[:false] ||= ''
    options[:false_class] ||= 'status false'

    if boolean
      content_tag(:span, options[:true], :class => options[:true_class])
    else
      content_tag(:span, options[:false], :class => options[:false_class])
    end
  end

  def current_academic_calendar(study_level, admission_type)
      @current_academic_calendar ||= AcademicCalendar.where(study_level: study_level).where(admission_type: admission_type).where("starting_date <= ? AND ending_date >= ?",Time.zone.now, Time.zone.now).first
  end
  def current_semester(study_level, admission_type)
      @current_semester ||= ::Semester.where(academic_calendar_id: AcademicCalendar.where(study_level: study_level).where(admission_type: admission_type).where("starting_date <= ? AND ending_date >= ?",Time.zone.now, Time.zone.now).first).where("starting_date <= ? AND ending_date >= ?",Time.zone.now, Time.zone.now).first
  end
  # def my_current_semester(study_level, admission_type)
	# 	@current_semester ||= SemesterRegistration.find_by(study_level: study_level, admission_type: admission_type).semester
	# end
end
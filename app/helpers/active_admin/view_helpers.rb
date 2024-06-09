module ActiveAdmin::ViewsHelper
	def current_academic_calendar(study_level, admission_type)
	    @current_academic_calendar ||= AcademicCalendar.where(study_level: study_level, admission_type: admission_type).where("starting_date <= ? AND ending_date >= ?",Time.zone.now, Time.zone.now).order("created_at DESC").first
	end
	def current_semester(study_level, admission_type)
	    @current_semester ||= ::Semester.where(academic_calendar_id: AcademicCalendar.where(study_level: study_level, admission_type: admission_type).where("starting_date <= ? AND ending_date >= ?",Time.zone.now, Time.zone.now).order("created_at DESC").first).where("starting_date <= ? AND ending_date >= ?",Time.zone.now, Time.zone.now).order("created_at DESC").first.semester
	end

	def my_current_semester(study_level, admission_type)
		@current_semester ||= SemesterRegistration.find_by(study_level: study_level, admission_type: admission_type).semester
	end
end
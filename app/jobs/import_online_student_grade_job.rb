class ImportOnlineStudentGradeJob < ApplicationJob
  queue_as :default #set the queue with the deafult queue

  after_perform do
    flash[:success] = "Job completed successfully!"
  end

  def perform(year, semester)
    ids = Student.get_online_student(year, semester)
    crs = CourseRegistration.get_course_per_student(ids)
    result = StudentGrade.create_student_grade(crs)
    redirect_to admin_onlinestudentgrade_path, notice: "Successfuly import #{result} students grade from LMS" if result > 0
    redirect_to admin_onlinestudentgrade_path, alert: "No student grades have been imported. This may be because the student is not available or their grade has already been imported." if result.zero?
  end
end

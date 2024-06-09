class Major
  def self.major_point_and_hour(crg)
    hour = 0
    point = 0
    crg.each do |cr|
      if cr.course.major?
        hour += cr.course.credit_hour
        point += cr.course.student_grades.last.grade_point
      end
    end
    [hour, point]
  end
end

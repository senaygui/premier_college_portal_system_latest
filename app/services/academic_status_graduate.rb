module AcademicStatusGraduate
  class << self
    def get_academic_status(report:, student:)
      if is_semester_year?(student: student, year: 1, semester: 1)
        if report.sgpa >= 3 && report.sgpa <= 4
          "Academic Pass"
        elsif report.sgpa >= 2.5 && report.sgpa < 3
          "Academic Probation"
        elsif report.sgpa < 2.5
          "Academic Dismissal"
        end
      else
        if is_pass_first_semester?(student: student)
          if report.sgpa >= 3 && report.sgpa <= 4
            "Academic Pass"
          elsif report.sgpa >= 2.5 && report.sgpa < 3 && report.cgpa >= 3 # need some checking to see if
            "Academic Probation"
          elsif (report.sgpa >= 2.5 && report.sgpa < 3) && (report.cgpa >= 2.5 && report.cgpa < 3)
            "Academic Probation"
          end
        elsif is_probation_first_semester?(student: student)
          if report.sgpa < 3
            "Academic Dismissal"
          elsif report.sgpa >= 3 && report.cgpa < 3
            "Final Probation"
          else
            "Academic Pass"
          end
        end
      end
    end

    private

    def is_semester_year?(student:, year:, semester:)
      student.year == year && student.semester == semester
    end

    def is_pass_first_semester?(student:)
      GradeReport.where(student: student, semester: 1, academic_status: "Academic Pass").any?
    end

    def is_probation_first_semester?(student:)
      GradeReport.where(student: student, semester: 1, academic_status: "Academic Probation").any?
    end
  end
end

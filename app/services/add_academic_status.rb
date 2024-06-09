module AddAcademicStatus
  class << self
    def academic_status(report, student)
      if report[:sgpa] >= 3.75 && report[:sgpa] <= 4
        "Very Grate Distinction"
      elsif report[:sgpa] >= 3.5 && report[:sgpa] < 3.75
        "Grate Distinction"
      elsif report[:sgpa] >= 3.25 && report[:sgpa] < 3.5
        "Distinction"
      elsif report[:sgpa] >= 1.75 && report[:sgpa] < 2
        "Academic Warning"
      elsif is_semester_year?(student: student, year: 1, semester: 1)
        first_year_first_semester(report: report)
      elsif is_semester_year?(student: student, year: 1, semester: 2)
        first_year_second_semester(report: report, student: student)
      elsif is_semester_year?(student: student, year: 2, semester: 1)
        second_year_first_semester(report: report, student: student)
      elsif is_semester_year?(student: student, year: 2, semester: 2)
        second_year_second_semester(report: report, student: student)
      elsif student.year == 3
        above_three_year(report: report, student: student)
      end
    end

    private

    def is_semester_year?(student:, year:, semester:)
      student.year == year && student.semester == semester
    end

    def first_year_first_semester(report:)
      if report[:sgpa] >= 1.5 && report[:sgpa] < 1.75
        "Academic Probation"
      elsif report[:sgpa] >= 1 && report[:sgpa] < 1.5
        if false # change the condition
          # Check the wheather this student can re-admit or not
        else
          "Academic Suspension"
        end
      else
        "Academic Dismissal"
      end
    end

    def is_warning_before?(student:)
      # is it any warning or with sepesific semester and year
      GradeReport.where(student: student, academic_status: "Academic Warning").any?
    end

    def is_previous_sgpa_below?(student:, sgpa:, cgpa:)
      GradeReport.where(student: student).where("sgpa < #{sgpa}").where("cgpa < #{cgpa}").any?
    end

    def first_year_second_semester(report:, student:)
      if ((report[:sgpa] >= 1.5 && report[:sgpa] < 1.75) || is_warning_before?(student: student))
        "Academic Probation"
      elsif report[:sgpa] >= 1.25 && report[:sgpa] < 1.5
        if false # change the condition
          # Check the wheather this student can re-admit or not
        else
          "Academic Suspension"
        end
      elsif (report[:sgpa] < 1.25 || is_previous_sgpa_below?(student: student, sgpa: 1.25, cgpa: 1.5)) && report[:cgpa] < 1.5
        #  check for re-admited students
        "Academic Dismissal"
      end
    end

    def is_probation_before?(student:)
      GradeReport.where(student: student, academic_status: "Academic Probation").any?
    end

    def second_year_first_semester(report:, student:)
      if ((report[:sgpa] >= 1.5 && report[:sgpa] < 1.75) || is_warning_before?(student: student))
        "Academic Probation"
      elsif is_probation_twice?(student: student)
        "Academic Suspension"
      elsif (report[:sgpa] < 1.5 || report[:cgpa] < 2) && (is_warning_before?(student: student) || is_probation_before?(student: student))
        "Academic Suspension"
      else
        if false # change to re-admitional
        else # for non-admitted student
          if report[:sgpa] < 1.25 || report[:cgpa] < 1.5
            "Academic Dismissal"
          end
        end
      end
    end

    def is_probation_twice?(student:)
      GradeReport.where(student: student, academic_status: "Academic Probation").count >= 2
    end

    def is_subsequent_semester_dismissal?(student:, sgpa:, cgpa:)
      GradeReport.where(student: student).where("sgpa<#{sgpa}").where("cgpa < #{cgpa}").count >= 2
    end

    def is_subsequent_semester_probation?(student:, min_sgpa:, max_sgpa:, cgpa:)
      GradeReport.where(student: student).where("sgpa >= #{min_sgpa}").where("sgpa < #{max_sgpa}").where("cgpa >= #{cgpa}").count >= 2
    end

    def second_year_second_semester(report:, student:)
      if is_probation_twice?(student: student)
        "Academic Suspension"
      elsif (is_probation_before?(student: student) || is_warning_before?(student: student))
        if report[:cgpa] < 2 || report[:sgpa] < 1.5
          "Academic Suspension"
        else
          # DO ADMISSION RELATED ISSUES WITH OTHER ISSUES
        end
      elsif ((report[:sgpa] >= 1.5 && report[:sgpa] < 1.75) || is_subsequent_semester_probation?(student: student, min_sgpa: 1, max_sgpa: 1.5, cgpa: 1.75)) # is_warning_before may be cons...
        # Add condiations for non-admited students
        "Academic Probation"
      elsif (report[:sgpa] >= 1 && report[:sgpa] < 1.5) && report[:cgpa] >= 1.75
        "Academic Probation"
      elsif report[:sgpa] < 1 && report[:cgpa] >= 1.75
        "Academic Dismissal"
      else
        if true && (report[:sgpa] < 1.5 || is_subsequent_semester_dismissal?(student: student, sgpa: 1.5, cgpa: 1.75)) && report[:cgpa] < 1.75
          "Academic Dismissal"
        else
          # do re admission related
        end
      end
    end

    def is_warning_twice?(student:)
      GradeReport.where(student: student, academic_status: "Academic Warning").count >= 2
    end

    def above_three_year(report:, student:)
      if ((report[:sgpa] >= 1.5 && report[:sgpa] < 1.75) || is_warning_twice?(student: student)) # warning twice
        "Academic Probation"
      elsif (report[:sgpa] < 1.5 && report[:cgpa] < 1.75) || is_probation_twice?(student: student)
        "Academic Suspension"
      elsif (report[:sgpa] < 1.25) || is_probation_twice?(student: student)
        "Academic Suspension"
      else
        if true && report[:sgpa] < 1.25 && report[:cgpa] < 2
          "Academic Dismissal"
        else
          # DO ADMISSION RELATED Issues
        end
      end
    end
  end
end

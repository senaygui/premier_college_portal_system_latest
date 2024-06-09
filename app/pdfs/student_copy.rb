class StudentCopy < Prawn::Document
  def initialize(students, gc_date)
    super(:page_layout => :landscape, background: open("app/assets/images/premier.jpg"))
    @students = students
    gc_date = Date.parse(gc_date)
    @students.each_with_index do |stud, index|
      text "PREMIER COLLEGE", :inline_format => true, size: 12, align: :center, font_style: :bold
      move_down 10
      text "OFFICE OF THE REGISTRAR", inline_format: true, size: 12, align: :center, font_style: :bold
      move_down 10
      text "<u>STUDENT ACADEMIC RECORD</u>", inline_format: true, size: 12, font_style: :bold, align: :center
      move_down 10
      table [
              [" ", " ", "Admission Classification: #{stud.admission_type.capitalize}"],
              ["P.O.Box 12382, Addis Ababa, Ethiopia", " ", "Department: #{stud.department.department_name.capitalize}"],
              ["Full Name: #{stud.name.full.capitalize} #{stud.middle_name}", "Faculty: #{stud.department.faculty.faculty_name.capitalize}", "Medium of Instruction: English"],
              ["ID Number: #{stud.student_id}", "Sex: #{stud.gender}", "Graduation Status: #{stud.graduation_status.capitalize}"],
              ["Date of Admission: #{stud.admission_date}", "Traning Level: #{stud.study_level == "undergraduate" ? "Bachelor Degree" : "Masters Degree"}", "Date of Graduation: #{gc_date.strftime("%B,%d %Y")}"],
            ], width: 700, :cell_style => { :border_width => 0, padding: 2, font_style: :bold, size: 11 }
      move_down 10
      stroke_horizontal_rule
      move_down 10
      student_copy = stud.course_registrations.order(:semester).group_by { |c| [c.semester, c.academic_year] }
      student_copy.each do |key, value|
        text "<u> Academic Year:#{key[1]}/#{key[1] + 1} Semester #{key[0]}</u>", size: 14, font_style: :bold, inline_format: true
        move_down 10
        table each_stud_in_table(value, key[0]), :cell_style => { size: 9, font_style: :bold, align: :center } do
          row(0).font_style = :bold
          column(1).align = :left
          cells[3, 0].align = :right
          cells[3, 1].align = :left
          cells[4, 0].align = :right
          cells[4, 1].align = :left
          row(0).size = 10
        end
        move_down 10
      end
      move_down 10
      text "THIS TRANSCRIPT IS OFFICIAL ONLY WHEN SIGNED AND SEALED BY THE REGISTRAR.", align: :center
      table [["DATE OF ISSUE: #{Date.current.strftime("%B,%d %Y")}", " " "REGISTRAR: ____________________"]], width: 700, position: :right, cell_style: { border_width: 0, font_style: :bold }
      header_footer

      start_new_page
    end
  end

  def each_stud_in_table(value, semester)
    student_grade = GradeReport.where(semester: semester, year: value.first.year).last
    [
      ["Course Code", "Course title", "Cr.Hrs", "Letter Grade", "Grade Point", "Remark"],
    ] + value.map.with_index do |cr, index|
      [cr.course.course_code, cr.course.course_title, cr.course.credit_hour, cr.course.student_grades.last.letter_grade, cr.course.student_grades.last.grade_point, ""]
    end + [[" ", "", "", "", "", " "], ["SGPA", student_grade.sgpa, student_grade.total_credit_hour, "", student_grade.total_grade_point, ""], semester == 1 ? [" ", " ", "", "", "", " "] : ["CGPA", student_grade.cgpa, student_grade.total_credit_hour, "", student_grade.total_grade_point, ""]] + get_major_cumulative(value)
  end

  def get_major_cumulative(crg)
    major = Major.major_point_and_hour(crg)
    [[" ", "Major Cumulative Average(MGPA)", "#{major[0]}", " ", "#{major[1]}", " "]]
  end

  def header_footer
    # repeat :all do
    #     bounding_box [bounds.left, bounds.top], :width  => bounds.width do
    #         font "Helvetica"
    #     image open("app/assets/images/logo.png"), fit: [120, 100], position: :center
    #         stroke_horizontal_rule
    #     end

    bounding_box [bounds.left, bounds.bottom + 40], :width => bounds.width do
      # stroke_horizontal_rule

      # repeat :all do
      text "Grading system:A=Excellent,B=Good,C=Satisfactory,D=Unsatisfactory/Failing,F=Fail,I=Incomplete,DO=Dropout,** Project/Senior Paper, EX=Exempted, NG= No Grade, P=Pass, *= Course Repeated
                     ", align: :left, font_style: :bold
      text "Points: A=4,A-=3.75,B+=3.5,B=3,B-=2.75,C+=2.5,C=2,C-=1.75,D=1,F=0", font_style: :bold
      # end
    end
  end
end

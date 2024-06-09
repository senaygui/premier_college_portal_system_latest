class StudentGradeReport < Prawn::Document
  def initialize(students)
      super(:page_size => 'A4')
      @students = students
      @students.each_with_index do |stud, index|
     # text "Generated Date :- #{Time.zone.now.strftime('%v-%R')}"
       move_down 180
       text "Student's Name: <u>#{stud.student.first_name.capitalize} #{stud.student.middle_name.capitalize} #{stud.student.last_name.capitalize}</u>           Sex: <u>#{stud.student.gender.capitalize}</u>           Year: <u>#{stud.student.year}</u> ",:inline_format => true, size: 11.5, font_style: :bold
       move_down 10
       text "Semester: <u>#{stud.semester}</u>         Dept: <u> #{stud.department.department_name.capitalize} </u>", :inline_format => true, size: 11.5, font_style: :bold
       move_down 10
       text "Program: <u>Masters</u>          A/C Year: <u>#{stud.academic_calendar.calender_year}</u>        ID NO: <u>#{stud.student.student_id}</u>  ", inline_format: true, size: 11.5, font_style: :bold
       move_down 10


       #stroke_horizontal_rule
       move_down 10
       table each_data_in_table(stud, index) do 
          row(0).font_style = :bold
          row(0).size = 10

       end
       move_down 10
       table preview_table(stud) do
          column(1..3).style :align => :center
          row(0).font_style = :bold
          row(0).size = 10


       end
       move_down 30
       text "Academic Status: #{stud.academic_status}"
       move_down 10
       text "Remark: ___________________________"
       move_down 20
       text " ____________________", align: :center
       move_down 5
       text "REGISTRAR OFFICE", align: :center
      end
      move_down 20
      text " #{Time.zone.now.strftime('%v-%R')}", size: 9, font_style: :bold
      start_new_page
      header_footer


      
  end

  def header_footer
      repeat :all do
          bounding_box [bounds.left, bounds.top], :width  => bounds.width do
              font "Times-Roman"
          image open("app/assets/images/premier.jpg"), fit: [120, 100], position: :center
          move_down 10
              text "PREMIER COLLEGE", :align => :center, :size => 20, font_style: :bold 
              move_down 10
              text "OFFICE OF REGISTRAR", size: 14, align: :center 
              move_down 10 
              text "STUDENT'S GRADE REPORT (ONLINE)", size: 12, align: :center  
              stroke_horizontal_rule
          end
      
          bounding_box [bounds.left, bounds.bottom + 40], :width  => bounds.width do
              font "Times-Roman"
              stroke_horizontal_rule
              move_down(5)
              text "Office OF Registrar", :size => 15, align: :center
              text "++251911803339  PoBox.1697/1250 support@premier.edu.et", :size => 11, align: :center

          end
        end
    
      end

  def each_data_in_table(data, index)
     [
      ["Title of the course","Course Number", "Credit hours", "Grade", "Grade Point"],
     ]+ data.semester_registration.course_registrations.where(enrollment_status: 'enrolled').includes(:student_grade).includes(:course).map.with_index do |course, index|
      [course.course.course_title, course.course.course_code, course.course.credit_hour, course.student_grade.letter_grade, course.student_grade.grade_point]   
      #[course.course.course_title, course.course.course_code, course.course.credit_hour, StudentGrade.find_by(course: course.course).letter_grade, StudentGrade.find_by(course: course.course).grade_point]
     end
  end

  def preview_table(data)
      [
          ["","Cr.Hrs", "Grade Point", "Cumlative Grade Point\nAverage(CGPA)"],
          ["This Semester Total", data.total_credit_hour, data.total_grade_point, data.cgpa ],
          ["Previous Semester Total"]+ get_previous_total(data.student, data.semester),
          ["Cumulative Point"]+get_cumulative(get_previous_total(data.student, data.semester), data.total_credit_hour, data.total_grade_point, data.cgpa)
          
      ]
  end

  def get_previous_total(student, current_semester)
   record = GradeReport.select(:total_credit_hour,:total_grade_point, :cgpa).where("semester<#{current_semester}").where(student: student)
      ch = 0.0
      rgp = 0.0
      cgpa = 0.0
      record.each do |grade|
        ch+= grade.total_credit_hour
        rgp+= grade.total_grade_point
        cgpa+=grade.cgpa
      end
    [ch, rgp, cgpa]
  end

  def get_cumulative(previous, *current)
      [previous[0]+current[0], previous[1]+current[1], previous[2]+current[2]]
  end
  

end 

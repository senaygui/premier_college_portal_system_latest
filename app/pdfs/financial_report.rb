class FinancialReport < Prawn::Document
  def initialize(students)
    super(:page_size => "A4", :page_layout => :landscape)
    @students = students
    move_down 200
    stroke_horizontal_rule
    move_down 20
    table each_data_in_table(@students) do
      row(0).font_style = :bold
      row(0).size = 12
    end

    move_down 10

    header_footer
  end

  def header_footer
    repeat :all do
      bounding_box [bounds.left, bounds.top], :width => bounds.width do
        font "Helvetica"
        image open("app/assets/images/leadstar.png"), fit: [120, 100], position: :center
        text "Leadstar College Registrar Portal", :align => :center, :size => 25
        text "Student Payment Report", size: 30, align: :center
        stroke_horizontal_rule
      end

      bounding_box [bounds.left, bounds.bottom + 40], :width => bounds.width do
        font "Helvetica"
        stroke_horizontal_rule
        move_down(5)
        text "Leadstar College Registrar Portal", :size => 16, align: :center
        text "+251-9804523154", :size => 16, align: :center
      end
    end
  end

  def each_data_in_table(students)
    [
      ["No", "Student Name", "Departement", "Year", "Semester", "Total Price", "Remaining Amount", "Actaul Payment", "Mode of Payment"],
    ] + students.map.with_index do |smr, index|
      [index + 1, smr.student.name.full, smr.department.department_name, smr.year, smr.semester, smr.total_price, smr.remaining_amount, smr.actual_payment, smr.mode_of_payment]
    end
  end

  def preview_table(data)
    [
      ["", "Cr.Hrs", "Grade Point", "Cumlative Grade Point\nAverage(CGPA)"],
      ["Current Semester Total", data.total_credit_hour, data.total_grade_point, data.cgpa],
      ["Previous Total"] + get_previous_total(data.student, data.semester),
      ["Cumulative"] + get_cumulative(get_previous_total(data.student, data.semester), data.total_credit_hour, data.total_grade_point, data.cgpa),

    ]
  end

  def get_previous_total(student, current_semester)
    record = GradeReport.select(:total_credit_hour, :total_grade_point, :cgpa).where("semester<#{current_semester}").where(student: student)
    ch = 0.0
    rgp = 0.0
    cgpa = 0.0
    record.each do |grade|
      ch += grade.total_credit_hour
      rgp += grade.total_grade_point
      cgpa += grade.cgpa
    end
    [ch, rgp, cgpa]
  end

  def get_cumulative(previous, *current)
    [previous[0] + current[0], previous[1] + current[1], previous[2] + current[2]]
  end
end

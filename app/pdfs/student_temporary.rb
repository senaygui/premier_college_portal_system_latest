class StudentTemporary < Prawn::Document
  def initialize(students, degree, gc_date)
    super(:page_size => "A4", :top_margin => 80, :bottom_margin => 40)
    @students = students
    @students.each_with_index do |stud, index|
      move_down 100
      #  text "Full Name: <u>#{stud.name.full.capitalize}</u>         Sex: <u>#{stud.gender.capitalize}</u>           Year: <u>#{stud.student.year}</u> ",:inline_format => true, size: 12, font_style: :bold
      move_down 10
      text "PREMIER COLLEGE", :inline_format => true, size: 20, align: :center
      move_down 10
      text "OFFICE OF THE REGISTRAR", inline_format: true, size: 18, align: :center
      move_down 10
      text "<u>TEMPORARY CERTIFICATE OF GRADUATION</u>", inline_format: true, size: 22, font_style: :bold, align: :center
      move_down 30
      text "This is to certify that", inline_format: true, size: 18, align: :center
      move_down 10
      text "#{stud.name.full.upcase} #{stud.middle_name.upcase}", inline_format: true, size: 18, align: :center
      stroke_horizontal_rule
      move_down 20
      text "Graduated from Premier College", inline_format: true, size: 18, align: :center
      move_down 20
      text "with", inline_format: true, size: 18, align: :center
      move_down 20
      text "<u>Degree of #{degree} in #{stud.department.department_name}</u>", inline_format: true, size: 22, font_style: :bold, align: :center
      move_down 20
      text "<u>On #{Date.parse("2023-08-01").strftime("%d %B,%Y")}</u>", inline_format: true, size: 22, font_style: :bold, align: :center
      move_down 20
      text "This certificate of graduation has been given pending the printing and issuance of actual diploma.", inline_format: true, size: 18, align: :center
      move_down 60
      text "#{stud.admission_type.capitalize}", inline_format: true, size: 22, font_style: :bold, align: :center
      stroke_horizontal_rule
      start_new_page
    end
    header_footer
  end

  def header_footer
    repeat :all do
      bounding_box [bounds.left, bounds.top], :width => bounds.width do
        font "Times-Roman"
        image open("app/assets/images/premier.jpg"), fit: [120, 100], position: :center
        stroke_horizontal_rule
      end

      # bounding_box [bounds.left, bounds.bottom + 40], :width  => bounds.width do
      #     font "Helvetica"
      #     stroke_horizontal_rule
      #     move_down(5)
      #     text "Hope Enterprise University College Registrar Portal", :size => 16, align: :center
      #     text "+251-9804523154", :size => 16, align: :center

      # end
    end
  end
end

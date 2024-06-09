class GradeReportsController < ApplicationController
  before_action :set_grade_report, only: %i[ show edit update destroy ]

  # GET /grade_reports or /grade_reports.json
  def index
    @grade_reports = current_student.grade_reports.where(department_approval: "approved", registrar_approval: "approved", dean_approval: "approved")
  end

  # GET /grade_reports/1 or /grade_reports/1.json
  def show
  end

  # GET /grade_reports/new
  def new
    @grade_report = GradeReport.new
  end

  def student_grade_report
    year = params[:year]
    semester = params[:semester]
    students = GradeReport.where(student: current_student, year: year, semester: semester)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = StudentGradeReport.new(students)
        send_data pdf.render, filename: "student grade #{Time.zone.now}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end

  # GET /grade_reports/1/edit
  def edit
  end

  # POST /grade_reports or /grade_reports.json
  def create
    @grade_report = GradeReport.new(grade_report_params)

    respond_to do |format|
      if @grade_report.save
        format.html { redirect_to @grade_report, notice: "Grade report was successfully created." }
        format.json { render :show, status: :created, location: @grade_report }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @grade_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grade_reports/1 or /grade_reports/1.json
  def update
    respond_to do |format|
      if @grade_report.update(grade_report_params)
        format.html { redirect_to @grade_report, notice: "Grade report was successfully updated." }
        format.json { render :show, status: :ok, location: @grade_report }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @grade_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grade_reports/1 or /grade_reports/1.json
  def destroy
    @grade_report.destroy
    respond_to do |format|
      format.html { redirect_to grade_reports_url, notice: "Grade report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_grade_report
    @grade_report = GradeReport.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def grade_report_params
    params.require(:grade_report).permit(:show, :index)
  end
end

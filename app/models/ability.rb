# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= AdminUser.new

    case user.role
    when "admin"
      # can :manage, ActiveAdmin::Page, name: "Calendar", namespace_name: "admin"
      can :manage, Transfer
      can :manage, RecurringPayment
      can :manage, GradeSystem
      can :manage, GradeChange
      can :manage, MakeupExam
      can :manage, AssessmentPlan
      can :manage, CourseRegistration
      can :manage, Attendance
      can :manage, Session
      # can :manage, Graduation
      can :manage, PaymentTransaction
      can :manage, StudentAddress
      can :manage, EmergencyContact
      can :manage, Payment
      # can :manage, CourseSection
      can :manage, StudentGrade
      # can :update, StudentGrade
      # can :destroy, StudentGrade
      # cannot :create, StudentGrade
      can :manage, GradeReport
      # can :manage, GradeRule
      can :manage, Grade
      can :manage, AdminUser
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can :manage, ActiveAdmin::Page, name: "Graduation", namespace_name: "admin"
      can :manage, Program
      can :manage, College
      can :manage, Faculty
      can :manage, Curriculum
      #TODO: after one college created disable new action
      cannot :destroy, College, id: 1

      can :manage, Department
      # can :manage, Report
      can :manage, CourseModule
      can :manage, Course
      can :manage, Student
      can :manage, PaymentMethod
      can :manage, AcademicCalendar
      can :manage, CollegePayment
      can :manage, SemesterRegistration
      can :manage, Invoice
      can :manage, Section
      can :manage, Almuni
      can :manage, Withdrawal
      can :manage, AddAndDrop
      can :manage, OtherPayment
      can :manage, StudentGrade
    when "instructor"
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can :read, AcademicCalendar
      can :read, Course, id: Course.instructor_courses(user.id)
      can :update, Course, id: Course.instructor_courses(user.id)
      can :read, AssessmentPlan, course_id: Course.instructor_courses(user.id)
      can :read, CourseRegistration, section_id: Section.instructor_courses(user.id)
      can :manage, StudentGrade, course_id: Section.instructors(user.id)
      cannot :destroy, StudentGrade
      can :manage, Assessment
      can :read, Attendance, section_id: Section.instructor_courses(user.id)
      can :update, Attendance, section_id: Section.instructor_courses(user.id)

      can :create, Session
      can :read, Session, course_id: Section.instructors(user.id)
      can :update, Session, course_id: Section.instructors(user.id)
      cannot :destroy, Session, course_id: Section.instructors(user.id)

      can :read, GradeChange, course_id: Section.instructors(user.id)
      can :update, GradeChange, course_id: Section.instructors(user.id)
    when "finance"
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can :manage, ActiveAdmin::Page, name: "FinanceReport", namespace_name: "admin"

      
      can :read, Program
      #TODO: after one college created disable new action
      # cannot :destroy, College, id: 1

      can :read, Department
      can :read, CourseModule
      can :read, Course
      can :read, Student
      can :manage, PaymentMethod
      can :read, AcademicCalendar
      can :manage, CollegePayment
      can :read, SemesterRegistration
      can :manage, Invoice
    when "registrar head"
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can :manage, ActiveAdmin::Page, name: "Graduation", namespace_name: "admin"
      can :manage, ActiveAdmin::Page, name:"StudentReport", namespace_name: "admin"
      can :manage, ActiveAdmin::Page, name:"OnlineStudentGrade", namespace_name: "admin"
      can :manage, AcademicCalendar
      can :manage, AdminUser, role: "instructor"
      can :manage, Faculty
      # can :manage, Department
      can :read, CourseModule
      can :read, Program
      can :read, Curriculum
      can :read, Course
      can [:update, :read], GradeSystem
      can :read, AssessmentPlan
      can :manage, Section
      can :manage, Student
      can :manage, SemesterRegistration
      can :manage, CourseRegistration
      can :read, CollegePayment
      can :read, PaymentMethod
      can :read, Invoice
      can :manage, Attendance
      can :manage, Session

      can [:update, :read], GradeReport
      cannot :destroy, GradeReport
      can :read, StudentGrade
      can :manage, GradeChange
      can :manage, Withdrawal
      can :destroy, Withdrawal, created_by: user.name.full

      can :manage, AddAndDrop
      cannot :destroy, AddAndDrop, created_by: "self"
    when "data encoder"
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can :manage, AcademicCalendar
      can :manage, AdminUser, role: "instructor"
      can :manage, Faculty
      can :manage, Department
      can :read, CourseModule
      can :read, Program
      can :read, Curriculum
      can :read, Course
      can [:update, :read], GradeSystem
      can :read, AssessmentPlan
      can :manage, Section
      can :manage, Student
      can :manage, SemesterRegistration
      can :manage, CourseRegistration
      can :read, CollegePayment
      can :read, PaymentMethod
      can :read, Invoice
      can :manage, Attendance
      can :manage, Session

      # can [:update, :read], GradeReport
      # cannot :destroy, GradeReport
      can :read, StudentGrade
      can :manage, GradeChange
      can :manage, Withdrawal
      can :destroy, Withdrawal, created_by: user.name.full

      can :manage, AddAndDrop
      cannot :destroy, AddAndDrop, created_by: "self"
    when "distance_registrar"
      can :manage, CourseSection
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can :manage, Student, admission_type: "distance"
      can :read, Program, admission_type: "distance"
      can :read, AcademicCalendar, admission_type: "distance"
      can :manage, Department
      can :read, CourseModule
      can :read, Course
      can :manage, SemesterRegistration, admission_type: "distance"
      can :read, Invoice
    when "online_registrar"
      can :manage, CourseSection
      can :read, StudentGrade
      can :read, GradeReport
      can :read, GradeRule
      can :read, Grade
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can :manage, Student, admission_type: "online"
      can :read, Program, admission_type: "online"
      can :read, AcademicCalendar, admission_type: "online"
      can :manage, Department
      can :read, CourseModule
      can :read, Course
      can :manage, SemesterRegistration, admission_type: "online"
      can :read, Invoice
    when "regular_registrar"
      can :manage, CourseSection
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can :read, AcademicCalendar, admission_type: "regular"
      can :manage, Student, admission_type: "regular"
      can :read, Program, admission_type: "regular"
      can :manage, Department
      can :read, CourseModule
      can :read, Course
      can :manage, SemesterRegistration, admission_type: "regular"
      can :read, Invoice
    when "extention_registrar"
      can :manage, CourseSection
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can :manage, Student, admission_type: "extention"
      can :read, AcademicCalendar, admission_type: "extention"
      can :read, Program, admission_type: "extention"
      can :manage, Department
      can :read, CourseModule
      can :read, Course
      can :manage, SemesterRegistration, admission_type: "extention"
      can :read, Invoice
    when "finance head"
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can :manage, ActiveAdmin::Page, name: "FinanceReport", namespace_name: "admin"

      can [:read, :update], Withdrawal
      can :manage, Invoice
      cannot :destroy, Invoice
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can :read, Program
      #TODO: after one college created disable new action
      # cannot :destroy, College, id: 1

      can :read, Department
      can :read, CourseModule
      can :read, Course
      can :read, Student
      can :manage, PaymentMethod
      can :read, AcademicCalendar
      can :manage, CollegePayment
      can :read, SemesterRegistration
      can :manage, Invoice
    when "regular_finance"
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can :read, Program, admission_type: "regular"
      #TODO: after one college created disable new action
      # cannot :destroy, College, id: 1

      can :read, Department
      can :read, CourseModule
      can :read, Course
      can :read, Student, admission_type: "regular"
      can :manage, PaymentMethod
      can :read, AcademicCalendar, admission_type: "regular"
      can :manage, CollegePayment, admission_type: "regular"
      can :read, SemesterRegistration, admission_type: "regular"
      can :manage, Invoice
    when "distance_finance"
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can :read, Program, admission_type: "distance"
      #TODO: after one college created disable new action
      # cannot :destroy, College, id: 1

      can :read, Department
      can :read, CourseModule
      can :read, Course
      can :read, Student, admission_type: "distance"
      can :manage, PaymentMethod
      can :read, AcademicCalendar, admission_type: "distance"
      can :manage, CollegePayment, admission_type: "distance"
      can :read, SemesterRegistration, admission_type: "distance"
      can :manage, Invoice
    when "online_finance"
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can :read, Program, admission_type: "online"
      #TODO: after one college created disable new action
      # cannot :destroy, College, id: 1

      can :read, Department
      can :read, CourseModule
      can :read, Course
      can :read, Student, admission_type: "online"
      can :manage, PaymentMethod
      can :read, AcademicCalendar, admission_type: "online"
      can :manage, CollegePayment, admission_type: "online"
      can :read, SemesterRegistration, admission_type: "online"
      can :manage, Invoice
    when "extention_finance"
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can :read, Program, admission_type: "extention"
      #TODO: after one college created disable new action
      # cannot :destroy, College, id: 1

      can :read, Department
      can :read, CourseModule
      can :read, Course
      can :read, Student, admission_type: "extention"
      can :manage, PaymentMethod
      can :read, AcademicCalendar, admission_type: "extention"
      can :manage, CollegePayment, admission_type: "extention"
      can :read, SemesterRegistration, admission_type: "extention"
      can :manage, Invoice
    when "department head"
      can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can [:read, :update], Department, department_name: user.department.department_name

      can [:read, :update, :destroy], CourseModule, department_id: user.department.id
      can :create, CourseModule

      can [:read, :update, :destroy], Course, course_module: { department_id: user.department.id }
      can :create, Course

      can :manage, AdminUser, role: "instructor"
      can :create, AdminUser

      can [:read, :update, :destroy], Program, department_id: user.department.id
      can :create, Program

      can [:read, :update, :destroy], Curriculum, program: { department_id: user.department.id }
      can :create, Curriculum

      can [:read, :update, :destroy], GradeSystem, program: { department_id: user.department.id }
      can :create, GradeSystem

      can :manage, AssessmentPlan, course: { program: { department_id: user.department.id } }
      can :create, AssessmentPlan

      can [:read, :update], Transfer, department_id: user.department.id

      can :read, AcademicCalendar

      can :read, Section, program: { department_id: user.department.id }
      can :read, Student, department_id: "#{user.department_id}"
      can :read, CourseRegistration, department_id: user.department.id
      can :read, SemesterRegistration, department_id: user.department.id
      can :read, Attendance, program: { department_id: user.department.id }
      can :read, Session, course: { program: { department_id: user.department.id } }
      can [:read, :update], StudentGrade, department_id: user.department.id
      can [:read, :update], GradeChange, department_id: user.department.id
      can [:read, :update], GradeReport, department_id: user.department.id
      can [:read, :update], Withdrawal, department_id: user.department.id
      can [:read, :update], AddAndDrop, department_id: user.department.id
      can [:read, :update], MakeupExam, department_id: user.department.id
    when "dean"
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can [:read, :update], Withdrawal
      can [:read, :update], GradeReport
      can [:read, :update], GradeChange
      can :read, AcademicCalendar
      can :read, StudentGrade
      can :manage, Course
      can :manage, Program
      can :manage, Curriculum
      can :manage, GradeSystem
      can :manage, AssessmentPlan
    when "library head"
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can [:read, :update], Withdrawal
    when "store head"
      can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can [:read, :update], Withdrawal
    end
  end
end

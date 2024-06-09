# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_09_19_181514) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "academic_calendars", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "calender_year", null: false
    t.string "calender_year_in_gc", null: false
    t.string "calender_year_in_ec", null: false
    t.datetime "starting_date", precision: nil, null: false
    t.datetime "ending_date", precision: nil, null: false
    t.string "admission_type", null: false
    t.string "study_level", null: false
    t.integer "from_year"
    t.integer "to_year"
    t.string "remark"
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "academic_statuses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "grade_system_id"
    t.string "status"
    t.decimal "min_value"
    t.decimal "max_value"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["grade_system_id"], name: "index_academic_statuses_on_grade_system_id"
  end

  create_table "active_admin_comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.uuid "resource_id"
    t.string "author_type"
    t.uuid "author_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "academic_calendar_id"
    t.string "activity", null: false
    t.integer "semester", null: false
    t.string "description"
    t.string "category", null: false
    t.datetime "starting_date", precision: nil, null: false
    t.datetime "ending_date", precision: nil, null: false
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["academic_calendar_id"], name: "index_activities_on_academic_calendar_id"
  end

  create_table "add_and_drop_courses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "add_and_drop_id"
    t.uuid "course_id"
    t.string "add_or_drop", null: false
    t.string "advisor_approval", default: "pending"
    t.string "advisor_name"
    t.datetime "advisor_date_of_response", precision: nil
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["add_and_drop_id"], name: "index_add_and_drop_courses_on_add_and_drop_id"
    t.index ["course_id"], name: "index_add_and_drop_courses_on_course_id"
  end

  create_table "add_and_drops", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "student_id"
    t.uuid "academic_calendar_id"
    t.uuid "semester_registration_id"
    t.uuid "department_id"
    t.uuid "program_id"
    t.uuid "section_id"
    t.integer "semester"
    t.integer "year"
    t.string "student_full_name"
    t.string "student_id_number"
    t.string "registrar_approval", default: "pending"
    t.string "registrar_name"
    t.datetime "registrar_date_of_response", precision: nil
    t.string "advisor_approval", default: "pending"
    t.string "advisor_name"
    t.datetime "advisor_date_of_response", precision: nil
    t.string "status", default: "pending"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["academic_calendar_id"], name: "index_add_and_drops_on_academic_calendar_id"
    t.index ["department_id"], name: "index_add_and_drops_on_department_id"
    t.index ["program_id"], name: "index_add_and_drops_on_program_id"
    t.index ["section_id"], name: "index_add_and_drops_on_section_id"
    t.index ["semester_registration_id"], name: "index_add_and_drops_on_semester_registration_id"
    t.index ["student_id"], name: "index_add_and_drops_on_student_id"
  end

  create_table "admin_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "middle_name"
    t.string "role", default: "admin", null: false
    t.string "username"
    t.uuid "department_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["department_id"], name: "index_admin_users_on_department_id"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_admin_users_on_role"
  end

  create_table "almunis", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "fullname", null: false
    t.string "sex", null: false
    t.string "phone_number", null: false
    t.string "modality"
    t.string "study_level"
    t.datetime "graduation_date", precision: nil
    t.string "program_name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "assessment_plans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "course_id"
    t.string "assessment_title", null: false
    t.decimal "assessment_weight", null: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "final_exam", default: false
    t.index ["course_id"], name: "index_assessment_plans_on_course_id"
  end

  create_table "assessments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "student_id"
    t.uuid "course_id"
    t.uuid "student_grade_id"
    t.uuid "assessment_plan_id"
    t.decimal "result"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "final_exam", default: false
    t.index ["assessment_plan_id"], name: "index_assessments_on_assessment_plan_id"
    t.index ["course_id"], name: "index_assessments_on_course_id"
    t.index ["student_grade_id"], name: "index_assessments_on_student_grade_id"
    t.index ["student_id"], name: "index_assessments_on_student_id"
  end

  create_table "attendances", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "program_id"
    t.uuid "section_id"
    t.uuid "course_id"
    t.uuid "academic_calendar_id"
    t.string "course_title"
    t.string "attendance_title"
    t.integer "year"
    t.integer "semester"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["academic_calendar_id"], name: "index_attendances_on_academic_calendar_id"
    t.index ["course_id"], name: "index_attendances_on_course_id"
    t.index ["program_id"], name: "index_attendances_on_program_id"
    t.index ["section_id"], name: "index_attendances_on_section_id"
  end

  create_table "college_payments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "study_level", null: false
    t.string "admission_type", null: false
    t.string "student_nationality"
    t.decimal "total_fee", default: "0.0"
    t.decimal "registration_fee", default: "0.0"
    t.decimal "late_registration_fee", default: "0.0"
    t.decimal "starting_penalty_fee", default: "0.0"
    t.decimal "daily_penalty_fee", default: "0.0"
    t.decimal "makeup_exam_fee", default: "0.0"
    t.decimal "add_drop", default: "0.0"
    t.decimal "tution_per_credit_hr", default: "0.0"
    t.decimal "readmission", default: "0.0"
    t.decimal "reissuance_of_grade_report", default: "0.0"
    t.decimal "student_copy", default: "0.0"
    t.decimal "additional_student_copy", default: "0.0"
    t.decimal "tempo", default: "0.0"
    t.decimal "original_certificate", default: "0.0"
    t.decimal "original_certificate_replacement", default: "0.0"
    t.decimal "tempo_replacement", default: "0.0"
    t.decimal "letter", default: "0.0"
    t.decimal "student_id_card", default: "0.0"
    t.decimal "student_id_card_replacement", default: "0.0"
    t.decimal "name_change", default: "0.0"
    t.decimal "transfer_fee", default: "0.0"
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "colleges", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "college_name", null: false
    t.text "background"
    t.text "mission"
    t.text "vision"
    t.text "overview"
    t.string "headquarter"
    t.string "sub_city"
    t.string "state"
    t.string "region"
    t.string "zone"
    t.string "worda"
    t.string "city"
    t.string "country"
    t.string "phone_number"
    t.string "alternative_phone_number"
    t.string "email"
    t.string "facebook_handle"
    t.string "twitter_handle"
    t.string "instagram_handle"
    t.string "map_embed"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "course_assessments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "curriculums_id"
    t.integer "weight"
    t.string "assessment"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["curriculums_id"], name: "index_course_assessments_on_curriculums_id"
  end

  create_table "course_exemptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "course_id"
    t.string "letter_grade", null: false
    t.integer "credit_hour", null: false
    t.string "course_taken", null: false
    t.string "exemption_approval", default: "pending"
    t.string "exemption_type"
    t.string "exemptible_type"
    t.uuid "exemptible_id"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["course_id"], name: "index_course_exemptions_on_course_id"
    t.index ["exemptible_type", "exemptible_id"], name: "index_course_exemptions_on_exemptible_type_and_exemptible_id"
  end

  create_table "course_instructors", force: :cascade do |t|
    t.uuid "admin_user_id"
    t.uuid "course_id"
    t.uuid "academic_calendar_id"
    t.uuid "section_id"
    t.integer "semester"
    t.integer "year"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["academic_calendar_id"], name: "index_course_instructors_on_academic_calendar_id"
    t.index ["admin_user_id"], name: "index_course_instructors_on_admin_user_id"
    t.index ["course_id"], name: "index_course_instructors_on_course_id"
    t.index ["section_id"], name: "index_course_instructors_on_section_id"
  end

  create_table "course_modules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "module_title", null: false
    t.uuid "department_id"
    t.string "module_code", null: false
    t.text "overview"
    t.text "description"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["department_id"], name: "index_course_modules_on_department_id"
  end

  create_table "course_registrations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "student_id"
    t.uuid "program_id"
    t.uuid "semester_registration_id"
    t.uuid "department_id"
    t.uuid "course_id"
    t.uuid "academic_calendar_id"
    t.uuid "section_id"
    t.integer "semester"
    t.integer "year"
    t.string "student_full_name"
    t.string "enrollment_status", default: "pending"
    t.string "course_title"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "academic_year"
    t.index ["academic_calendar_id"], name: "index_course_registrations_on_academic_calendar_id"
    t.index ["course_id"], name: "index_course_registrations_on_course_id"
    t.index ["department_id"], name: "index_course_registrations_on_department_id"
    t.index ["program_id"], name: "index_course_registrations_on_program_id"
    t.index ["section_id"], name: "index_course_registrations_on_section_id"
    t.index ["semester_registration_id"], name: "index_course_registrations_on_semester_registration_id"
    t.index ["student_id"], name: "index_course_registrations_on_student_id"
  end

  create_table "course_sections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "section_short_name", null: false
    t.string "section_full_name", null: false
    t.uuid "course_id"
    t.string "course_title"
    t.string "program_name"
    t.integer "total_capacity"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["course_id"], name: "index_course_sections_on_course_id"
  end

  create_table "courses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "course_module_id"
    t.uuid "curriculum_id"
    t.uuid "program_id"
    t.string "course_title", null: false
    t.string "course_code", null: false
    t.text "course_description"
    t.integer "year", default: 1, null: false
    t.integer "semester", default: 1, null: false
    t.datetime "course_starting_date", precision: nil
    t.datetime "course_ending_date", precision: nil
    t.integer "credit_hour", null: false
    t.integer "lecture_hour", null: false
    t.integer "lab_hour", default: 0
    t.integer "ects", null: false
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "major", default: false
    t.index ["course_module_id"], name: "index_courses_on_course_module_id"
    t.index ["curriculum_id"], name: "index_courses_on_curriculum_id"
    t.index ["program_id"], name: "index_courses_on_program_id"
  end

  create_table "curriculums", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "program_id"
    t.string "curriculum_title", null: false
    t.string "curriculum_version", null: false
    t.integer "total_course"
    t.integer "total_ects"
    t.integer "total_credit_hour"
    t.string "active_status", default: "active"
    t.datetime "curriculum_active_date", precision: nil, null: false
    t.datetime "depreciation_date", precision: nil
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["program_id"], name: "index_curriculums_on_program_id"
  end

  create_table "departments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "faculty_id"
    t.string "department_name"
    t.text "overview"
    t.text "background"
    t.text "facility"
    t.string "location"
    t.string "phone_number"
    t.string "alternative_phone_number"
    t.string "email"
    t.string "facebook_handle"
    t.string "twitter_handle"
    t.string "telegram_handle"
    t.string "instagram_handle"
    t.string "map_embed"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["faculty_id"], name: "index_departments_on_faculty_id"
  end

  create_table "emergency_contacts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "student_id"
    t.string "full_name", null: false
    t.string "relationship"
    t.string "cell_phone", null: false
    t.string "email"
    t.string "current_occupation"
    t.string "name_of_current_employer"
    t.string "pobox"
    t.string "email_of_employer"
    t.string "office_phone_number"
    t.string "created_by", default: "self"
    t.string "last_updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["student_id"], name: "index_emergency_contacts_on_student_id"
  end

  create_table "faculties", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "faculty_name", null: false
    t.text "overview"
    t.text "background"
    t.string "location"
    t.string "phone_number"
    t.string "alternative_phone_number"
    t.string "email"
    t.string "facebook_handle"
    t.string "twitter_handle"
    t.string "telegram_handle"
    t.string "instagram_handle"
    t.string "map_embed"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "grade_changes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "academic_calendar_id"
    t.uuid "program_id"
    t.uuid "department_id"
    t.uuid "student_id"
    t.uuid "course_id"
    t.uuid "section_id"
    t.uuid "course_registration_id"
    t.uuid "student_grade_id"
    t.uuid "assessment_id"
    t.integer "semester"
    t.integer "year"
    t.decimal "add_mark"
    t.decimal "previous_result_total"
    t.string "previous_letter_grade"
    t.decimal "current_result_total"
    t.string "current_letter_grade"
    t.string "reason"
    t.string "instructor_approval", default: "pending"
    t.string "instructor_name"
    t.datetime "instructor_date_of_response", precision: nil
    t.string "registrar_approval", default: "pending"
    t.string "registrar_name"
    t.datetime "registrar_date_of_response", precision: nil
    t.string "dean_approval", default: "pending"
    t.string "dean_name"
    t.datetime "dean_date_of_response", precision: nil
    t.string "department_approval", default: "pending"
    t.string "department_head_name"
    t.datetime "department_head_date_of_response", precision: nil
    t.string "academic_affair_approval", default: "pending"
    t.string "academic_affair_name"
    t.datetime "academic_affair_date_of_response", precision: nil
    t.string "status"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["academic_calendar_id"], name: "index_grade_changes_on_academic_calendar_id"
    t.index ["assessment_id"], name: "index_grade_changes_on_assessment_id"
    t.index ["course_id"], name: "index_grade_changes_on_course_id"
    t.index ["course_registration_id"], name: "index_grade_changes_on_course_registration_id"
    t.index ["department_id"], name: "index_grade_changes_on_department_id"
    t.index ["program_id"], name: "index_grade_changes_on_program_id"
    t.index ["section_id"], name: "index_grade_changes_on_section_id"
    t.index ["student_grade_id"], name: "index_grade_changes_on_student_grade_id"
    t.index ["student_id"], name: "index_grade_changes_on_student_id"
  end

  create_table "grade_reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "semester_registration_id"
    t.uuid "student_id"
    t.uuid "academic_calendar_id"
    t.uuid "program_id"
    t.uuid "department_id"
    t.uuid "section_id"
    t.string "admission_type", null: false
    t.string "study_level", null: false
    t.integer "total_course", null: false
    t.decimal "total_credit_hour", null: false
    t.decimal "total_grade_point", null: false
    t.decimal "cumulative_total_credit_hour", null: false
    t.decimal "cumulative_total_grade_point", null: false
    t.decimal "cgpa", null: false
    t.decimal "sgpa", null: false
    t.integer "semester", null: false
    t.integer "year", null: false
    t.string "academic_status"
    t.string "registrar_approval", default: "pending"
    t.string "registrar_name"
    t.string "dean_approval", default: "approved"
    t.string "dean_name"
    t.string "department_approval", default: "pending"
    t.string "department_head_name"
    t.string "updated_by"
    t.string "created_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["academic_calendar_id"], name: "index_grade_reports_on_academic_calendar_id"
    t.index ["department_id"], name: "index_grade_reports_on_department_id"
    t.index ["program_id"], name: "index_grade_reports_on_program_id"
    t.index ["section_id"], name: "index_grade_reports_on_section_id"
    t.index ["semester_registration_id"], name: "index_grade_reports_on_semester_registration_id"
    t.index ["student_id"], name: "index_grade_reports_on_student_id"
  end

  create_table "grade_rules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "admission_type"
    t.string "study_level"
    t.integer "min_cgpa_value_to_pass"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "grade_systems", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "program_id"
    t.uuid "curriculum_id"
    t.decimal "min_cgpa_value_to_pass"
    t.decimal "min_cgpa_value_to_graduate"
    t.string "remark"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["curriculum_id"], name: "index_grade_systems_on_curriculum_id"
    t.index ["program_id"], name: "index_grade_systems_on_program_id"
  end

  create_table "grades", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "grade_system_id"
    t.string "letter_grade", null: false
    t.decimal "grade_point", null: false
    t.integer "min_row_mark", null: false
    t.integer "max_row_mark", null: false
    t.string "updated_by"
    t.string "created_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["grade_system_id"], name: "index_grades_on_grade_system_id"
  end

  create_table "invoice_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "itemable_type"
    t.uuid "itemable_id"
    t.uuid "course_registration_id"
    t.uuid "course_id"
    t.string "item_title"
    t.decimal "price", default: "0.0"
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["course_id"], name: "index_invoice_items_on_course_id"
    t.index ["course_registration_id"], name: "index_invoice_items_on_course_registration_id"
    t.index ["itemable_type", "itemable_id"], name: "index_invoice_items_on_itemable_type_and_itemable_id"
  end

  create_table "invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "semester_registration_id"
    t.uuid "student_id"
    t.uuid "academic_calendar_id"
    t.uuid "department_id"
    t.uuid "program_id"
    t.integer "semester"
    t.integer "year"
    t.string "student_full_name"
    t.string "student_id_number"
    t.string "invoice_number", null: false
    t.decimal "total_price"
    t.decimal "registration_fee", default: "0.0"
    t.decimal "late_registration_fee", default: "0.0"
    t.string "invoice_status", default: "unpaid"
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "due_date", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["academic_calendar_id"], name: "index_invoices_on_academic_calendar_id"
    t.index ["department_id"], name: "index_invoices_on_department_id"
    t.index ["program_id"], name: "index_invoices_on_program_id"
    t.index ["semester_registration_id"], name: "index_invoices_on_semester_registration_id"
    t.index ["student_id"], name: "index_invoices_on_student_id"
  end

  create_table "makeup_exams", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "academic_calendar_id"
    t.uuid "program_id"
    t.uuid "department_id"
    t.uuid "student_id"
    t.uuid "course_id"
    t.uuid "section_id"
    t.uuid "course_registration_id"
    t.uuid "student_grade_id"
    t.uuid "assessment_id"
    t.integer "semester"
    t.integer "year"
    t.decimal "add_mark"
    t.decimal "previous_result_total"
    t.string "previous_letter_grade"
    t.decimal "current_result_total"
    t.string "current_letter_grade"
    t.string "reason"
    t.string "instructor_approval", default: "pending"
    t.string "instructor_name"
    t.datetime "instructor_date_of_response", precision: nil
    t.string "registrar_approval", default: "pending"
    t.string "registrar_name"
    t.datetime "registrar_date_of_response", precision: nil
    t.string "dean_approval", default: "pending"
    t.string "dean_name"
    t.datetime "dean_date_of_response", precision: nil
    t.string "department_approval", default: "pending"
    t.string "department_head_name"
    t.datetime "department_head_date_of_response", precision: nil
    t.string "academic_affair_approval", default: "pending"
    t.string "academic_affair_name"
    t.datetime "academic_affair_date_of_response", precision: nil
    t.string "status", default: "pending"
    t.string "updated_by"
    t.string "created_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["academic_calendar_id"], name: "index_makeup_exams_on_academic_calendar_id"
    t.index ["assessment_id"], name: "index_makeup_exams_on_assessment_id"
    t.index ["course_id"], name: "index_makeup_exams_on_course_id"
    t.index ["course_registration_id"], name: "index_makeup_exams_on_course_registration_id"
    t.index ["department_id"], name: "index_makeup_exams_on_department_id"
    t.index ["program_id"], name: "index_makeup_exams_on_program_id"
    t.index ["section_id"], name: "index_makeup_exams_on_section_id"
    t.index ["student_grade_id"], name: "index_makeup_exams_on_student_grade_id"
    t.index ["student_id"], name: "index_makeup_exams_on_student_id"
  end

  create_table "other_payments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "student_id"
    t.uuid "academic_calendar_id"
    t.uuid "semester_registration_id"
    t.uuid "department_id"
    t.uuid "program_id"
    t.uuid "section_id"
    t.integer "semester"
    t.integer "year"
    t.string "student_full_name"
    t.string "student_id_number"
    t.string "invoice_number", null: false
    t.decimal "total_price"
    t.string "invoice_status", default: "unpaid"
    t.string "payment_type"
    t.string "payable_type"
    t.uuid "payable_id"
    t.datetime "due_date", precision: nil
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["academic_calendar_id"], name: "index_other_payments_on_academic_calendar_id"
    t.index ["department_id"], name: "index_other_payments_on_department_id"
    t.index ["payable_type", "payable_id"], name: "index_other_payments_on_payable_type_and_payable_id"
    t.index ["program_id"], name: "index_other_payments_on_program_id"
    t.index ["section_id"], name: "index_other_payments_on_section_id"
    t.index ["semester_registration_id"], name: "index_other_payments_on_semester_registration_id"
    t.index ["student_id"], name: "index_other_payments_on_student_id"
  end

  create_table "payment_methods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "bank_name", null: false
    t.string "account_full_name", null: false
    t.string "account_number"
    t.string "phone_number"
    t.string "account_type"
    t.string "payment_method_type", null: false
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "payment_transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "invoiceable_type"
    t.uuid "invoiceable_id"
    t.uuid "payment_method_id"
    t.string "account_holder_fullname", null: false
    t.string "phone_number"
    t.string "account_number"
    t.string "transaction_reference"
    t.string "finance_approval_status", default: "pending"
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["payment_method_id"], name: "index_payment_transactions_on_payment_method_id"
  end

  create_table "payments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "program_id"
    t.string "version"
    t.string "student_nationality"
    t.decimal "total_fee", default: "0.0"
    t.decimal "registration_fee", default: "0.0"
    t.decimal "late_registration_fee", default: "0.0"
    t.decimal "starting_penalty_fee", default: "0.0"
    t.decimal "daily_penalty_fee", default: "0.0"
    t.decimal "makeup_exam_fee", default: "0.0"
    t.decimal "add_drop", default: "0.0"
    t.decimal "tution_per_credit_hr", default: "0.0"
    t.decimal "readmission", default: "0.0"
    t.decimal "reissuance_of_grade_report", default: "0.0"
    t.decimal "student_copy", default: "0.0"
    t.decimal "additional_student_copy", default: "0.0"
    t.decimal "tempo", default: "0.0"
    t.decimal "original_certificate", default: "0.0"
    t.decimal "original_certificate_replacement", default: "0.0"
    t.decimal "tempo_replacement", default: "0.0"
    t.decimal "letter", default: "0.0"
    t.decimal "student_id_card", default: "0.0"
    t.decimal "student_id_card_replacement", default: "0.0"
    t.decimal "name_change", default: "0.0"
    t.decimal "transfer_fee", default: "0.0"
    t.decimal "other", default: "0.0"
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["program_id"], name: "index_payments_on_program_id"
  end

  create_table "prerequisites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "course_id"
    t.uuid "prerequisite_id"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["course_id"], name: "index_prerequisites_on_course_id"
    t.index ["prerequisite_id"], name: "index_prerequisites_on_prerequisite_id"
  end

  create_table "programs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "department_id"
    t.string "program_name", null: false
    t.string "program_code", null: false
    t.string "study_level", null: false
    t.string "admission_type", null: false
    t.text "overview"
    t.text "program_description"
    t.integer "total_semester", null: false
    t.integer "program_duration", null: false
    t.integer "program_semester", null: false
    t.decimal "total_tuition", default: "0.0"
    t.boolean "entrance_exam_requirement_status", default: false
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["department_id"], name: "index_programs_on_department_id"
  end

  create_table "recurring_payments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "semester_registration_id"
    t.uuid "student_id"
    t.uuid "academic_calendar_id"
    t.uuid "department_id"
    t.uuid "program_id"
    t.uuid "section_id"
    t.integer "semester"
    t.integer "year"
    t.string "student_full_name"
    t.string "student_id_number"
    t.string "invoice_number", null: false
    t.decimal "total_price"
    t.decimal "penalty", default: "0.0"
    t.decimal "daily_penalty", default: "0.0"
    t.string "invoice_status", default: "unpaid"
    t.string "mode_of_payment"
    t.datetime "due_date", precision: nil
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["academic_calendar_id"], name: "index_recurring_payments_on_academic_calendar_id"
    t.index ["department_id"], name: "index_recurring_payments_on_department_id"
    t.index ["program_id"], name: "index_recurring_payments_on_program_id"
    t.index ["section_id"], name: "index_recurring_payments_on_section_id"
    t.index ["semester_registration_id"], name: "index_recurring_payments_on_semester_registration_id"
    t.index ["student_id"], name: "index_recurring_payments_on_student_id"
  end

  create_table "school_or_university_informations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "student_id"
    t.string "college_or_university"
    t.string "phone_number"
    t.string "address"
    t.string "field_of_specialization"
    t.decimal "cgpa"
    t.string "last_attended_high_school"
    t.string "school_address"
    t.decimal "grade_10_result"
    t.datetime "grade_10_exam_taken_year", precision: nil
    t.decimal "grade_12_exam_result"
    t.datetime "grade_12_exam_taken_year", precision: nil
    t.string "level"
    t.datetime "coc_attendance_date", precision: nil
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["student_id"], name: "index_school_or_university_informations_on_student_id"
  end

  create_table "sections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "program_id"
    t.string "section_short_name", null: false
    t.string "section_full_name", null: false
    t.integer "semester", null: false
    t.integer "year", null: false
    t.integer "total_capacity"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["program_id"], name: "index_sections_on_program_id"
  end

  create_table "semester_registrations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "student_id"
    t.uuid "program_id"
    t.uuid "section_id"
    t.uuid "department_id"
    t.string "student_full_name"
    t.string "student_id_number"
    t.string "program_name"
    t.string "admission_type"
    t.string "study_level"
    t.uuid "academic_calendar_id"
    t.decimal "total_price", default: "0.0"
    t.decimal "registration_fee", default: "0.0"
    t.decimal "late_registration_fee", default: "0.0"
    t.decimal "remaining_amount", default: "0.0"
    t.decimal "penalty", default: "0.0"
    t.string "mode_of_payment"
    t.integer "semester", null: false
    t.integer "year", null: false
    t.integer "total_enrolled_course"
    t.string "registrar_approval_status", default: "pending"
    t.string "finance_approval_status", default: "pending"
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.decimal "actual_payment"
    t.boolean "is_back_invoice_created", default: false
    t.index ["academic_calendar_id"], name: "index_semester_registrations_on_academic_calendar_id"
    t.index ["department_id"], name: "index_semester_registrations_on_department_id"
    t.index ["program_id"], name: "index_semester_registrations_on_program_id"
    t.index ["section_id"], name: "index_semester_registrations_on_section_id"
    t.index ["student_id"], name: "index_semester_registrations_on_student_id"
  end

  create_table "semesters", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "academic_calendar_id"
    t.integer "semester", null: false
    t.datetime "starting_date", precision: nil, null: false
    t.datetime "ending_date", precision: nil, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["academic_calendar_id"], name: "index_semesters_on_academic_calendar_id"
  end

  create_table "sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "attendance_id"
    t.uuid "academic_calendar_id"
    t.uuid "course_id"
    t.integer "semester"
    t.integer "year"
    t.datetime "starting_date", precision: nil
    t.datetime "ending_date", precision: nil
    t.string "session_title"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["academic_calendar_id"], name: "index_sessions_on_academic_calendar_id"
    t.index ["attendance_id"], name: "index_sessions_on_attendance_id"
    t.index ["course_id"], name: "index_sessions_on_course_id"
  end

  create_table "student_addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "student_id"
    t.string "country", null: false
    t.string "city"
    t.string "region"
    t.string "zone"
    t.string "sub_city"
    t.string "woreda"
    t.string "special_location"
    t.string "house_number"
    t.string "moblie_number", null: false
    t.string "telephone_number"
    t.string "pobox"
    t.string "created_by", default: "self"
    t.string "last_updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["student_id"], name: "index_student_addresses_on_student_id"
  end

  create_table "student_attendances", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "session_id"
    t.uuid "student_id"
    t.uuid "course_registration_id"
    t.string "student_full_name"
    t.boolean "present"
    t.boolean "absent"
    t.string "remark"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["course_registration_id"], name: "index_student_attendances_on_course_registration_id"
    t.index ["session_id"], name: "index_student_attendances_on_session_id"
    t.index ["student_id"], name: "index_student_attendances_on_student_id"
  end

  create_table "student_courses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "student_id"
    t.uuid "course_id"
    t.string "course_title", null: false
    t.integer "semester", null: false
    t.integer "year", null: false
    t.integer "credit_hour", null: false
    t.integer "ects", null: false
    t.string "course_code", null: false
    t.string "letter_grade"
    t.decimal "grade_point"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["course_id"], name: "index_student_courses_on_course_id"
    t.index ["student_id"], name: "index_student_courses_on_student_id"
  end

  create_table "student_grades", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "course_registration_id"
    t.uuid "student_id"
    t.uuid "course_id"
    t.uuid "department_id"
    t.uuid "program_id"
    t.string "letter_grade"
    t.decimal "assesment_total"
    t.decimal "grade_point"
    t.string "updated_by"
    t.string "created_by"
    t.string "department_approval", default: "pending"
    t.string "approved_by"
    t.datetime "approval_date", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "approving_person_role"
    t.index ["course_id"], name: "index_student_grades_on_course_id"
    t.index ["course_registration_id"], name: "index_student_grades_on_course_registration_id"
    t.index ["department_id"], name: "index_student_grades_on_department_id"
    t.index ["program_id"], name: "index_student_grades_on_program_id"
    t.index ["student_id"], name: "index_student_grades_on_student_id"
  end

  create_table "students", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "middle_name"
    t.string "gender", null: false
    t.datetime "date_of_birth", precision: nil, null: false
    t.string "place_of_birth"
    t.string "marital_status"
    t.string "nationality", null: false
    t.string "current_occupation"
    t.string "student_id"
    t.string "old_id_number"
    t.string "student_password"
    t.boolean "student_id_taken_status", default: false
    t.uuid "program_id"
    t.uuid "department_id"
    t.uuid "academic_calendar_id"
    t.string "admission_type", null: false
    t.string "study_level", null: false
    t.integer "year", default: 1
    t.integer "semester", default: 1
    t.string "account_verification_status", default: "pending"
    t.string "document_verification_status", default: "pending"
    t.boolean "tempo_status", default: false
    t.string "curriculum_version"
    t.string "entrance_exam_result_status"
    t.string "batch"
    t.string "account_status", default: "active"
    t.string "graduation_status", default: "pending"
    t.string "sponsorship_status"
    t.string "institution_transfer_status"
    t.string "program_transfer_status"
    t.string "previous_program"
    t.string "previous_department"
    t.string "created_by", default: "self"
    t.string "last_updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "payment_version"
    t.date "admission_date"
    t.integer "graduation_year"
    t.boolean "allow_editing", default: false
    t.index ["academic_calendar_id"], name: "index_students_on_academic_calendar_id"
    t.index ["department_id"], name: "index_students_on_department_id"
    t.index ["email"], name: "index_students_on_email", unique: true
    t.index ["program_id"], name: "index_students_on_program_id"
    t.index ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true
  end

  create_table "transfers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "student_id"
    t.uuid "program_id"
    t.uuid "section_id"
    t.uuid "department_id"
    t.uuid "academic_calendar_id"
    t.string "student_full_name"
    t.string "id_number"
    t.integer "semester", null: false
    t.integer "year", null: false
    t.string "new_department"
    t.string "modality_transfer"
    t.text "reason"
    t.datetime "date_of_transfer", precision: nil
    t.string "formal_department_head"
    t.string "formal_department_head_approval", default: "pending"
    t.datetime "formal_department_head_approval_date", precision: nil
    t.string "remark"
    t.string "new_department_head"
    t.string "new_department_head_approval", default: "pending"
    t.datetime "new_department_head_approval_date", precision: nil
    t.string "dean_name"
    t.string "dean_approval", default: "pending"
    t.datetime "dean_approval_date", precision: nil
    t.string "registrar_name"
    t.string "registrar_approval", default: "pending"
    t.datetime "registrar_approval_date", precision: nil
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "new_program"
    t.index ["academic_calendar_id"], name: "index_transfers_on_academic_calendar_id"
    t.index ["department_id"], name: "index_transfers_on_department_id"
    t.index ["program_id"], name: "index_transfers_on_program_id"
    t.index ["section_id"], name: "index_transfers_on_section_id"
    t.index ["student_id"], name: "index_transfers_on_student_id"
  end

  create_table "withdrawals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "program_id"
    t.uuid "department_id"
    t.uuid "student_id"
    t.uuid "section_id"
    t.uuid "academic_calendar_id"
    t.string "student_id_number"
    t.integer "semester", null: false
    t.integer "year", null: false
    t.string "fee_status", null: false
    t.string "reason_for_withdrawal", null: false
    t.string "other_reason"
    t.datetime "last_class_attended", precision: nil, null: false
    t.string "finance_head_approval", default: "pending"
    t.string "finance_head_name"
    t.datetime "finance_head_date_of_response", precision: nil
    t.string "registrar_approval", default: "pending"
    t.string "registrar_name"
    t.datetime "registrar_date_of_response", precision: nil
    t.string "dean_approval", default: "pending"
    t.string "dean_name"
    t.datetime "dean_date_of_response", precision: nil
    t.string "department_approval", default: "pending"
    t.string "department_head_name"
    t.datetime "department_head_date_of_response", precision: nil
    t.string "library_head_approval", default: "pending"
    t.string "library_head_name"
    t.datetime "library_head_date_of_response", precision: nil
    t.string "store_head_approval", default: "pending"
    t.string "store_head_name"
    t.datetime "store_head_date_of_response", precision: nil
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["academic_calendar_id"], name: "index_withdrawals_on_academic_calendar_id"
    t.index ["department_id"], name: "index_withdrawals_on_department_id"
    t.index ["program_id"], name: "index_withdrawals_on_program_id"
    t.index ["section_id"], name: "index_withdrawals_on_section_id"
    t.index ["student_id"], name: "index_withdrawals_on_student_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "departments", "faculties"
end

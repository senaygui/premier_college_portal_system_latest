class RoleFilter
    def self.allowed_for_common(current_admin_user)
        (current_admin_user.role == 'admin' || current_admin_user.role == 'president' || current_admin_user.role=='vice president' || current_admin_user.role=='dean' || current_admin_user.role= 'registrar head')
    end

    def self.department_head_filter(current_admin_user)
        Program.all.joins(:department).group("departments.department_name").where("departments.id = #{current_admin_user.department_id}").count 
    end

    def self.department_curriculum_filter(current_admin_user)
        Program.all.joins(:curriculums).group('programs.program_name').where("departments.id = #{current_admin_user.department_id}").count 
    end
end
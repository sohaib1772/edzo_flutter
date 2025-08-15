enum Role {
  student,
  teacher,
  admin,
  full,
}

class RoleHelper {
  static Role role = Role.student;
  static void setRole(String role){
    switch (role) {
      case "student":
        RoleHelper.role = Role.student;
        break;
      case "teacher":
        RoleHelper.role = Role.teacher;
        break;
      case "admin":
        RoleHelper.role = Role.admin;
        break;
      case "full":
        RoleHelper.role = Role.full;
        break;
      default:
        RoleHelper.role = Role.student;
        break;
    }
  }


  //get role in arabic
  static String getRole(String role){
    switch (role) {
      case "student":
        return "طالب";
      case "teacher":
        return "معلم";
      case  "admin":
        return "مدير";
      case "full":
        return "طالب";
      default:
        return "طالب";
    }
  }
}
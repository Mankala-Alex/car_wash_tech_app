class Loginmodel {
  Loginmodel({
    required this.success,
    required this.employee,
    required this.token,
  });

  final bool success;
  final Employee? employee;
  final String token;

  factory Loginmodel.fromJson(Map<String, dynamic> json) {
    return Loginmodel(
      success: json["success"] ?? false,
      employee:
          json["employee"] == null ? null : Employee.fromJson(json["employee"]),
      token: json["token"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "employee": employee?.toJson(),
        "token": token,
      };
}

class Employee {
  Employee({
    required this.id,
    required this.empCode,
    required this.firstName,
    required this.lastName,
    required this.designation,
  });

  final String id;
  final String empCode;
  final String firstName;
  final String lastName;
  final String designation;

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json["id"] ?? "",
      empCode: json["emp_code"] ?? "",
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      designation: json["designation"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "emp_code": empCode,
        "first_name": firstName,
        "last_name": lastName,
        "designation": designation,
      };
}

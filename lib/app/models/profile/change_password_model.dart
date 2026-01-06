class ChangePasswordModel {
  final bool success;
  final String message;
  final EmployeeModel? employee;

  ChangePasswordModel({
    required this.success,
    required this.message,
    this.employee,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      employee: json['employee'] != null
          ? EmployeeModel.fromJson(json['employee'])
          : null,
    );
  }
}

class EmployeeModel {
  final String id;
  final String empCode;
  final String firstName;
  final String lastName;

  EmployeeModel({
    required this.id,
    required this.empCode,
    required this.firstName,
    required this.lastName,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? '',
      empCode: json['emp_code'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }
}

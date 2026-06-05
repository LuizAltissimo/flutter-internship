class AdvisorProfessor {
  final int? professorId;
  final String name;
  final String email;
  final String department;
  final String phone;

  AdvisorProfessor({
    this.professorId,
    required this.name,
    required this.email,
    required this.department,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'professor_id': professorId,
      'name': name,
      'email': email,
      'department': department,
      'phone': phone,
    };
  }

  factory AdvisorProfessor.fromMap(Map<String, dynamic> map) {
    return AdvisorProfessor(
      professorId: map['professor_id'],
      name: map['name'],
      email: map['email'],
      department: map['department'],
      phone: map['phone'],
    );
  }

  AdvisorProfessor copyWith({
    int? professorId,
    String? name,
    String? email,
    String? department,
    String? phone,
  }) {
    return AdvisorProfessor(
      professorId: professorId ?? this.professorId,
      name: name ?? this.name,
      email: email ?? this.email,
      department: department ?? this.department,
      phone: phone ?? this.phone,
    );
  }
}

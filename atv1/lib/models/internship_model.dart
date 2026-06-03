class internship {
  final int? internship_id;
  final String student_name;
  final String company_name;
  final String location;
  final String duration;

  internship({
    this.internship_id,
    required this.student_name,
    required this.company_name,
    required this.location,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
      return {
        'internship_id': internship_id,
        'student_name': student_name,
        'company_name': company_name,
        'location': location,
        'duration': duration,
      };
    }

  factory internship.fromMap(Map<String, dynamic> map) {
    return internship(
      internship_id: map['internship_id'],
      student_name: map['student_name'],
      company_name: map['company_name'],
      location: map['location'],
      duration: map['duration'],
    );
  }
  
  internship copyWith({
    int? internship_id,
    String? student_name,
    String? company_name,
    String? location,
    String? duration,
  }) {
    return internship(
      internship_id: internship_id ?? this.internship_id,
      student_name: student_name ?? this.student_name,
      company_name: company_name ?? this.company_name,
      location: location ?? this.location,
      duration: duration ?? this.duration,
    );
  }
}
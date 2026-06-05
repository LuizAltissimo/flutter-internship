class Internship {
  final int? internshipId;
  final String studentName;
  final String companyName;
  final String location;
  final String duration;

  Internship({
    this.internshipId,
    required this.studentName,
    required this.companyName,
    required this.location,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'internship_id': internshipId,
      'student_name': studentName,
      'company_name': companyName,
      'location': location,
      'duration': duration,
    };
  }

  factory Internship.fromMap(Map<String, dynamic> map) {
    return Internship(
      internshipId: map['internship_id'],
      studentName: map['student_name'],
      companyName: map['company_name'],
      location: map['location'],
      duration: map['duration'],
    );
  }

  Internship copyWith({
    int? internshipId,
    String? studentName,
    String? companyName,
    String? location,
    String? duration,
  }) {
    return Internship(
      internshipId: internshipId ?? this.internshipId,
      studentName: studentName ?? this.studentName,
      companyName: companyName ?? this.companyName,
      location: location ?? this.location,
      duration: duration ?? this.duration,
    );
  }
}

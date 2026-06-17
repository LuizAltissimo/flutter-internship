class Internship {
  final int? internshipId;
  final String studentName;
  final int? companyId;
  final String companyName;
  final String location;
  final String duration;
  // IA: campo adicionado para vincular o orientador ao estagio
  final int? advisorProfessorId;
  // IA: campo adicionado para armazenar o nome do orientador para exibicao na lista
  final String? advisorProfessorName;

  Internship({
    this.internshipId,
    required this.studentName,
    this.companyId,
    required this.companyName,
    required this.location,
    required this.duration,
    this.advisorProfessorId,
    this.advisorProfessorName,
  });

  Map<String, dynamic> toMap() {
    return {
      'internship_id': internshipId,
      'student_name': studentName,
      'company_id': companyId,
      'company_name': companyName,
      'location': location,
      'duration': duration,
      // IA: campos de relacionamento adicionados ao map para persistencia no SQLite
      'advisor_professor_id': advisorProfessorId,
      'advisor_professor_name': advisorProfessorName,
    };
  }

  factory Internship.fromMap(Map<String, dynamic> map) {
    return Internship(
      internshipId: map['internship_id'],
      studentName: map['student_name'],
      companyId: map['company_id'],
      companyName: map['company_name'],
      location: map['location'],
      duration: map['duration'],
      // IA: leitura do campo de relacionamento do recorde do banco
      advisorProfessorId: map['advisor_professor_id'],
      advisorProfessorName: map['advisor_professor_name'],
    );
  }

  Internship copyWith({
    int? internshipId,
    String? studentName,
    int? companyId,
    String? companyName,
    String? location,
    String? duration,
    int? advisorProfessorId,
    String? advisorProfessorName,
  }) {
    return Internship(
      internshipId: internshipId ?? this.internshipId,
      studentName: studentName ?? this.studentName,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      location: location ?? this.location,
      duration: duration ?? this.duration,
      advisorProfessorId: advisorProfessorId ?? this.advisorProfessorId,
      advisorProfessorName:
          advisorProfessorName ?? this.advisorProfessorName,
    );
  }
}

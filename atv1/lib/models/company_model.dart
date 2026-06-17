class Company {
  final int? companyId;
  final String name;
  final String cnpj;
  final String location;
  final String contactName;
  final String contactEmail;
  final String contactPhone;

  Company({
    this.companyId,
    required this.name,
    required this.cnpj,
    required this.location,
    required this.contactName,
    required this.contactEmail,
    required this.contactPhone,
  });

  Map<String, dynamic> toMap() {
    return {
      'company_id': companyId,
      'name': name,
      'cnpj': cnpj,
      'location': location,
      'contact_name': contactName,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      companyId: map['company_id'],
      name: map['name'],
      cnpj: map['cnpj'],
      location: map['location'],
      contactName: map['contact_name'],
      contactEmail: map['contact_email'],
      contactPhone: map['contact_phone'],
    );
  }

  Company copyWith({
    int? companyId,
    String? name,
    String? cnpj,
    String? location,
    String? contactName,
    String? contactEmail,
    String? contactPhone,
  }) {
    return Company(
      companyId: companyId ?? this.companyId,
      name: name ?? this.name,
      cnpj: cnpj ?? this.cnpj,
      location: location ?? this.location,
      contactName: contactName ?? this.contactName,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
    );
  }
}

import 'dart:convert';

class ProfessionalExperience {
  final String company;
  final String context;
  final String position;
  final double? lastSalary;
  final String responsability;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isAtual;

  ProfessionalExperience({
    required this.company,
    required this.context,
    required this.position,
    this.lastSalary,
    required this.responsability,
    required this.startDate,
    this.endDate,
    required this.isAtual,
  });

  ProfessionalExperience copyWith({
    String? company,
    String? context,
    String? position,
    double? lastSalary,
    String? responsability,
    DateTime? startDate,
    DateTime? endDate,
    bool? isAtual,
  }) {
    return ProfessionalExperience(
      company: company ?? this.company,
      context: context ?? this.context,
      position: position ?? this.position,
      lastSalary: lastSalary ?? this.lastSalary,
      responsability: responsability ?? this.responsability,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isAtual: isAtual ?? this.isAtual,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'company': company,
      'context': context,
      'position': position,
      'lastSalary': lastSalary,
      'responsability': responsability,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'isAtual': isAtual,
    };
  }

  factory ProfessionalExperience.fromMap(Map<String, dynamic> map) {
    bool isAtual = false;

    if (map['isAtual'] != null) {
      isAtual = map['isAtual'];
    } else {
      isAtual = map['endDate'] == null;
    }

    return ProfessionalExperience(
      company: map['company'] as String,
      context: map['context'] as String,
      position: map['position'] as String,
      lastSalary:
          map['lastSalary'] != null ? map['lastSalary'] as double : null,
      responsability: map['responsability'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int)
          : null,
      isAtual: isAtual,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfessionalExperience.fromJson(String source) =>
      ProfessionalExperience.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProfessionalExperience(company: $company, context: $context, position: $position, lastSalary: $lastSalary, responsability: $responsability, startDate: $startDate, endDate: $endDate, isAtual: $isAtual)';
  }

  @override
  bool operator ==(covariant ProfessionalExperience other) {
    if (identical(this, other)) return true;

    return other.company == company &&
        other.context == context &&
        other.position == position &&
        other.lastSalary == lastSalary &&
        other.responsability == responsability &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.isAtual == isAtual;
  }

  @override
  int get hashCode {
    return company.hashCode ^
        context.hashCode ^
        position.hashCode ^
        lastSalary.hashCode ^
        responsability.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        isAtual.hashCode;
  }
}

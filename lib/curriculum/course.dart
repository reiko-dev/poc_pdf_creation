import 'dart:convert';

class Course {
  final String name;
  final String organization;
  final DateTime endDate;
  Course({
    required this.name,
    required this.organization,
    required this.endDate,
  });

  Course copyWith({
    String? name,
    String? organization,
    DateTime? endDate,
  }) {
    return Course(
      name: name ?? this.name,
      organization: organization ?? this.organization,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'organization': organization,
      'endDate': endDate.millisecondsSinceEpoch,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      name: map['name'] as String,
      organization: map['organization'] as String,
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) =>
      Course.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Course(name: $name, organization: $organization, endDate: $endDate)';

  @override
  bool operator ==(covariant Course other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.organization == organization &&
        other.endDate == endDate;
  }

  @override
  int get hashCode => name.hashCode ^ organization.hashCode ^ endDate.hashCode;
}

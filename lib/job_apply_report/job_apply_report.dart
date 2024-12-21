import 'dart:convert';

abstract class Labeled {
  const Labeled();
  String get label;
}

enum SuitableStatus implements Labeled {
  suitable('Apto', 'suitable'),
  notSuitable('Não apto', 'not-suitable'),
  pending('Pendente', 'pending'),
  ;

  @override
  final String label;

  final String endpointTxt;

  const SuitableStatus(this.label, this.endpointTxt);

  static SuitableStatus fromEndpointTxt(String? text) {
    return values.firstWhere(
      (element) => element.endpointTxt == text,
      orElse: () => pending,
    );
  }
}

class JobApplyReport {
  final double? lastSalary;

  final String description;
  final DateTime interviewDate;

  /// Whether the person is the right one for the job.
  final SuitableStatus status;

  static const collection = 'report';

  JobApplyReport({
    this.lastSalary,
    required this.description,
    required this.status,
    required this.interviewDate,
  });

  JobApplyReport copyWith({
    double? lastSalary,
    String? description,
    SuitableStatus? status,
    DateTime? interviewDate,
  }) {
    return JobApplyReport(
      lastSalary: lastSalary ?? this.lastSalary,
      description: description ?? this.description,
      status: status ?? this.status,
      interviewDate: interviewDate ?? this.interviewDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'salaryExpectations': lastSalary,
      'description': description,
      'suitable': status.endpointTxt,
      'interviewDate': interviewDate.millisecondsSinceEpoch,
    };
  }

  factory JobApplyReport.fromMap(Map<String, dynamic> map) {
    return JobApplyReport(
      lastSalary: map['salaryExpectations'] != null
          ? map['salaryExpectations'] as double
          : null,
      description: map['description'] as String,
      status: SuitableStatus.fromEndpointTxt(map['suitable']),
      // suitable:  map['suitable'] as bool,
      interviewDate: DateTime.fromMillisecondsSinceEpoch(
        map['interviewDate'] as int,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory JobApplyReport.fromJson(String source) =>
      JobApplyReport.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'JobApplyReport(salaryExpectations: $lastSalary, description: $description, suitable: $status, interviewDate: $interviewDate)';

  @override
  bool operator ==(covariant JobApplyReport other) {
    if (identical(this, other)) return true;

    return other.lastSalary == lastSalary &&
        other.description == description &&
        other.status == status &&
        other.interviewDate == interviewDate;
  }

  @override
  int get hashCode =>
      lastSalary.hashCode ^
      description.hashCode ^
      status.hashCode ^
      interviewDate.hashCode;
}

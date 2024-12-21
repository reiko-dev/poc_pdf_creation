import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:poc_pdf_creation/job_apply/company.dart';
import 'package:poc_pdf_creation/job_apply/extensions.dart';
import 'package:poc_pdf_creation/job_apply/job_name.dart';
import 'package:poc_pdf_creation/job_apply/user.dart';

enum JobEndDateStatus {
  normal('Dentro do prazo'),
  expiringSoon('Expirando em menos de 2 dias'),
  expired('Vaga expirada'),
  ;

  const JobEndDateStatus(this.label);

  final String label;

  Color get color => switch (this) {
        JobEndDateStatus.normal => Colors.green,
        JobEndDateStatus.expiringSoon => Colors.orange,
        JobEndDateStatus.expired => Colors.red,
      };
}

class Job {
  static const collection = 'jobs';

  final String uid;

  ///A short description
  final String jobName;
  final JobName job;
  final Company company;

  ///Number of jobs
  final int qtd;
  final bool showSalary;
  final double salary;
  final Analyst? analyst;
  final bool isActive;
  final String description;
  final DateTime createdAt;

  ///Data de abertura da vaga
  final DateTime startDate;

  ///Data de encerramento da vaga
  final DateTime endDate;
  final List<String> jobApplies;
  final String? observation;
  final String? city;

  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  Job({
    required this.uid,
    required this.jobName,
    required this.job,
    required this.company,
    required this.qtd,
    required this.showSalary,
    required this.salary,
    this.analyst,
    required this.isActive,
    required this.description,
    required this.createdAt,
    required this.jobApplies,
    this.observation,
    required this.city,
    required this.endDate,
    required this.startDate,
    this.startTime,
    this.endTime,
  }) {
    calculateEndDateStatus();
  }

  late final JobEndDateStatus endDateStatus;

  void calculateEndDateStatus() {
    final now = DateTime.now();

    final diff = endDate.difference(now).inDays;

    if (diff > 2) {
      endDateStatus = JobEndDateStatus.normal;
      return;
    }

    if (endDate.isAfter(now)) {
      endDateStatus = JobEndDateStatus.expiringSoon;
      return;
    }
    endDateStatus = JobEndDateStatus.expired;
  }

  bool get isEmpty => jobApplies.isEmpty;

  int get totalCandidates => jobApplies.length;

  Job copyWith({
    String? uid,
    String? jobName,
    JobName? job,
    Company? company,
    int? qtd,
    bool? showSalary,
    double? salary,
    Analyst? analyst,
    bool? isActive,
    String? description,
    DateTime? createdAt,
    DateTime? endDate,
    DateTime? startDate,
    List<String>? jobApplies,
    String? observation,
    String? city,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return Job(
      uid: uid ?? this.uid,
      jobName: jobName ?? this.jobName,
      job: job ?? this.job,
      company: company ?? this.company,
      qtd: qtd ?? this.qtd,
      showSalary: showSalary ?? this.showSalary,
      salary: salary ?? this.salary,
      analyst: analyst ?? this.analyst,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      endDate: endDate ?? this.endDate,
      startDate: startDate ?? this.startDate,
      jobApplies: jobApplies ?? this.jobApplies,
      observation: observation ?? this.observation,
      city: city ?? this.city,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'job': job.toMap(),
      'name': jobName,
      'company': company.toMap(),
      'qtd': qtd,
      'showSalary': showSalary,
      'salary': salary,
      'analyst': analyst,
      'isActive': isActive,
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'jobApplies': jobApplies,
      'observation': observation,
      'isEmpty': isEmpty,
      'city': city,
      'startTime': startTime?.toMap(),
      'endTime': endTime?.toMap(),
    }..removeWhere((key, value) => value == null);
  }

  factory Job.fromMap(Map<String, dynamic> map) {
    try {
      return Job(
        uid: map['uid'] as String,
        job: JobName.fromMap(map['job']),
        jobName: map['name'] as String,
        analyst: map['analyst'] == null
            ? null
            : Analyst.fromMap(map['analyst'] as Map<String, dynamic>),
        company: Company.fromMap(map['company']),
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        startDate: map['startDate'] == null
            ? DateTime.now()
            : DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
        endDate: map['endDate'] == null
            ? DateTime.now()
            : DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
        description: map['description'] as String,
        isActive: map['isActive'] as bool,
        jobApplies: List<String>.from(
          (map['jobApplies'] as List<dynamic>? ?? []),
        ),
        observation: map['observation'] as String?,
        qtd: map['qtd'] as int,
        salary: map['salary'] as double,
        showSalary: map['showSalary'] as bool,
        city: map['city'] as String?,
        startTime: map['startTime'] == null
            ? const TimeOfDay(hour: 8, minute: 0)
            : timeOfDayFromMap(map['startTime']),
        endTime: map['endTime'] == null
            ? const TimeOfDay(hour: 17, minute: 0)
            : timeOfDayFromMap(map['endTime']),
      );
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  @override
  String toString() {
    return 'Job(uid: $uid, createdAt: $createdAt, job: $jobName, position: $job, qtd: $qtd, showSalary: $showSalary, salary: $salary, analyst: $analyst, isActive: $isActive, description: $description, startDate: $startDate, endDate: $endDate, jobApplies: $jobApplies, company: $company, observation: $observation)';
  }

  @override
  bool operator ==(covariant Job other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.jobName == jobName &&
        other.job == job &&
        other.company == company &&
        other.qtd == qtd &&
        other.showSalary == showSalary &&
        other.salary == salary &&
        other.analyst == analyst &&
        other.isActive == isActive &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.observation == observation &&
        other.city == city &&
        listEquals(other.jobApplies, jobApplies);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        jobName.hashCode ^
        job.hashCode ^
        company.hashCode ^
        qtd.hashCode ^
        showSalary.hashCode ^
        salary.hashCode ^
        analyst.hashCode ^
        isActive.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        observation.hashCode ^
        city.hashCode ^
        jobApplies.hashCode;
  }
}

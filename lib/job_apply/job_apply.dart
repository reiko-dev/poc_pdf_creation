import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poc_pdf_creation/job_apply/job_apply_report.dart';
import 'package:poc_pdf_creation/job_apply/job_apply_status/index.dart';

class JobApply {
  static String collection = 'jobapplies';

  final String uid;
  final DateTime createdAt;
  final String userId;
  final String jobId;
  final String? curriculumId;
  final String? resume;
  final String? pdf;
  final List<JobApplyStatus> statusList;
  final JobApplyReport? report;
  final String? analystId;

  JobApply({
    required this.uid,
    required this.createdAt,
    required this.userId,
    required this.jobId,
    required this.curriculumId,
    required this.analystId,
    this.resume,
    this.pdf,
    required this.statusList,
    required this.report,
  });

  JobApplyStatus get currentStatus {
    statusList.sort(
      (a, b) => b.eventDate.compareTo(a.eventDate),
    );
    return statusList.first;
  }

  bool get isReviewed {
    return currentStatus.type != JobApplyStatusType.initiated;
  }

  JobApply copyWith({
    String? uid,
    DateTime? createdAt,
    String? userId,
    String? jobId,
    String? curriculumId,
    String? resume,
    String? pdf,
    List<JobApplyStatus>? statusList,
    JobApplyReport? report,
    String? analystId,
  }) {
    return JobApply(
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      jobId: jobId ?? this.jobId,
      curriculumId: curriculumId ?? this.curriculumId,
      resume: resume ?? this.resume,
      pdf: pdf ?? this.pdf,
      statusList: statusList ?? this.statusList,
      report: report ?? this.report,
      analystId: analystId ?? this.analystId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'userId': userId,
      'jobId': jobId,
      'curriculumId': curriculumId,
      'resume': resume,
      'pdf': pdf,
      'statuses': statusList.map((e) => e.toMap()).toList(),
      'report': report?.toMap(),
      'analyst': analystId,
    };
  }

  factory JobApply.fromMap(Map<String, dynamic> map) {
    try {
      return JobApply(
        uid: map['uid'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        userId: map['userId'] as String,
        jobId: map['jobId'] as String,
        curriculumId: map['curriculumId'] as String,
        resume: map['resume'] != null ? map['resume'] as String : null,
        pdf: map['pdf'] != null ? map['pdf'] as String : null,
        statusList: (map['statuses'] as List<dynamic>)
            .map(
              (e) => JobApplyStatus.fromMap(e as Map<String, dynamic>),
            )
            .toList(),
        report: map['report'] != null
            ? JobApplyReport.fromMap(map['report'] as Map<String, dynamic>)
            : null,
        analystId: map['analyst'] as String?,
      );
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  String toJson() => json.encode(toMap());

  factory JobApply.fromJson(String source) =>
      JobApply.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'JobApply(uid: $uid, createdAt: $createdAt, userId: $userId, jobId: $jobId, curriculumId: $curriculumId, resume: $resume, pdf: $pdf, statusList: $statusList, report: $report, analyst: $analystId)';
  }

  @override
  bool operator ==(covariant JobApply other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.createdAt == createdAt &&
        other.userId == userId &&
        other.jobId == jobId &&
        other.curriculumId == curriculumId &&
        other.resume == resume &&
        other.pdf == pdf &&
        other.statusList == statusList &&
        other.report == report &&
        other.analystId == analystId;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        createdAt.hashCode ^
        userId.hashCode ^
        jobId.hashCode ^
        curriculumId.hashCode ^
        resume.hashCode ^
        pdf.hashCode ^
        statusList.hashCode ^
        report.hashCode ^
        analystId.hashCode;
  }
}

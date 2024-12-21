import 'dart:convert';

import 'package:poc_pdf_creation/job_apply/mixins.dart';

class JobName extends LabeledIndex {
  static const collection = 'jobsNames';
  final String uid;
  final String title;
  final bool isActive;

  const JobName({
    required this.uid,
    required this.title,
    required this.isActive,
  });

  @override
  String get label => title;

  @override
  String get index => uid;

  JobName copyWith({
    String? uid,
    String? title,
    bool? isActive,
  }) {
    return JobName(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'title': title,
      'isActive': isActive,
    };
  }

  factory JobName.fromMap(Map<String, dynamic> map) {
    return JobName(
      uid: map['uid'] as String,
      title: map['title'] as String,
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory JobName.fromJson(String source) =>
      JobName.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'JobName(uid: $uid, title: $title, isActive: $isActive)';
  }

  @override
  bool operator ==(covariant JobName other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.title == title &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ title.hashCode ^ isActive.hashCode;
  }
}

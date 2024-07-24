// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

enum AcademicSituation {
  interrupted,
  finished,
  finishing;

  String get label => switch (this) {
        AcademicSituation.finishing => 'Cursando',
        AcademicSituation.finished => 'Concluído',
        AcademicSituation.interrupted => 'Interrrompido',
      };

  Map<String, String> toMap() {
    return {
      'situation': switch (this) {
        AcademicSituation.finishing => 'finishing',
        AcademicSituation.finished => 'finished',
        AcademicSituation.interrupted => 'interrupted',
      },
    };
  }

  static AcademicSituation fromMap(Map<String, dynamic> map) {
    final val = map['academic_situation'];

    if (val == 'finishing') return AcademicSituation.finishing;
    if (val == 'finished') return AcademicSituation.finished;
    if (val == 'interrupted') return AcademicSituation.interrupted;

    debugPrint('Academic situation value: $val, not found');

    return AcademicSituation.finished;
  }

  static AcademicSituation fromTxt(String txt) {
    if (txt == 'finishing') return AcademicSituation.finishing;
    if (txt == 'finished') return AcademicSituation.finished;
    if (txt == 'interrupted') return AcademicSituation.interrupted;

    return AcademicSituation.finished;
  }
}

enum Formation {
  firstGrau,
  secondGrau,
  technic,
  graduation,
  posGraduation,
  master,
  doctor;

  String get label => switch (this) {
        Formation.firstGrau => 'Ensino Fundamental (1º grau)',
        Formation.secondGrau => 'Ensino Médio (2º grau)',
        Formation.technic => 'Nível ténico',
        Formation.graduation => 'Gradução',
        Formation.posGraduation => 'Pós-Graduação',
        Formation.master => 'Mestrado',
        Formation.doctor => 'Doutorado',
      };

  Map<String, dynamic> toMap() {
    return <String, String>{
      'formation': switch (this) {
        Formation.firstGrau => 'first_grau',
        Formation.secondGrau => 'second_grau',
        Formation.technic => 'technic',
        Formation.graduation => 'graduation',
        Formation.posGraduation => 'pos_graduation',
        Formation.master => 'master',
        Formation.doctor => 'doctor',
      }
    };
  }

  static Formation fromMap(Map<String, dynamic> map) {
    final value = map['formation'];

    final formation = switch (value) {
      'first_grau' => Formation.firstGrau,
      'second_grau' => Formation.secondGrau,
      'technic' => Formation.technic,
      'graduation' => Formation.graduation,
      'pos_graduation' => Formation.posGraduation,
      'master' => Formation.master,
      'doctor' => Formation.doctor,
      _ => null,
    };

    if (formation == null) {
      debugPrint('Formation: Value - $value not found');
      return Formation.secondGrau;
    }

    return formation;
  }
}

class AcademicFormation {
  final Formation formation;
  final String courseName;
  final String organization;
  final AcademicSituation situation;
  final DateTime? endDate;

  AcademicFormation({
    required this.courseName,
    required this.organization,
    required this.situation,
    required this.formation,
    this.endDate,
  });

  AcademicFormation copyWith({
    String? courseName,
    String? organization,
    AcademicSituation? situation,
    DateTime? endDate,
    Formation? formation,
  }) {
    return AcademicFormation(
      courseName: courseName ?? this.courseName,
      organization: organization ?? this.organization,
      situation: situation ?? this.situation,
      endDate: endDate ?? this.endDate,
      formation: formation ?? this.formation,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'courseName': courseName,
      'organization': organization,
      'endDate': endDate?.millisecondsSinceEpoch,
      ...situation.toMap(),
      ...formation.toMap()
    };
  }

  factory AcademicFormation.fromMap(Map<String, dynamic> map) {
    return AcademicFormation(
      courseName: map['courseName'] as String,
      organization: map['organization'] as String,
      situation: AcademicSituation.fromTxt(map['situation'] as String),
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int)
          : null,
      formation: Formation.fromMap(map),
    );
  }

  String toJson() => json.encode(toMap());

  factory AcademicFormation.fromJson(String source) =>
      AcademicFormation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AcademicFormation(courseName: $courseName, organization: $organization, situation: $situation, endDate: $endDate)';
  }

  @override
  bool operator ==(covariant AcademicFormation other) {
    if (identical(this, other)) return true;

    return other.courseName == courseName &&
        other.organization == organization &&
        other.situation == situation &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    return courseName.hashCode ^
        organization.hashCode ^
        situation.hashCode ^
        endDate.hashCode;
  }
}

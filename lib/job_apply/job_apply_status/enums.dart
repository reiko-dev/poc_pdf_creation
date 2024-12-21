import 'package:flutter/material.dart';
import 'package:poc_pdf_creation/job_apply/mixins.dart';

enum SummonedState implements Labeled {
  initiated('initiated', 'Convocado para entrevista'),
  failed('failed', 'Reprovado na entrevista'),
  didNotAttend('didNotAttend', 'Não compareceu na entrevista');

  const SummonedState(this.txtEndpoint, this.label);

  final String txtEndpoint;

  @override
  final String label;

  static SummonedState fromString(String txtEndpoint) {
    return switch (txtEndpoint) {
      'initiated' => initiated,
      'failed' => failed,
      'didNotAttend' => didNotAttend,
      _ => throw Exception('Invalid SummonedState: $txtEndpoint'),
    };
  }
}

enum JobApplyStatusType implements Labeled, ColorFull {
  initiated(txtEndpoint: 'initiated'),
  incompatible(txtEndpoint: 'incompatible'),

  summonedForInterview(txtEndpoint: 'summonedForInterview'),
  summonedForClientInterview(txtEndpoint: 'summonedForTechnicalInterview'),
  summonedForPsychologicalInterview(
    txtEndpoint: 'summonedForPsychologicalInterview',
  ),
  failedInInterview(txtEndpoint: 'failedInInterview'),
  withdrew(txtEndpoint: 'withdrew'),
  hired(txtEndpoint: 'hired'),
  ;

  const JobApplyStatusType({
    required this.txtEndpoint,
  });

  final String txtEndpoint;

  bool get isInterview => switch (this) {
        initiated ||
        incompatible ||
        withdrew ||
        hired ||
        failedInInterview =>
          false,
        summonedForInterview ||
        summonedForClientInterview ||
        summonedForPsychologicalInterview =>
          true,
      };

  @override
  Color get color {
    return switch (this) {
      initiated => Colors.amber,
      incompatible || withdrew || failedInInterview => Colors.red,
      summonedForInterview => Colors.blue.shade200,
      summonedForClientInterview => Colors.blue,
      summonedForPsychologicalInterview => Colors.blue.shade800,
      hired => Colors.green,
    };
  }

  static List<JobApplyStatusType> get reviewedStatus =>
      List.from(JobApplyStatusType.values)..where((e) => e != initiated);

  static List<JobApplyStatusType> get unreviewedStatus => [initiated];

  @override
  String get label {
    return switch (this) {
      initiated => 'Inicial',
      incompatible => 'Incompatível',
      summonedForInterview => 'Convocado para entrevista',
      summonedForClientInterview => 'Convocado para entrevista com o Cliente',
      summonedForPsychologicalInterview =>
        'Convocado para entrevista psicológica',
      failedInInterview => 'Reprovado na entrevista',
      hired => 'Contratado',
      withdrew => 'Desistiu',
    };
  }

  static JobApplyStatusType fromString(String txtEndpoint) {
    return JobApplyStatusType.values.firstWhere(
      (e) => e.txtEndpoint == txtEndpoint,
    );
  }
}

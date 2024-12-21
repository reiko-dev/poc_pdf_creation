import 'package:flutter/material.dart';
import 'package:poc_pdf_creation/core/date_time.dart';
import 'package:poc_pdf_creation/job_apply/extensions.dart';
import 'package:poc_pdf_creation/job_apply/job_apply_status/index.dart';
import 'package:poc_pdf_creation/job_apply/mixins.dart';
import 'package:poc_pdf_creation/job_apply/user.dart';

sealed class JobApplyStatus implements Labeled {
  final DateTime eventDate;
  final String? observations;
  final JobApplyStatusType type;
  final User userWhoRegisteredEvent;

  const JobApplyStatus({
    required this.type,
    required this.observations,
    required this.eventDate,
    required this.userWhoRegisteredEvent,
  });

  @override
  String get label {
    return switch (this) {
      JASInitiated() =>
        'Inserido no Processo em ${CustomDateFormatter.dateToBrWithBars(eventDate)!}',
      JASIncompatible() => 'Fora do perfil',
      JASSummonedForInterview(state: var state) => state.label,
      JASSummonedForClientInterview(state: var state) =>
        '${state.label} técnica',
      JASSummonedForPsychologicalInterview(state: var state) =>
        '${state.label} psicológica',
      JASSHired() => 'Contratado!',
      JASWithdrew() => 'Desistente',
      JASFailedInInterview() => 'Não passou na entrevista',
      InterviewState() => throw Exception('Invalid InterviewState'),
    };
  }

  List<(String, TextStyle)> get details {
    final formattedDate =
        CustomDateFormatter.dateToBrExtensiveWithHour(eventDate);

    List<(String, TextStyle)> lista = [];
    const boldStyle = TextStyle(fontWeight: FontWeight.bold);
    const normalStyle = TextStyle(fontWeight: FontWeight.normal);

    lista.add(("${type.label}\n", boldStyle.copyWith(fontSize: 16)));

    if (this is InterviewState) {
      final formattedEventDate = CustomDateFormatter.dateToBrExtensiveWithHour(
        (this as InterviewState).interviewDate,
      );
      lista.add(('\nData da entrevista: ', boldStyle));
      lista.add((formattedEventDate!, normalStyle));
    }

    lista.add((
      '\n\n$formattedDate por ${userWhoRegisteredEvent.name.firstWord}\n\n',
      normalStyle.copyWith(fontStyle: FontStyle.italic)
    ));

    if (observations != null && observations!.isNotEmpty) {
      lista.add(('Observações:\n', boldStyle));
      lista.add((observations!, normalStyle));
    }
    return lista;
  }

  static JobApplyStatus fromMap(Map<String, dynamic> map) {
    final type = JobApplyStatusType.fromString(map['type']);
    return switch (type) {
      JobApplyStatusType.failedInInterview => JASFailedInInterview.fromMap(map),
      JobApplyStatusType.initiated => JASInitiated.fromMap(map),
      JobApplyStatusType.incompatible => JASIncompatible.fromMap(map),
      JobApplyStatusType.summonedForInterview =>
        JASSummonedForInterview.fromMap(map),
      JobApplyStatusType.summonedForClientInterview =>
        JASSummonedForClientInterview.fromMap(map),
      JobApplyStatusType.summonedForPsychologicalInterview =>
        JASSummonedForPsychologicalInterview.fromMap(map),
      JobApplyStatusType.hired => JASSHired.fromMap(map),
      JobApplyStatusType.withdrew => JASWithdrew.fromMap(map),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'eventDate': eventDate.millisecondsSinceEpoch,
      'observations': observations,
      'userWhoRegisteredEvent': userWhoRegisteredEvent.toMap(),
      'type': type.txtEndpoint,
    };
  }
}

abstract class InterviewState extends JobApplyStatus {
  final DateTime interviewDate;
  final SummonedState state;

  const InterviewState({
    required this.interviewDate,
    required this.state,
    required super.eventDate,
    required super.type,
    required super.userWhoRegisteredEvent,
    super.observations,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'interviewDate': interviewDate.millisecondsSinceEpoch,
      'state': state.txtEndpoint,
    };
  }
}

class JASInitiated extends JobApplyStatus {
  JASInitiated({
    required super.userWhoRegisteredEvent,
    required super.eventDate,
    super.observations,
  }) : super(type: JobApplyStatusType.initiated);

  JASInitiated.initial({
    required super.userWhoRegisteredEvent,
    super.observations,
  }) : super(
          eventDate: DateTime.now(),
          type: JobApplyStatusType.initiated,
        );

  factory JASInitiated.fromMap(Map<String, dynamic> map) {
    return JASInitiated(
      userWhoRegisteredEvent: User.fromMap(map['userWhoRegisteredEvent']),
      eventDate: DateTime.fromMillisecondsSinceEpoch(map['eventDate']),
      observations: map['observations'],
    );
  }
}

class JASIncompatible extends JobApplyStatus {
  const JASIncompatible({
    required super.eventDate,
    required super.userWhoRegisteredEvent,
    super.observations,
  }) : super(type: JobApplyStatusType.incompatible);

  factory JASIncompatible.fromMap(Map<String, dynamic> map) {
    return JASIncompatible(
      userWhoRegisteredEvent: User.fromMap(map['userWhoRegisteredEvent']),
      eventDate: DateTime.fromMillisecondsSinceEpoch(map['eventDate']),
      observations: map['observations'],
    );
  }
}

class JASFailedInInterview extends JobApplyStatus {
  const JASFailedInInterview({
    required super.eventDate,
    required super.userWhoRegisteredEvent,
    super.observations,
  }) : super(type: JobApplyStatusType.failedInInterview);

  factory JASFailedInInterview.fromMap(Map<String, dynamic> map) {
    return JASFailedInInterview(
      userWhoRegisteredEvent: User.fromMap(map['userWhoRegisteredEvent']),
      eventDate: DateTime.fromMillisecondsSinceEpoch(map['eventDate']),
      observations: map['observations'],
    );
  }
}

class JASSummonedForInterview extends InterviewState {
  const JASSummonedForInterview({
    super.observations,
    required super.state,
    required super.interviewDate,
    required super.eventDate,
    required super.userWhoRegisteredEvent,
  }) : super(type: JobApplyStatusType.summonedForInterview);

  factory JASSummonedForInterview.fromMap(Map<String, dynamic> map) {
    return JASSummonedForInterview(
      userWhoRegisteredEvent: User.fromMap(map['userWhoRegisteredEvent']),
      state: SummonedState.fromString(map['state']),
      interviewDate: DateTime.fromMillisecondsSinceEpoch(map['interviewDate']),
      eventDate: DateTime.fromMillisecondsSinceEpoch(map['eventDate']),
      observations: map['observations'],
    );
  }
}

class JASSummonedForClientInterview extends InterviewState {
  const JASSummonedForClientInterview({
    required super.state,
    required super.interviewDate,
    super.observations,
    required super.eventDate,
    required super.userWhoRegisteredEvent,
  }) : super(type: JobApplyStatusType.summonedForClientInterview);

  factory JASSummonedForClientInterview.fromMap(Map<String, dynamic> map) {
    return JASSummonedForClientInterview(
      userWhoRegisteredEvent: User.fromMap(map['userWhoRegisteredEvent']),
      eventDate: DateTime.fromMillisecondsSinceEpoch(map['eventDate']),
      interviewDate: DateTime.fromMillisecondsSinceEpoch(map['interviewDate']),
      state: SummonedState.fromString(map['state']),
      observations: map['observations'],
    );
  }
}

class JASSummonedForPsychologicalInterview extends InterviewState {
  const JASSummonedForPsychologicalInterview({
    super.observations,
    required super.state,
    required super.interviewDate,
    required super.eventDate,
    required super.userWhoRegisteredEvent,
  }) : super(type: JobApplyStatusType.summonedForPsychologicalInterview);

  factory JASSummonedForPsychologicalInterview.fromMap(
    Map<String, dynamic> map,
  ) {
    return JASSummonedForPsychologicalInterview(
      userWhoRegisteredEvent: User.fromMap(map['userWhoRegisteredEvent']),
      eventDate: DateTime.fromMillisecondsSinceEpoch(map['eventDate']),
      interviewDate: DateTime.fromMillisecondsSinceEpoch(map['interviewDate']),
      state: SummonedState.fromString(map['state']),
      observations: map['observations'],
    );
  }
}

class JASSHired extends JobApplyStatus {
  const JASSHired({
    required super.eventDate,
    super.observations,
    required super.userWhoRegisteredEvent,
  }) : super(type: JobApplyStatusType.hired);

  factory JASSHired.fromMap(Map<String, dynamic> map) {
    return JASSHired(
      userWhoRegisteredEvent: User.fromMap(map['userWhoRegisteredEvent']),
      eventDate: DateTime.fromMillisecondsSinceEpoch(map['eventDate']),
      observations: map['observations'],
    );
  }
}

class JASWithdrew extends JobApplyStatus {
  const JASWithdrew({
    required super.eventDate,
    super.observations,
    required super.userWhoRegisteredEvent,
  }) : super(type: JobApplyStatusType.withdrew);

  factory JASWithdrew.fromMap(Map<String, dynamic> map) {
    return JASWithdrew(
      userWhoRegisteredEvent: User.fromMap(map['userWhoRegisteredEvent']),
      eventDate: DateTime.fromMillisecondsSinceEpoch(map['eventDate']),
      observations: map['observations'],
    );
  }
}

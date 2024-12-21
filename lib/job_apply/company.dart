import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:poc_pdf_creation/job_apply/manager.dart';
import 'package:poc_pdf_creation/models/index.dart';

class Company {
  final String uid;
  final String? name;
  final List<String> emails;
  final bool isEmailVerified;
  final String? picture;
  final bool isActive;
  final String? cellphone;
  final DateTime createdAt;
  final DateTime updatedAt;
  static const collection = 'companies';
  final String? socialReason;
  final String? activityContext;
  final List<Manager> managers;
  final String? phone2;
  final String? cnpj;
  final String? logo;
  final Address? address;
  final String? site;
  final DateTime? contractDate;

  ///O percentual cobrado em %
  final double? contractPercentage;
  final bool? applyPsichologicalEvaluation;
  final double? psychologicalEvaluationValue;

  final bool applyProfiler;
  final double profilerValue;
  //In percentage
  final double cancellationPenalty;
  final String? status;

  final String? observations;
  final String? stateSubscription;
  final List<String> billingEmail;
  final bool? mailling;
  final String? paymentTerm;
  final String? replacementDeadline;
  final String? retemIss;
  final String? contato;

  const Company({
    required this.uid,
    this.name,
    required this.socialReason,
    required this.activityContext,
    required this.managers,
    required this.cellphone,
    required this.phone2,
    this.cnpj,
    required this.address,
    required this.emails,
    required this.site,
    required this.contractDate,
    required this.contractPercentage,
    required this.applyPsichologicalEvaluation,
    required this.psychologicalEvaluationValue,
    required this.applyProfiler,
    required this.profilerValue,
    required this.cancellationPenalty,
    required this.observations,
    this.isEmailVerified = true,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.picture,
    this.logo,
    this.status,
    this.stateSubscription,
    this.billingEmail = const [],
    this.mailling,
    this.paymentTerm,
    this.replacementDeadline,
    this.retemIss,
    this.contato,
  });

  Company copyWith({
    String? uid,
    String? name,
    List<String>? emails,
    bool? isEmailVerified,
    String? picture,
    bool? isActive,
    String? cellphone,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? socialReason,
    String? activityContext,
    List<Manager>? managers,
    String? phone2,
    String? cnpj,
    String? logo,
    Address? address,
    String? site,
    DateTime? contractDate,
    double? contractPercentage,
    bool? applyPsichologicalEvaluation,
    double? psychologicalEvaluationValue,
    bool? applyProfiler,
    double? profilerValue,
    double? cancellationPenalty,
    String? status,
    String? observations,
    String? stateSubscription,
    List<String>? billingEmail,
    bool? mailling,
    String? paymentTerm,
    String? replacementDeadline,
    String? retemIss,
    String? contato,
  }) {
    return Company(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      emails: emails ?? this.emails,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      picture: picture ?? this.picture,
      isActive: isActive ?? this.isActive,
      cellphone: cellphone ?? this.cellphone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      socialReason: socialReason ?? this.socialReason,
      activityContext: activityContext ?? this.activityContext,
      managers: managers ?? this.managers,
      phone2: phone2 ?? this.phone2,
      cnpj: cnpj ?? this.cnpj,
      logo: logo ?? this.logo,
      address: address ?? this.address,
      site: site ?? this.site,
      contractDate: contractDate ?? this.contractDate,
      contractPercentage: contractPercentage ?? this.contractPercentage,
      applyPsichologicalEvaluation:
          applyPsichologicalEvaluation ?? this.applyPsichologicalEvaluation,
      psychologicalEvaluationValue:
          psychologicalEvaluationValue ?? this.psychologicalEvaluationValue,
      applyProfiler: applyProfiler ?? this.applyProfiler,
      profilerValue: profilerValue ?? this.profilerValue,
      cancellationPenalty: cancellationPenalty ?? this.cancellationPenalty,
      status: status ?? this.status,
      observations: observations ?? this.observations,
      stateSubscription: stateSubscription ?? this.stateSubscription,
      billingEmail: billingEmail ?? this.billingEmail,
      mailling: mailling ?? this.mailling,
      paymentTerm: paymentTerm ?? this.paymentTerm,
      replacementDeadline: replacementDeadline ?? this.replacementDeadline,
      retemIss: retemIss ?? this.retemIss,
      contato: contato ?? this.contato,
    );
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    try {
      final emails = <String>[];
      if (map['emails'] != null) {
        if (map['emails'] is List) {
          emails.addAll(
            (map['emails'] as List).map((e) => e as String),
          );
        }

        if (map['emails'] is String) {
          emails.add(map['emails'] as String);
        }
      }

      final billingEmailsData = (map['billingEmail'] as List?) ?? [];
      final billingEmails = billingEmailsData.map((e) => e as String).toList();

      double? contractPercentage = 0.0;
      if (map['contractPercentage'] is double) {
        contractPercentage = map['contractPercentage'];
      } else if (map['contractPercentage'] is String) {
        contractPercentage =
            double.tryParse(map['contractPercentage'] as String);
      }

      var managers = <Manager>[];

      if (map['managers'] != null) {
        if (map['managers'] is List) {
          managers = List<Manager>.from(
            (map['managers'] as List).map<Manager>(
              (x) => Manager.fromMap(x as Map<String, dynamic>),
            ),
          );
        } else {
          if (map['managers'] is String) {
            managers = [
              Manager(
                uid: '',
                name: map['managers'] as String,
              ),
            ];
          }
        }
      }

      double cancellationPenalty = 0;
      if (map['cancellationPenalty'] is double) {
        cancellationPenalty = map['cancellationPenalty'];
      } else if (map['cancellationPenalty'] is String) {
        final text = (map['cancellationPenalty'] as String).replaceAll('%', '');
        cancellationPenalty = double.tryParse(text) ?? 0;
      }

      return Company(
        uid: (map['uid'] ?? map['objectID']) as String,
        name: map['name'],
        emails: emails,
        isEmailVerified: map['isEmailVerified'] ?? false,
        picture: map['picture'] != null ? map['picture'] as String : null,
        isActive: map['isActive'] ?? true,
        cellphone: map['cellphone'] != null ? map['cellphone'] as String : null,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
        socialReason:
            map['socialReason'] != null ? map['socialReason'] as String : null,
        activityContext: map['activityContext'] != null
            ? map['activityContext'] as String
            : null,
        managers: managers,
        phone2: map['phone2'] != null ? map['phone2'] as String : null,
        cnpj: map['cnpj'],
        logo: map['logo'] != null ? map['logo'] as String : null,
        address: map['address'] != null
            ? Address.fromMap(map['address'] as Map<String, dynamic>)
            : null,
        site: map['site'] != null ? map['site'] as String : null,
        contractDate: map['contractDate'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['contractDate'] as int)
            : null,
        contractPercentage: contractPercentage,
        applyPsichologicalEvaluation:
            map['applyPsichologicalEvaluation'] != null
                ? map['applyPsichologicalEvaluation'] as bool
                : null,
        psychologicalEvaluationValue: map['psychologicalEvaluationValue'] ==
                null
            ? null
            : double.tryParse(map['psychologicalEvaluationValue'].toString()),
        applyProfiler: map['applyProfiler'] ?? true,
        profilerValue: map['profilerValue'] ?? 0,
        cancellationPenalty: cancellationPenalty,
        status: map['status'],
        observations: map['observations'],
        stateSubscription: map['stateSubscription'],
        billingEmail: billingEmails,
        mailling: map['mailling'] == null
            ? null
            : map['mailling'] == 'S' || map['mailling'] == 's',
        paymentTerm: map['paymentTerm'],
        replacementDeadline: map['replacementDeadline'],
        retemIss: map['retemIss'],
        contato: map['contato'],
      );
    } catch (e, st) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: st);
      throw ('It was not possible to get the Company instance');
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': emails,
      'isEmailVerified': isEmailVerified,
      'picture': picture,
      'isActive': isActive,
      'cellphone': cellphone,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'socialReason': socialReason,
      'activityContext': activityContext,
      'managers': managers.map((x) => x.toMap()).toList(),
      'phone2': phone2,
      'cnpj': cnpj,
      'logo': logo,
      'address': address?.toMap(),
      'site': site,
      'contractDate': contractDate?.millisecondsSinceEpoch,
      'contractPercentage': contractPercentage,
      'applyPsichologicalEvaluation': applyPsichologicalEvaluation,
      'psychologicalEvaluationValue': psychologicalEvaluationValue,
      'applyProfiler': applyProfiler,
      'profilerValue': profilerValue,
      'cancellationPenalty': cancellationPenalty,
      'status': status,
      'observations': observations,
      'stateSubscription': stateSubscription,
      'billingEmail': billingEmail,
      'mailling': mailling,
      'paymentTerm': paymentTerm,
      'replacementDeadline': replacementDeadline,
      'retemIss': retemIss,
      'contato': contato,
      'role': 'company',
    };
  }

  static List<String> get searchFields => [
        'name',
        'socialReason',
        'managers',
        'cnpj',
      ];

  String toJson() => json.encode(toMap());

  factory Company.fromJson(String source) =>
      Company.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Company(uid: $uid, name: $name, email: $emails, isEmailVerified: $isEmailVerified, picture: $picture, isActive: $isActive, cellphone: $cellphone, createdAt: $createdAt, updatedAt: $updatedAt, socialReason: $socialReason, activityContext: $activityContext, managers: $managers, phone2: $phone2, cnpj: $cnpj, logo: $logo, address: $address, site: $site, contractDate: $contractDate, contractPercentage: $contractPercentage, applyPsichologicalEvaluation: $applyPsichologicalEvaluation, psychologicalEvaluationValue: $psychologicalEvaluationValue, applyProfiler: $applyProfiler, profilerValue: $profilerValue, cancellationPenalty: $cancellationPenalty, status: $status, observations: $observations, stateSubscription: $stateSubscription, billingEmail: $billingEmail, mailling: $mailling, paymentTerm: $paymentTerm, replacementDeadline: $replacementDeadline, retemIss: $retemIss, contato: $contato)';
  }

  @override
  bool operator ==(covariant Company other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.emails == emails &&
        other.isEmailVerified == isEmailVerified &&
        other.picture == picture &&
        other.isActive == isActive &&
        other.cellphone == cellphone &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.socialReason == socialReason &&
        other.activityContext == activityContext &&
        listEquals(other.managers, managers) &&
        other.phone2 == phone2 &&
        other.cnpj == cnpj &&
        other.logo == logo &&
        other.address == address &&
        other.site == site &&
        other.contractDate == contractDate &&
        other.contractPercentage == contractPercentage &&
        other.applyPsichologicalEvaluation == applyPsichologicalEvaluation &&
        other.psychologicalEvaluationValue == psychologicalEvaluationValue &&
        other.applyProfiler == applyProfiler &&
        other.profilerValue == profilerValue &&
        other.cancellationPenalty == cancellationPenalty &&
        other.status == status &&
        other.observations == observations &&
        other.stateSubscription == stateSubscription &&
        listEquals(other.billingEmail, billingEmail) &&
        other.mailling == mailling &&
        other.paymentTerm == paymentTerm &&
        other.replacementDeadline == replacementDeadline &&
        other.retemIss == retemIss &&
        other.contato == contato;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        emails.hashCode ^
        isEmailVerified.hashCode ^
        picture.hashCode ^
        isActive.hashCode ^
        cellphone.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        socialReason.hashCode ^
        activityContext.hashCode ^
        managers.hashCode ^
        phone2.hashCode ^
        cnpj.hashCode ^
        logo.hashCode ^
        address.hashCode ^
        site.hashCode ^
        contractDate.hashCode ^
        contractPercentage.hashCode ^
        applyPsichologicalEvaluation.hashCode ^
        psychologicalEvaluationValue.hashCode ^
        applyProfiler.hashCode ^
        profilerValue.hashCode ^
        cancellationPenalty.hashCode ^
        status.hashCode ^
        observations.hashCode ^
        stateSubscription.hashCode ^
        billingEmail.hashCode ^
        mailling.hashCode ^
        paymentTerm.hashCode ^
        replacementDeadline.hashCode ^
        retemIss.hashCode ^
        contato.hashCode;
  }
}

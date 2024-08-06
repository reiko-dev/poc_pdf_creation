import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:poc_pdf_creation/curriculum/index.dart';
import 'package:poc_pdf_creation/models/index.dart';

class Curriculum {
  static const collection = 'curriculum';
  final String uid;
  final String name;
  final String cpf;
  final String nascimento;
  final CivilState civilState;
  final Sex sex;
  final String country;
  final int qtdFilhos;
  final Cnh cnh;
  final bool veiculoProprio;
  final bool disponibilidadeParaViagem;
  final bool disponibilidadeParaMudanca;
  final String? disability;
  final String phone;
  final String? phone2;
  final String email;
  final String? linkedin;
  final String? facebook;
  final String? instagram;
  final Address address;
  final String desiredPosition;
  final double? salaryPretension;
  final String professionalObjectives;
  final List<AcademicFormation> academicFormation;
  final List<ProfessionalExperience> professionalExperience;
  final List<Course> courses;
  final String userUID;
  final EnglishLevel? englishLevel;

  Curriculum({
    required this.name,
    required this.cpf,
    required this.nascimento,
    required this.civilState,
    required this.sex,
    required this.country,
    required this.qtdFilhos,
    required this.cnh,
    required this.veiculoProprio,
    required this.disponibilidadeParaViagem,
    required this.disponibilidadeParaMudanca,
    this.disability,
    required this.phone,
    this.phone2,
    required this.email,
    this.linkedin,
    this.facebook,
    this.instagram,
    required this.address,
    required this.desiredPosition,
    this.salaryPretension,
    required this.professionalObjectives,
    required this.academicFormation,
    required this.professionalExperience,
    required this.courses,
    required this.userUID,
    required this.uid,
    this.englishLevel,
  });

  Curriculum copyWith(
      {String? name,
      String? cpf,
      String? nascimento,
      CivilState? civilState,
      Sex? sex,
      String? country,
      int? qtdFilhos,
      Cnh? cnh,
      bool? veiculoProprio,
      bool? disponibilidadeParaViagem,
      bool? disponibilidadeParaMudanca,
      String? disability,
      String? phone,
      String? phone2,
      String? email,
      String? linkedin,
      String? facebook,
      String? instagram,
      String? cep,
      Address? address,
      int? addressNumber,
      String? complement,
      String? neighborhood,
      String? city,
      String? state,
      String? desiredPosition,
      double? salaryPretension,
      String? professionalObjectives,
      List<AcademicFormation>? academicFormation,
      List<ProfessionalExperience>? professionalExperience,
      List<Course>? courses,
      String? userUID,
      String? uid,
      EnglishLevel? englishLevel}) {
    return Curriculum(
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      nascimento: nascimento ?? this.nascimento,
      civilState: civilState ?? this.civilState,
      sex: sex ?? this.sex,
      country: country ?? this.country,
      qtdFilhos: qtdFilhos ?? this.qtdFilhos,
      cnh: cnh ?? this.cnh,
      veiculoProprio: veiculoProprio ?? this.veiculoProprio,
      disponibilidadeParaViagem:
          disponibilidadeParaViagem ?? this.disponibilidadeParaViagem,
      disponibilidadeParaMudanca:
          disponibilidadeParaMudanca ?? this.disponibilidadeParaMudanca,
      disability: disability ?? this.disability,
      phone: phone ?? this.phone,
      phone2: phone2 ?? this.phone2,
      email: email ?? this.email,
      linkedin: linkedin ?? this.linkedin,
      facebook: facebook ?? this.facebook,
      instagram: instagram ?? this.instagram,
      address: address ?? this.address,
      desiredPosition: desiredPosition ?? this.desiredPosition,
      salaryPretension: salaryPretension ?? this.salaryPretension,
      professionalObjectives:
          professionalObjectives ?? this.professionalObjectives,
      academicFormation: academicFormation ?? this.academicFormation,
      professionalExperience:
          professionalExperience ?? this.professionalExperience,
      courses: courses ?? this.courses,
      userUID: userUID ?? this.userUID,
      uid: uid ?? this.uid,
      englishLevel: englishLevel ?? this.englishLevel,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': name,
      'cpf': cpf,
      'nascimento': nascimento,
      'civilState': civilState.name,
      'sex': sex.name,
      'country': country,
      'qtdFilhos': qtdFilhos,
      'cnh': cnh.name,
      'veiculoProprio': veiculoProprio,
      'disponibilidadeParaViagem': disponibilidadeParaViagem,
      'disponibilidadeParaMudanca': disponibilidadeParaMudanca,
      'deficiencia': disability,
      'phone': phone,
      'phone2': phone2,
      'email': email,
      'linkedin': linkedin,
      'facebook': facebook,
      'instagram': instagram,
      'address': address.toMap(),
      'desiredPosition': desiredPosition,
      'salaryPretension': salaryPretension,
      'professionalObjectives': professionalObjectives,
      'academicFormation': academicFormation.map((x) => x.toMap()).toList(),
      'professionalExperience':
          professionalExperience.map((x) => x.toMap()).toList(),
      'courses': courses.map((x) => x.toMap()).toList(),
      'userUID': userUID,
      'uid': uid,
      'englishLevel': englishLevel?.name,
    };
  }

  factory Curriculum.fromMap(Map<String, dynamic> map) {
    return Curriculum(
      uid: map['uid'] as String,
      userUID: map['userUID'] as String,
      name: map['nome'] as String,
      cpf: map['cpf'] as String,
      nascimento: map['nascimento'] as String,
      civilState: CivilState.fromText(map['civilState'] as String),
      sex: Sex.fromTxt(map['sex'] as String),
      country: map['country'] as String,
      qtdFilhos: map['qtdFilhos'] as int,
      cnh: Cnh.fromTxt(map['cnh']),
      veiculoProprio: map['veiculoProprio'] as bool,
      disponibilidadeParaViagem: map['disponibilidadeParaViagem'] as bool,
      disponibilidadeParaMudanca: map['disponibilidadeParaMudanca'] as bool,
      disability:
          map['deficiencia'] != null ? map['deficiencia'] as String : null,
      phone: map['phone'] as String,
      phone2: map['phone2'] != null ? map['phone2'] as String : null,
      email: map['email'] as String,
      linkedin: map['linkedin'] != null ? map['linkedin'] as String : null,
      facebook: map['facebook'] != null ? map['facebook'] as String : null,
      instagram: map['instagram'] != null ? map['instagram'] as String : null,
      address: Address.fromMap(map['address']),
      desiredPosition: map['desiredPosition'] as String,
      salaryPretension: map['salaryPretension'] != null
          ? map['salaryPretension'] as double
          : null,
      professionalObjectives: map['professionalObjectives'] as String,
      academicFormation: List<AcademicFormation>.from(
        (map['academicFormation'] as List).map<AcademicFormation>(
          (x) => AcademicFormation.fromMap(x as Map<String, dynamic>),
        ),
      ),
      professionalExperience: List<ProfessionalExperience>.from(
        (map['professionalExperience'] as List).map<ProfessionalExperience>(
          (x) => ProfessionalExperience.fromMap(x as Map<String, dynamic>),
        ),
      ),
      courses: List<Course>.from(
        (map['courses'] as List).map<Course>(
          (x) => Course.fromMap(x as Map<String, dynamic>),
        ),
      ),
      englishLevel: map['englishLevel'] != null
          ? EnglishLevel.fromName(map['englishLevel'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Curriculum.fromJson(String source) =>
      Curriculum.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Curriculum(uid: $uid, nome: $name, cpf: $cpf, nascimento: $nascimento, civilState: $civilState, sex: $sex, country: $country, qtdFilhos: $qtdFilhos, cnh: $cnh, veiculoProprio: $veiculoProprio, disponibilidadeParaViagem: $disponibilidadeParaViagem, disponibilidadeParaMudanca: $disponibilidadeParaMudanca, deficiencia: $disability, phone: $phone, phone2: $phone2, email: $email, linkedin: $linkedin, facebook: $facebook, instagram: $instagram, address: $address, desiredPosition: $desiredPosition, salaryPretension: $salaryPretension, professionalObjectives: $professionalObjectives, academicFormation: $academicFormation, professionalExperience: $professionalExperience, courses: $courses, userUID: $userUID, englishLevel: ${englishLevel?.name})';
  }

  @override
  bool operator ==(covariant Curriculum other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.cpf == cpf &&
        other.nascimento == nascimento &&
        other.civilState == civilState &&
        other.sex == sex &&
        other.country == country &&
        other.qtdFilhos == qtdFilhos &&
        other.cnh == cnh &&
        other.veiculoProprio == veiculoProprio &&
        other.disponibilidadeParaViagem == disponibilidadeParaViagem &&
        other.disponibilidadeParaMudanca == disponibilidadeParaMudanca &&
        other.disability == disability &&
        other.phone == phone &&
        other.phone2 == phone2 &&
        other.email == email &&
        other.linkedin == linkedin &&
        other.facebook == facebook &&
        other.instagram == instagram &&
        other.address == address &&
        other.desiredPosition == desiredPosition &&
        other.salaryPretension == salaryPretension &&
        other.userUID == userUID &&
        other.professionalObjectives == professionalObjectives &&
        other.englishLevel == englishLevel &&
        listEquals(other.academicFormation, academicFormation) &&
        listEquals(other.professionalExperience, professionalExperience) &&
        listEquals(other.courses, courses);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        cpf.hashCode ^
        nascimento.hashCode ^
        civilState.hashCode ^
        sex.hashCode ^
        country.hashCode ^
        qtdFilhos.hashCode ^
        cnh.hashCode ^
        veiculoProprio.hashCode ^
        disponibilidadeParaViagem.hashCode ^
        disponibilidadeParaMudanca.hashCode ^
        disability.hashCode ^
        phone.hashCode ^
        phone2.hashCode ^
        email.hashCode ^
        linkedin.hashCode ^
        facebook.hashCode ^
        instagram.hashCode ^
        address.hashCode ^
        desiredPosition.hashCode ^
        salaryPretension.hashCode ^
        professionalObjectives.hashCode ^
        academicFormation.hashCode ^
        professionalExperience.hashCode ^
        courses.hashCode ^
        userUID.hashCode ^
        englishLevel.hashCode;
  }
}

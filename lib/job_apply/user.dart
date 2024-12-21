import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:poc_pdf_creation/job_apply/mixins.dart';

///admin: The Admin of the platform
///analist: employee of the platform that managers job postings
///company: The companies/users that post jobs.
///client: the final user that applies to jobs.
enum Role {
  admin,
  analyst,
  common,
  unknown,
  ;

  static Role fromString(String? role) {
    return Role.values.firstWhere(
      (e) => e.name == role,
      orElse: () => Role.unknown,
    );
  }
}

sealed class User {
  final String uid;
  final String name;
  final String email;
  final bool isEmailVerified;
  final String? picture;
  final Role role;
  final bool isActive;
  final String? cellphone;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.uid,
    required this.name,
    required this.email,
    required this.isEmailVerified,
    this.picture,
    required this.role,
    required this.isActive,
    this.cellphone,
    required this.createdAt,
    required this.updatedAt,
  });

  static const String collection = 'users';

  User copyWith({
    String? uid,
    String? name,
    String? email,
    bool? isEmailVerified,
    String? picture,
    Role? role,
    bool? isActive,
    String? cellphone,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'picture': picture,
      'role': role.name,
      'isActive': isActive,
      'cellphone': cellphone,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    final role = Role.fromString(map['role']);

    try {
      return switch (role) {
        Role.admin => Admin.fromMap(map),
        Role.analyst => Analyst.fromMap(map),
        Role.common => CommonUser.fromMap(map),
        Role.unknown => Admin.fromMap(map),
      };
    } catch (e, st) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(uid: $uid, name: $name, email: $email, isEmailVerified: $isEmailVerified, picture: $picture, role: $role, isActive: $isActive, cellphone: $cellphone, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.isEmailVerified == isEmailVerified &&
        other.picture == picture &&
        other.role == role &&
        other.isActive == isActive &&
        other.cellphone == cellphone &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        isEmailVerified.hashCode ^
        picture.hashCode ^
        role.hashCode ^
        isActive.hashCode ^
        cellphone.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}

class Admin extends User {
  const Admin({
    required super.uid,
    required super.email,
    super.isEmailVerified = true,
    required super.name,
    super.isActive = true,
    required super.createdAt,
    required super.updatedAt,
    super.cellphone,
    super.picture,
  }) : super(role: Role.admin);

  @override
  Admin copyWith({
    String? uid,
    String? name,
    String? email,
    bool? isEmailVerified,
    String? picture,
    Role? role,
    bool? isActive,
    String? cellphone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Admin(
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      name: name ?? this.name,
      uid: uid ?? this.uid,
      isActive: isActive ?? this.isActive,
      cellphone: cellphone ?? super.cellphone,
      picture: picture ?? super.picture,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    try {
      var email = map['email'];
      if (email != null) {
        if (email is List<String>) {
          email = email.join(';');
        }
      }

      var cellphone = map['cellphone'];
      if (cellphone != null) {
        if (cellphone is List<String>) {
          cellphone = cellphone.join(';');
        }
      }

      return Admin(
        cellphone: cellphone,
        email: email,
        isEmailVerified: map['isEmailVerified'],
        name: map['name'],
        uid: map['uid'],
        picture: map['picture'],
        isActive: map['isActive'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      );
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  @override
  String toJson() => json.encode(toMap());

  factory Admin.fromJson(String source) =>
      Admin.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Analyst extends User implements Labeled {
  const Analyst({
    required super.uid,
    required super.email,
    required super.name,
    super.cellphone,
    required super.createdAt,
    required super.updatedAt,
    required super.isActive,
    super.isEmailVerified = false,
    super.picture,
  }) : super(role: Role.analyst);

  factory Analyst.fromMap(Map<String, dynamic> map) {
    return Analyst(
      email: map['email'],
      isEmailVerified: map['isEmailVerified'],
      name: map['name'],
      uid: map['uid'],
      picture: map['picture'],
      isActive: map['isActive'] ?? true,
      cellphone: map['cellphone'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  @override
  Analyst copyWith({
    String? uid,
    String? name,
    String? email,
    bool? isEmailVerified,
    String? picture,
    Role? role,
    bool? isActive,
    String? cellphone,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? totalLeads,
    int? totalLigacoes,
    int? totalPedidos,
    int? totalReunioes,
    int? totalVendas,
  }) {
    return Analyst(
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      name: name ?? this.name,
      uid: uid ?? this.uid,
      isActive: isActive ?? this.isActive,
      cellphone: cellphone ?? super.cellphone,
      picture: picture ?? super.picture,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String get label => name;
}

class CommonUser extends User {
  final String cpf;

  const CommonUser({
    required super.uid,
    required super.email,
    required super.createdAt,
    required super.updatedAt,
    required super.name,
    super.isEmailVerified = true,
    super.isActive = true,
    super.cellphone,
    super.picture,
    required this.cpf,
  }) : super(role: Role.common);

  factory CommonUser.fromMap(Map<String, dynamic> map) {
    try {
      return CommonUser(
        email: map['email'],
        isEmailVerified: map['isEmailVerified'],
        name: map['name'],
        uid: map['uid'],
        picture: map['picture'],
        isActive: map['isActive'],
        cellphone: map['cellphone'],
        cpf: map['cpf'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      );
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  @override
  CommonUser copyWith({
    String? uid,
    String? name,
    String? email,
    bool? isEmailVerified,
    String? picture,
    Role? role,
    bool? isActive,
    String? cellphone,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? cpf,
  }) {
    return CommonUser(
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      name: name ?? this.name,
      uid: uid ?? this.uid,
      isActive: isActive ?? this.isActive,
      cellphone: cellphone ?? super.cellphone,
      picture: picture ?? super.picture,
      cpf: cpf ?? this.cpf,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['cpf'] = cpf;
    return map;
  }
}

import 'dart:convert';

class Manager {
  final String uid;
  final String name;
  final String? email;
  final String? phone;
  final String? phone2;

  Manager({
    required this.uid,
    required this.name,
    this.email,
    this.phone,
    this.phone2,
  });

  Manager copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? phone2,
  }) {
    return Manager(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      phone2: phone2 ?? this.phone2,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      // 'position': position.toMap(),
      'phone': phone,
      'phone2': phone2,
    };
  }

  factory Manager.fromMap(Map<String, dynamic> map) {
    return Manager(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      phone2: map['phone2'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Manager.fromJson(String source) =>
      Manager.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Manager(uid: $uid, name: $name, email: $email, phone: $phone, phone2: $phone2)';
  }

  @override
  bool operator ==(covariant Manager other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        // other.position == position &&
        other.phone == phone &&
        other.phone2 == phone2;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        // position.hashCode ^
        phone.hashCode ^
        phone2.hashCode;
  }
}

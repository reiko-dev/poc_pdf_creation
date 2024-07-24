import 'dart:convert';

import 'package:flutter/material.dart';

class Address {
  final String? cep;
  final String? address;
  final int? addressNumber;
  final String? complement;
  final String? neighborhood;
  final String? city;
  final String? state;

  const Address({
    required this.cep,
    required this.address,
    required this.addressNumber,
    this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  Address copyWith({
    String? cep,
    String? address,
    int? addressNumber,
    String? complement,
    String? neighborhood,
    String? city,
    String? state,
  }) {
    return Address(
      cep: cep ?? this.cep,
      address: address ?? this.address,
      addressNumber: addressNumber ?? this.addressNumber,
      complement: complement ?? this.complement,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cep': cep,
      'address': address,
      'addressNumber': addressNumber,
      'complement': complement,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    try {
      int? number;

      if (map['addressNumber'] is String) {
        number = int.tryParse(map['addressNumber']);
      } else {
        if (map['addressNumber'] is int) {
          number = map['addressNumber'];
        }
      }

      return Address(
        cep: map['cep'],
        address: map['address'],
        addressNumber: number,
        complement: map['complement'],
        neighborhood: map['neighborhood'],
        city: map['city'],
        state: map['state'],
      );
    } catch (e, st) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: st);
      throw ('It was not possible to get the Address instance');
    }
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Address(cep: $cep, address: $address, addressNumber: $addressNumber, complement: $complement, neighborhood: $neighborhood, city: $city, state: $state)';
  }

  @override
  bool operator ==(covariant Address other) {
    if (identical(this, other)) return true;

    return other.cep == cep &&
        other.address == address &&
        other.addressNumber == addressNumber &&
        other.complement == complement &&
        other.neighborhood == neighborhood &&
        other.city == city &&
        other.state == state;
  }

  @override
  int get hashCode {
    return cep.hashCode ^
        address.hashCode ^
        addressNumber.hashCode ^
        complement.hashCode ^
        neighborhood.hashCode ^
        city.hashCode ^
        state.hashCode;
  }
}

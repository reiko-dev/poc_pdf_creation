import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poc_pdf_creation/job_apply/company.dart';
import 'package:poc_pdf_creation/job_apply/user.dart';

extension TimeOfDayExtension on TimeOfDay {
  Map<String, dynamic> toMap() {
    return {
      'hour': hour,
      'minute': minute,
    };
  }

  String get label {
    final minute = this.minute.toString().padLeft(2, '0');
    final hour = this.hour.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String get labelAmPm {
    final minute = this.minute.toString().padLeft(2, '0');

    final hourInt = this.hour < 12 ? this.hour : this.hour - 12;

    final hour = hourInt.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String get amPM {
    final text = '$labelAmPm ';

    if (hour < 12) {
      return '${text}am';
    } else {
      return '${text}pm';
    }
  }
}

TimeOfDay timeOfDayFromMap(Map<String, dynamic> map) {
  return TimeOfDay(
    hour: map['hour'] as int,
    minute: map['minute'] as int,
  );
}

TimeOfDay? timeOfDayFromString(String time) {
  try {
    final List<String> parts;
    if (time.contains(':')) {
      parts = time.split(':');
    } else {
      final values = time.split('');
      parts = [
        values[0] + values[1],
        values[2] + values[3],
      ];
    }
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(
      hour: hour,
      minute: minute,
    );
  } catch (e) {
    return null;
  }
}

extension UserExtension on User? {
  bool get isCommonUser => this is CommonUser;
  bool get isCompany => this is Company;
  bool get isAnalyst => this is Analyst;
  bool get isAdmin => this is Admin;
  bool get isAdminAnalystOrCompany => isAdmin || isAnalyst || isCompany;
}

extension StringExtension on String? {
  String get firstWord {
    if (this == null || this!.isEmpty) return '';

    return this!.split(' ').first;
  }

  String? get firstLetter {
    if (this == null || this!.isEmpty) return '';

    return this![0];
  }

  String get capitalizeOnlyFirst {
    if (this?.isEmpty ?? true) {
      return this ?? '';
    }

    if (this!.length == 1) {
      return this![0].toUpperCase();
    }

    return '${this![0].toUpperCase()}${this!.substring(1)}';
  }

  String get lowercaseOnlyFirst {
    if (this?.isEmpty ?? true) {
      return this ?? '';
    }

    if (this!.length == 1) {
      return this![0].toLowerCase();
    }

    return '${this![0].toLowerCase()}${this!.substring(1)}';
  }

  String? get capitalizeWords {
    if (this == null) return null;

    final words = this!.split(' ');

    String result = words.reduce(
      (a, b) => '${a.capitalizeOnlyFirst} ${b.capitalizeOnlyFirst}',
    );
    return result;
  }

  ///Format a string returning only numbers
  String? get phoneNumbersOnly {
    return this?.replaceAll(RegExp(r'[^0-9]+'), '');
  }
}

extension DecimalExtension on double {
  String get formattedSallary {
    NumberFormat formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    return formatter.format(this);
  }
}

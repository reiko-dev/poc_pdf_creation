import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poc_pdf_creation/curriculum/index.dart';

class CustomDateFormatter {
  CustomDateFormatter._();

  /// Output: 26 de Junho de 2026
  static String? dateToBrExtensive(DateTime? dateTime) {
    if (dateTime == null) return null;
    return DateFormat.yMMMMd('pt_BR').format(dateTime);
  }

  /// Output: 26 de Junho de 2026
  static String? dateToBrExtensiveWithHour(DateTime? dateTime) {
    if (dateTime == null) return null;

    return DateFormat("d 'de' MMMM 'de' y, à's' HH:mm", 'pt_BR')
        .format(dateTime);
  }

  /// Output: Junho de 2026
  static String? monthYearBrExtensive(DateTime? dateTime) {
    if (dateTime == null) return null;
    return DateFormat.yMMM('pt_BR').format(dateTime);
  }

  ///Output: 26/06/2026
  static String? dateToBrWithBars(DateTime? dateTime) {
    if (dateTime == null) return null;

    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String? dateToBrExtensiveMonthYear(DateTime? dateTime) {
    if (dateTime == null) return null;

    return DateFormat('MM/yyyy').format(dateTime);
  }

  static DateTime? fromBrStringToDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;

    try {
      int day, month, year;

      if (dateString.length == 8) {
        day = int.parse(dateString.substring(0, 2));
        month = int.parse(dateString.substring(2, 4));
        year = int.parse(dateString.substring(4, 8));
      } else {
        day = 1;
        month = int.parse(dateString.substring(0, 2));
        year = int.parse(dateString.substring(2, 6));
      }

      final parsedDate = DateTime(year, month, day);

      return parsedDate;
    } on FormatException catch (e) {
      debugPrint("Invalid date format: $e");
      return null;
      // Handle parsing error
    }
  }

  ///"dd/MM/yyyy"
  final dateFormat = DateFormat("dd/MM/yyyy");

  static DateTime? brStringDateToDate(String? date) {
    if (date == null || date.length != 8) return null;

    final dd = date.substring(0, 2);
    final mm = date.substring(2, 4);
    final yyyy = date.substring(4, 8);

    return DateTime(int.parse(yyyy), int.parse(mm), int.parse(dd));
  }

  ///Enter a value like "022024" frebruery of 2024
  static DateTime? brStringMonthYearToDate(String? date) {
    if (date == null || date.length != 6) return null;

    final m = date.substring(0, 2);
    final y = date.substring(2, 6);

    return DateTime(int.parse(y), int.parse(m), 1);
  }

  ///Return null values first, and them return by descending mode.
  static int compareDateTime(DateTime? a, DateTime? b) {
    // Handle null values by placing them first
    if (a == null && b != null) return -1;
    if (a != null && b == null) return 1;

    // If both are null, consider them equal (0)
    if (a == null && b == null) return 0;

    // Sort by year in descending order (biggest to smallest)
    return b!.compareTo(a!);
  }

  ///Return null values first, and them return by descending mode.
  static int compareProfessionalXPDateTime(
    ProfessionalExperience p1,
    ProfessionalExperience p2,
  ) {
    final a = p1.endDate;
    final b = p2.endDate;

    // Handle null values by placing them first
    if (a == null && b != null) return -1;
    if (a != null && b == null) return 1;

    // If both are null, consider them equal (0)
    if (a == null && b == null) return 0;

    // Sort by year in descending order (biggest to smallest)
    return b!.compareTo(a!);
  }

  static int academicFormationXPDateTime(
    AcademicFormation p1,
    AcademicFormation p2,
  ) {
    final a = p1.endDate;
    final b = p2.endDate;

    // Handle null values by placing them first
    if (a == null && b != null) return -1;
    if (a != null && b == null) return 1;

    // If both are null, consider them equal (0)
    if (a == null && b == null) return 0;

    // Sort by year in descending order (biggest to smallest)
    return b!.compareTo(a!);
  }

  static String? dateToBarsMonthYear(DateTime? dateTime) {
    if (dateTime == null) return null;

    return DateFormat('MM/yyyy').format(dateTime);
  }
}

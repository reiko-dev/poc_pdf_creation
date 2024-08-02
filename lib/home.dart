import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:poc_pdf_creation/core/date_time.dart';
import 'package:poc_pdf_creation/curriculum/index.dart';
import 'package:printing/printing.dart';

class CurriculumPDFPage extends StatefulWidget {
  const CurriculumPDFPage({super.key, required this.curriculum});

  final Curriculum curriculum;

  @override
  State<CurriculumPDFPage> createState() => _CurriculumPDFPageState();
}

class _CurriculumPDFPageState extends State<CurriculumPDFPage> {
  late final pw.TtfFont regular;
  late final pw.TtfFont bold;
  late final pw.TtfFont italic;
  late final pw.TtfFont materialIconsFont;

  late final pw.TextStyle sectionTitleStyle;
  late final pw.TextStyle subSectionTitleStyle;
  late final pw.TextStyle bodyItalicStyle;

  bool isLoaded = false;

  Future<void> _loadData() async {
    if (isLoaded) return;
    await Future.wait([
      fontFromAssetBundle('assets/fonts/roboto/Roboto-Regular.ttf')
          .then((value) {
        regular = value;
      }),
      fontFromAssetBundle('assets/fonts/roboto/Roboto-Bold.ttf').then((value) {
        bold = value;
      }),
      fontFromAssetBundle('assets/fonts/roboto/Roboto-Italic.ttf')
          .then((value) {
        italic = value;
      }),
      fontFromAssetBundle(
              'assets/fonts/material_icons/MaterialIcons-Regular.ttf')
          .then((value) {
        materialIconsFont = value;
      }),
    ]);

    sectionTitleStyle = pw.TextStyle(
      font: regular,
      fontSize: 14,
    );

    subSectionTitleStyle = pw.TextStyle(
      font: regular,
      fontSize: 12,
    );

    bodyItalicStyle = pw.TextStyle(
      font: italic,
      fontSize: 12,
    );

    isLoaded = true;
  }

  Future<Uint8List> _generatePdf(Curriculum curriculum) async {
    await _loadData();
    final doc = pw.Document();

    addData(doc, curriculum);

    return doc.save();
  }

  int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final age = now.year - birthDate.year;

    // Handle leap years and months
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      return age - 1;
    } else {
      return age;
    }
  }

  void addData(pw.Document doc, Curriculum curriculum) {
    doc.addPage(
      pw.MultiPage(
        maxPages: 50,
        pageFormat: PdfPageFormat.a4,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        build: (context) {
          return [
            addProfileSection(curriculum),
            addAcademicFormation(doc: doc, curriculum: curriculum),
            ...addProfessionalExperiences(doc: doc, curriculum: curriculum),
            addCourses(doc: doc, curriculum: curriculum),
          ];
        },
      ),
    );
  }

  String get addressToBio {
    final curriculum = widget.curriculum;

    final address = curriculum.address;
    final String state;

    if (address.state == null) {
      state = '';
    } else {
      state = '${address.state}, ';
    }
    return '$state${address.cep ?? ''} ${curriculum.country}';
  }

  pw.Widget addProfileSection(Curriculum curriculum) {
    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Text(
          widget.curriculum.name,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(font: regular, fontSize: 30),
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
              calculateAge(
                CustomDateFormatter.brStringDateToDate(
                  widget.curriculum.nascimento,
                )!,
              ).toString(),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(font: regular, fontSize: 20),
            ),
            pw.SizedBox(width: 2),
            pw.Text(
              'anos',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(font: regular, fontSize: 16),
            ),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            if (curriculum.address.neighborhood != null)
              pw.Text(
                'Bairro ${curriculum.address.neighborhood!}',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: regular, fontSize: 16),
              ),
            if (curriculum.address.state != null)
              pw.Text(
                ' - ${curriculum.address.state!}',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: regular, fontSize: 16),
              ),
          ],
        ),
        pw.Text(
          'Tel: ${curriculum.phone}',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(font: regular, fontSize: 16),
        ),
        pw.Text(
          'Email: ${curriculum.email}',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(font: regular, fontSize: 16),
        ),
        if (curriculum.linkedin != null)
          pw.Text(
            'Linkedin: ${curriculum.linkedin}',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: regular, fontSize: 16),
          ),
        pw.SizedBox(height: 24),
        section(
          title: 'Objetivo',
          // icon: const pw.IconData(0xea23),
          icon: const pw.IconData(0xe0e0),
          child: pw.Text(
            curriculum.professionalObjectives,
            textAlign: pw.TextAlign.justify,
            style: pw.TextStyle(font: regular, fontSize: 14),
          ),
        ),
        pw.SizedBox(height: 12),
      ],
    );
  }

  pw.Widget section({
    required String title,
    required pw.Widget child,
    pw.IconData? icon,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Column(
              children: [
                pw.Row(
                  children: [
                    if (icon == null) pw.SizedBox.square(dimension: 20),
                    if (icon != null)
                      pw.DecoratedBox(
                        decoration: const pw.BoxDecoration(
                          color: PdfColor(0.2, .2, .2),
                        ),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Icon(
                            icon,
                            size: 16,
                            color: const PdfColor(1, 1, 1),
                            font: materialIconsFont,
                          ),
                        ),
                      ),
                    pw.SizedBox(width: 8),
                    pw.Text(
                      title.toUpperCase(),
                      style: sectionTitleStyle,
                    ),
                  ],
                ),
                pw.Divider(height: 0),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }

  pw.Widget iconWithText(
    pw.IconData iconData,
    String text,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.DecoratedBox(
            decoration: const pw.BoxDecoration(
              color: PdfColor(0.2, .2, .2),
            ),
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Icon(
                iconData,
                size: 16,
                color: const PdfColor(1, 1, 1),
                font: materialIconsFont,
              ),
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Text(
            text,
            style: bodyItalicStyle,
          ),
        ],
      ),
    );
  }

  List<pw.Widget> addProfessionalExperiences({
    required pw.Document doc,
    required Curriculum curriculum,
  }) {
    final experiences = curriculum.professionalExperience;

    if (experiences.isEmpty) return [];

    final list = <pw.Widget>[];

    list.add(
      section(
        title: 'Histórico Profissional',
        child: experience(experiences.first),
        icon: const pw.IconData(0xe8f9),
      ),
    );
    bool isFirst = true;
    for (final e in experiences) {
      if (isFirst) {
        isFirst = false;
        continue;
      }
      list.add(experience(e));
    }

    return list;
  }

  pw.Widget addCourses({
    required pw.Document doc,
    required Curriculum curriculum,
  }) {
    final courses = curriculum.courses;

    if (courses.isEmpty) return pw.SizedBox.shrink();

    return section(
      title: 'Cursos',
      child: pw.Column(children: courses.map(course).toList()),
      icon: const pw.IconData(0xe865),
    );
  }

  pw.Widget addAcademicFormation({
    required pw.Document doc,
    required Curriculum curriculum,
  }) {
    final formation = curriculum.academicFormation;

    if (formation.isEmpty) return pw.SizedBox.shrink();

    return section(
      title: 'Formação Acadêmica',
      child: pw.Column(children: formation.map(academicFormation).toList()),
      icon: const pw.IconData(0xe80c),
    );
  }

  pw.Widget experience(ProfessionalExperience e) {
    final titleTxtStyle = pw.TextStyle(
      font: regular,
      fontSize: subSectionTitleStyle.fontSize!,
      // fontItalic: italic,
    );

    final values = e.responsability.split('\n');

    bool isFirstParagraph = true;

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 8, bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Text(
                  e.company,
                  style: titleTxtStyle.copyWith(
                    fontWeight: pw.FontWeight.bold,
                    fontBold: bold,
                  ),
                  textAlign: pw.TextAlign.start,
                ),
              ),
              pw.Expanded(
                child: pw.RichText(
                  textAlign: pw.TextAlign.end,
                  text: pw.TextSpan(
                    text: CustomDateFormatter.dateToBarsMonthYear(e.startDate)!,
                    style: subSectionTitleStyle,
                    children: [
                      if (e.endDate != null)
                        pw.TextSpan(
                          text:
                              ' a ${CustomDateFormatter.dateToBarsMonthYear(e.endDate)!}',
                          style: subSectionTitleStyle,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          pw.RichText(
            text: pw.TextSpan(
              text: 'Cargo:  ',
              style: titleTxtStyle.copyWith(
                fontWeight: pw.FontWeight.bold,
                fontBold: bold,
              ),
              children: [
                pw.TextSpan(
                  text: e.position,
                  style: titleTxtStyle.copyWith(
                    fontWeight: pw.FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 8),
          ...values.map((e) {
            String text;

            if (isFirstParagraph) {
              text = 'Atividades: $e';
              isFirstParagraph = false;
            } else {
              text = e;
            }

            return pw.Paragraph(
              text: text,
              style: subSectionTitleStyle,
              margin: const pw.EdgeInsets.only(bottom: 4),
              padding: pw.EdgeInsets.zero,
              textAlign: pw.TextAlign.justify,
            );
          }),
        ],
      ),
    );
  }

  pw.Widget course(Course e) {
    final titleTxtStyle = pw.TextStyle(
      font: italic,
      fontSize: subSectionTitleStyle.fontSize!,
      fontItalic: italic,
    );
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 6,
                child: pw.Text(
                  e.name,
                  style: sectionTitleStyle.copyWith(
                    fontSize: sectionTitleStyle.fontSize! - 4,
                  ),
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(
                flex: 3,
                child: pw.Text(
                  CustomDateFormatter.monthYearBrExtensive(e.endDate)!,
                  textAlign: pw.TextAlign.end,
                  style: subSectionTitleStyle.copyWith(
                    fontSize: subSectionTitleStyle.fontSize! - 4,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            e.organization,
            textAlign: pw.TextAlign.start,
            style: titleTxtStyle.copyWith(
              fontSize: titleTxtStyle.fontSize! - 4,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget academicFormation(AcademicFormation af) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 5,
            child: pw.Text(
              af.courseName,
              style: subSectionTitleStyle,
              textAlign: pw.TextAlign.start,
            ),
          ),
          pw.SizedBox(width: 4),
          pw.Expanded(
            flex: 7,
            child: pw.Text(
              af.organization,
              textAlign: pw.TextAlign.start,
              style: subSectionTitleStyle,
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 8),
            child: pw.SizedBox(
              width: 94,
              child: pw.Text(
                af.endDate == null ? '' : 'Conclusão: ${af.endDate!.year}',
                textAlign: pw.TextAlign.center,
                style: subSectionTitleStyle,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        useActions: true,
        actions: [
          ElevatedButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Voltar'),
          ),
        ],
        canDebug: false,
        loadingWidget: const Center(
          child: CircularProgressIndicator(),
        ),
        build: (_) {
          return _generatePdf(widget.curriculum);
        },
      ),
    );
  }
}

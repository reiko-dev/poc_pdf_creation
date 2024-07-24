import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:poc_pdf_creation/core/date_time.dart';
import 'package:poc_pdf_creation/curriculum/index.dart';
import 'package:poc_pdf_creation/models/address.dart';
import 'package:printing/printing.dart';

class CurriculumPDFPage extends StatefulWidget {
  const CurriculumPDFPage({super.key});

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
  late Curriculum curriculum;

  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    curriculum = Curriculum(
      uid: 'uid',
      userUID: 'userUID',
      name: 'José Wanderson da Silva',
      cpf: '921.919.812-01',
      nascimento: '27/02/1994',
      civilState: CivilState.divorciado,
      sex: Sex.ratherNotSay,
      country: 'Brazil',
      qtdFilhos: 0,
      cnh: Cnh.ab,
      veiculoProprio: true,
      disponibilidadeParaViagem: true,
      disponibilidadeParaMudanca: true,
      phone: '+55 (68) 99933-9999',
      email: 'meuemail@email.com',
      address: const Address(
        cep: '69921-000',
        address: 'address',
        addressNumber: 123,
        neighborhood: 'Neighborhood',
        city: 'Campo Grande',
        state: 'Mato Grosso do Sul',
      ),
      desiredPosition: 'Senior FullStack Developer',
      professionalObjectives:
          'I want this, that, those, etc asldkja sldkja skldjalk sjdlka jslka professionalObjectives',
      academicFormation: <AcademicFormation>[
        AcademicFormation(
          courseName: 'Analista de Sistemas de Informação',
          organization: 'Universidade Federal do Acre - UFAC',
          situation: AcademicSituation.finished,
          formation: Formation.graduation,
          endDate: DateTime(2017, 02),
        ),
      ],
      professionalExperience: <ProfessionalExperience>[
        ProfessionalExperience(
          company: 'Vizo',
          context: 'Worked as Freelancer',
          isAtual: false,
          position: 'Flutter Developer',
          responsability:
              """• Led user interface iterations based on user feedback to ensure user-friendly experience.

• Spearheaded development of core functionalities essential for mobile applications, including user authentication, notification system, and location- based features.

• Implemented robust CI/CD pipeline for automated testing and streamlined deployment across environments.

• Leveraging skills, also developed mobile app functionalities for US-based client (location-based event-sharing app) during my time at Shaw and Partners. 

• Continuously updated skills through training courses, workshops, and self-study, staying current on industry trends and emerging technologies.""",
          startDate: DateTime(2022, 07),
          lastSalary: 4200,
        ),
        ProfessionalExperience(
          company: 'Google Inc.',
          context:
              'I\'m currently working on IAs products, developing new features and fixing bugs',
          position: 'Senior FullStack Python Developer',
          responsability:
              """• Developed cross-platform mobile application prototype (MVP) using Flutter and implemented Bloc for state management.

• Utilized Get_it to inject dependencies and used Mockito and Flutter_test, for Unit, Widget and integration tests.

• Led user interface iterations based on user feedback to ensure user-friendly experience.

• Spearheaded development of core functionalities essential for mobile applications, including user authentication, notification system, and location- based features.

• Implemented robust CI/CD pipeline for automated testing and streamlined deployment across environments.

• Leveraging skills, also developed mobile app functionalities for US-based client (location-based event-sharing app) during my time at Shaw and Partners.

• Continuously updated skills through training courses, workshops, and self-study, staying current on industry trends and emerging technologies.

• Reduced development time by creating reusable code libraries for future projects.""",
          startDate: now,
          isAtual: true,
        ),
      ],
      courses: <Course>[
        Course(
          name:
              'AMAZON CERTIFIED DEVOPS DEVELOPER (ECS, EEKS, ESE, RDB, LAMBDA)',
          organization: 'AMAZON AWS',
          endDate: DateTime(2023, 02),
        ),
        Course(
          name: 'Guia definitivo do DEVOPS (2024)',
          organization: 'UDEMY - by COD3R',
          endDate: now,
        ),
      ],
    );
  }

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
      font: bold,
      fontSize: 16,
    );

    subSectionTitleStyle = pw.TextStyle(
      font: regular,
      fontSize: 14,
    );

    bodyItalicStyle = pw.TextStyle(
      font: italic,
      fontSize: 14,
    );

    isLoaded = true;
  }

  Future<Uint8List> _generatePdf(Curriculum curriculum) async {
    await _loadData();
    final doc = pw.Document();

    addData(doc, curriculum);

    return doc.save();
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
            ...addProfessionalExperiences(doc: doc, curriculum: curriculum),
            addCourses(doc: doc, curriculum: curriculum),
            addAcademicFormation(doc: doc, curriculum: curriculum),
          ];
        },
      ),
    );
  }

  String get addressToBio {
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
          curriculum.name,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(font: regular, fontSize: 30),
        ),
        pw.Text(
          curriculum.desiredPosition,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(font: regular, fontSize: 16),
        ),
        pw.Divider(height: 32),
        pw.Column(
          children: [
            iconWithText(
              const pw.IconData(0xe0c8),
              addressToBio,
            ),
            iconWithText(
              const pw.IconData(0xe0b0),
              curriculum.phone,
            ),
            iconWithText(
              const pw.IconData(0xe158),
              curriculum.email,
            ),
          ],
        ),
        pw.SizedBox(height: 12),
      ],
    );
  }

  pw.Widget section({
    required String title,
    required pw.Widget child,
    required pw.IconData icon,
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
                      title,
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
        icon: const pw.IconData(0xe80c));
  }

  pw.Widget experience(ProfessionalExperience e) {
    final titleTxtStyle = pw.TextStyle(
      font: italic,
      fontSize: subSectionTitleStyle.fontSize!,
      fontItalic: italic,
    );

    final values = e.responsability.split('\n');

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 8, bottom: 16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Text(
                  e.position,
                  style: titleTxtStyle.copyWith(
                    fontWeight: pw.FontWeight.bold,
                    fontBold: bold,
                  ),
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  CustomDateFormatter.monthYearBrExtensive(e.startDate)!,
                  textAlign: pw.TextAlign.end,
                  style: titleTxtStyle.copyWith(
                    fontWeight: pw.FontWeight.bold,
                    fontBold: bold,
                  ),
                ),
              ),
            ],
          ),
          pw.Text(
            e.company,
            style: titleTxtStyle,
            textAlign: pw.TextAlign.start,
          ),
          pw.SizedBox(height: 8),
          ...values.map(
            (e) => pw.Paragraph(
              text: e,
              style: subSectionTitleStyle,
              margin: const pw.EdgeInsets.only(bottom: 4),
              padding: pw.EdgeInsets.zero,
              textAlign: pw.TextAlign.justify,
            ),
          ),
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
      padding: const pw.EdgeInsets.only(bottom: 12),
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
    final titleTxtStyle = pw.TextStyle(
      font: italic,
      fontSize: subSectionTitleStyle.fontSize!,
      fontItalic: italic,
    );
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 6,
                child: pw.Text(
                  af.courseName,
                  style: sectionTitleStyle.copyWith(
                    fontSize: sectionTitleStyle.fontSize! - 4,
                  ),
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(
                flex: 3,
                child: pw.Text(
                  CustomDateFormatter.monthYearBrExtensive(af.endDate)!,
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
            af.organization,
            textAlign: pw.TextAlign.start,
            style: titleTxtStyle.copyWith(
              fontSize: titleTxtStyle.fontSize! - 4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        loadingWidget: const Center(
          child: CircularProgressIndicator(),
        ),
        build: (_) {
          return _generatePdf(curriculum);
        },
      ),
    );
  }
}

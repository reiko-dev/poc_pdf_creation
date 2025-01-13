import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:poc_pdf_creation/core/date_time.dart';
import 'package:poc_pdf_creation/curriculum/index.dart';
import 'package:poc_pdf_creation/job_apply/job_apply_report.dart';
import 'package:poc_pdf_creation/job_apply/user_job_application.dart';
import 'package:poc_pdf_creation/models/index.dart';
import 'package:printing/printing.dart';

class JobApplyPDFPage extends StatefulWidget {
  const JobApplyPDFPage({
    super.key,
    required this.apply,
    required this.curriculum,
    required this.analystName,
  });

  final UserJobApplication apply;
  final Curriculum curriculum;
  final String analystName;

  @override
  State<JobApplyPDFPage> createState() => _JobApplyPDFPageState();
}

class _JobApplyPDFPageState extends State<JobApplyPDFPage> {
  late final pw.TtfFont regular;
  late final pw.TtfFont bold;
  late final pw.TtfFont italic;
  late final pw.TtfFont materialIconsFont;

  late final pw.TextStyle sectionTitleStyle;
  late final pw.TextStyle subSectionTitleStyle;
  late final pw.TextStyle bodyItalicStyle;
  late final pw.TextStyle bodyStyle;
  late final pw.TextStyle bodyBoldtyle;
  late final Uint8List _imageBytes;

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
      rootBundle.load('assets/images/crielogo.png').then((r) {
        _imageBytes = r.buffer.asUint8List();
      })
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

    bodyBoldtyle = pw.TextStyle(
      font: bold,
      fontSize: 12,
    );
    bodyStyle = pw.TextStyle(
      font: regular,
      fontSize: 12,
    );

    isLoaded = true;
  }

  Future<Uint8List> _generatePdf(UserJobApplication jobApplyReport) async {
    await _loadData();
    final doc = pw.Document();

    addData(doc, jobApplyReport, widget.curriculum, widget.analystName);

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

  void addData(
    pw.Document doc,
    UserJobApplication apply,
    Curriculum cu,
    String analystName,
  ) {
    doc.addPage(
      pw.MultiPage(
        maxPages: 50,
        pageFormat: PdfPageFormat.a4,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        build: (context) {
          final reportStatus = apply.apply.report?.status;
          return [
            firstSection(report: apply),
            personalDataSection(report: apply, cu: cu),
            pw.SizedBox(height: 12),
            pw.Text(
              'Descrição: ${apply.apply.report!.description}',
              style: bodyItalicStyle,
            ),
            pw.SizedBox(height: 16),
            switch (apply.apply.report?.status) {
              null || SuitableStatus.pending => pw.SizedBox.shrink(),
              SuitableStatus.suitable ||
              SuitableStatus.notSuitable =>
                pw.DecoratedBox(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black,
                      width: 1,
                    ),
                  ),
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Column(children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            'PARECER:',
                            style: bodyBoldtyle.copyWith(
                              decoration: pw.TextDecoration.underline,
                              decorationColor: PdfColors.black,
                              color: PdfColors.black,
                              // fontSize: 16,
                            ),
                          ),
                          pw.Text(' ${apply.apply.report!.status.label}'),
                        ],
                      ),
                      pw.SizedBox(height: 12),
                      pw.RichText(
                        text: pw.TextSpan(
                          text: widget.curriculum.name,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          children: [
                            pw.TextSpan(
                              text: reportStatus == SuitableStatus.suitable
                                  ? ' está indicado(a) a ocupar a vaga de '
                                  : ' não está indicado(a) a ocupar a vaga de ',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                              ),
                            ),
                            pw.TextSpan(
                              text: widget.apply.job.jobName,
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.TextSpan(
                              text: ' na empresa',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                              ),
                            ),
                            pw.TextSpan(
                              text: ' ${widget.apply.job.company.name}',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.TextSpan(
                              text: reportStatus == SuitableStatus.suitable
                                  ? ', pois apresenta características profissionais e pessoais aderentes às atividades a serem realizadas.'
                                  : ', pois não apresenta características profissionais e pessoais aderentes às atividades a serem realizadas.',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
            },
            pw.SizedBox(height: 24),
            pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Text(
                analystName,
                textAlign: pw.TextAlign.center,
                style: bodyItalicStyle.copyWith(
                  fontSize: 16,
                ),
              ),
            )
          ];
        },
      ),
    );
  }

  pw.Widget firstSection({required UserJobApplication report}) {
    final space = pw.SizedBox(height: 6);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          height: 40,
          child: pw.Image(pw.MemoryImage(_imageBytes)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 8),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Text(
                'Parecer da entrevista'.toUpperCase(),
                textAlign: pw.TextAlign.center,
                style: bodyBoldtyle.copyWith(
                  fontSize: 16,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.DecoratedBox(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  child: pw.Column(
                    children: [
                      getTableRow(
                        [
                          CustomTableRow(
                            flexValue: 3,
                            title: 'Empresa:',
                            value: report.job.company.name!,
                          ),
                          CustomTableRow(
                            flexValue: 2,
                            title: 'Data:',
                            value: CustomDateFormatter.dateToBrExtensive(
                                report.apply.createdAt)!,
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      getTableRow([
                        CustomTableRow(
                          flexValue: 1,
                          title: 'Cargo:',
                          value: report.job.jobName,
                        ),
                        CustomTableRow(
                          flexValue: 1,
                          title: 'Pretensão Salarial:',
                          value: report.apply.report!.lastSalary
                                  ?.toStringAsFixed(2) ??
                              'Não informado',
                        ),
                      ]),
                      pw.SizedBox(height: 8),
                      getTableRow(
                        [
                          CustomTableRow(
                            flexValue: 3,
                            title: 'Último salário:',
                            value: report.apply.report!.lastSalary
                                    ?.toStringAsFixed(2) ??
                                'Não informado',
                          ),
                        ],
                        upperCase: true,
                      ),
                      space,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget personalDataSection({
    required UserJobApplication report,
    required Curriculum cu,
  }) {
    const padding = pw.EdgeInsets.only(
      top: 6,
      bottom: 6,
      left: 4,
      right: 4,
    );
    final space = pw.SizedBox(height: 6);

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          space,
          pw.DecoratedBox(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
            ),
            child: pw.Column(
              children: [
                getTableRow(
                  [
                    CustomTableRow(
                      flexValue: 1,
                      title: 'Nome:',
                      value: cu.name,
                    ),
                  ],
                  padding: padding,
                  title: 'Dados pessoais',
                ),
                getTableRow([
                  CustomTableRow(
                    flexValue: 1,
                    title: 'Sexo:',
                    value: cu.sex.label,
                  ),
                  CustomTableRow(
                    flexValue: 1,
                    title: 'Idade:',
                    value: cu.ages?.toString() ?? 'Não informado',
                  ),
                ]),
                getTableRow(
                  [
                    CustomTableRow(
                      flexValue: 1,
                      title: 'CPF:',
                      value: cu.cpf,
                    ),
                    CustomTableRow(
                      flexValue: 1,
                      title: 'E-mail:',
                      value: cu.email,
                    ),
                  ],
                  padding: padding,
                ),
                space,
              ],
            ),
          ),
          pw.SizedBox(height: 12),
        ],
      ),
    );
  }

  pw.Widget getTableRow(
    List<CustomTableRow> data, {
    bool upperCase = true,
    pw.EdgeInsets padding = pw.EdgeInsets.zero,
    String? title,
  }) {
    final list = <pw.Widget>[];

    for (var e in data) {
      list.add(
        pw.Flexible(
          fit: pw.FlexFit.loose,
          flex: e.flexValue,
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 4),
                child: getText(text: e.title, upperCase: upperCase),
              ),
              pw.Flexible(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.only(right: 4, left: 4),
                  child:
                      getText(text: e.value, upperCase: upperCase, bold: true),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return pw.Column(
      children: [
        if (title != null)
          pw.Padding(
            padding: padding,
            child: getText(
              text: title,
              bold: true,
              style: const pw.TextStyle(fontSize: 14),
            ),
          ),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: list,
        ),
      ],
    );
  }

  pw.Text getText({
    required String text,
    bool upperCase = true,
    bool bold = false,
    pw.TextStyle? style,
  }) {
    text = text.trim();
    return pw.Text(
      upperCase ? text.toUpperCase() : text,
      textAlign: pw.TextAlign.start,
      style: (bold ? bodyBoldtyle : bodyStyle).merge(style),
    );
  }

  pw.Widget iconWithText(
    IconData icon,
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
                pw.IconData(icon.codePoint),
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

  String addressDescription(Address address) {
    String value = '';
    if (address.address != null) value += address.address!;

    if (value.isNotEmpty) {
      value += ', ';
    }
    value += address.addressNumber?.toString() ?? "";
    value += '\n${address.city?.toString() ?? ""}';
    value += ' - ${address.neighborhood?.toString() ?? ""}';
    value += '\nCEP: ${address.cep?.toString() ?? ""}';

    return value;
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
          return _generatePdf(widget.apply);
        },
      ),
    );
  }
}

class CustomTableRow {
  final String title;
  final String value;
  final int flexValue;

  CustomTableRow({
    required this.title,
    required this.value,
    required this.flexValue,
  });
}

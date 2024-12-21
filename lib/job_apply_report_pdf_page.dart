import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:poc_pdf_creation/core/date_time.dart';
import 'package:poc_pdf_creation/job_apply/user_job_application.dart';
import 'package:printing/printing.dart';

class JobApplyPDFPage extends StatefulWidget {
  const JobApplyPDFPage({super.key, required this.report});

  final UserJobApplication report;

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

    addData(doc, jobApplyReport);

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

  void addData(pw.Document doc, UserJobApplication report) {
    doc.addPage(
      pw.MultiPage(
        maxPages: 50,
        pageFormat: PdfPageFormat.a4,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        build: (context) {
          return [
            section(report: report),
          ];
        },
      ),
    );
  }

  pw.Widget section({required UserJobApplication report}) {
    return pw.Padding(
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
          pw.Table(
            columnWidths: {
              0: const pw.FractionColumnWidth(.5),
              1: const pw.FractionColumnWidth(.5),
              2: const pw.FractionColumnWidth(.5),
              3: const pw.FractionColumnWidth(.5),
            },
            children: [
              getTableRow([
                ('Empresa:', report.job.company.name!),
                (
                  'Data:',
                  CustomDateFormatter.dateToBrExtensive(report.apply.createdAt)!
                ),
              ]),
              pw.TableRow(children: [pw.SizedBox(height: 12)]),
              getTableRow([
                ('Cargo:', report.job.jobName),
                (
                  'Pretensão Salarial:',
                  report.apply.report!.lastSalary?.toStringAsFixed(2) ??
                      'Não informado'
                ),
              ]),
              pw.TableRow(children: [pw.SizedBox(height: 12)]),
              getTableRow(
                [
                  (
                    'Último salário:',
                    report.apply.report!.lastSalary?.toStringAsFixed(2) ??
                        'Não informado',
                  ),
                ],
                true,
              )
            ],
          ),
          pw.SizedBox(height: 12),
        ],
      ),
    );
  }

  pw.TableRow getTableRow(
    List<(String, String)> children, [
    bool upperCase = true,
  ]) {
    final list = <pw.Widget>[];

    for (var e in children) {
      list.add(getText(e.$1, upperCase, true));
      list.add(getText(e.$2, upperCase));
    }

    return pw.TableRow(
      children: list,
      verticalAlignment: pw.TableCellVerticalAlignment.middle,
    );
  }

  pw.Text getText(String text, [bool upperCase = true, bold = false]) {
    text = text.trim();
    return pw.Text(
      upperCase ? text.toUpperCase() : text,
      textAlign: pw.TextAlign.start,
      style: bold ? bodyBoldtyle : bodyItalicStyle,
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
          return _generatePdf(widget.report);
        },
      ),
    );
  }
}

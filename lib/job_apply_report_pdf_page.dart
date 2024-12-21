import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:poc_pdf_creation/job_apply_report/job_apply_report.dart';
import 'package:printing/printing.dart';

class JobApplyPDFPage extends StatefulWidget {
  const JobApplyPDFPage({super.key, required this.report});

  final JobApplyReport report;

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

  Future<Uint8List> _generatePdf(JobApplyReport jobApplyReport) async {
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

  void addData(pw.Document doc, JobApplyReport jobApplyReport) {
    doc.addPage(
      pw.MultiPage(
        maxPages: 50,
        pageFormat: PdfPageFormat.a4,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        build: (context) {
          return [
            section(
              title: 'title',
              child: iconWithText(Icons.car_crash, 'Text'),
            ),
          ];
        },
      ),
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

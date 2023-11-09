import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../utils/colors.dart';

class PdfPrint extends StatefulWidget {
  final Uint8List file;
  const PdfPrint({super.key, required this.file});

  @override
  State<PdfPrint> createState() => _PdfPrintState();
}

class _PdfPrintState extends State<PdfPrint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printable & Shareable'),
        backgroundColor: AppColors.primaryColor1,
      ),
      body: Container(
          child: PdfPreview(
        maxPageWidth: 550,
        build: (format) => widget.file,
      )),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_translator/controllers/pdf_ctr.dart';
import 'package:simplytranslate/simplytranslate.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:translator/translator.dart';

class PDFViewer extends StatelessWidget {
  const PDFViewer({super.key, required this.pdfValue});
  final PDFctr pdfValue;

  @override
  Widget build(BuildContext context) {
    var file = File(pdfValue.filesList[pdfValue.currentFileIndex].path);
    return Expanded(
      child: SfPdfViewer.file(
        file,
        controller: pdfValue.pdfViewerController,
        pageLayoutMode: pdfValue.isSingle
            ? PdfPageLayoutMode.single
            : PdfPageLayoutMode.continuous,
        onDocumentLoaded: (details) async {
          await pdfValue.updatePageCount(details.document.pages.count);
        },
        onPageChanged: (details) async {
          await pdfValue.updateCurrentPage(details.newPageNumber);
        },
        onTextSelectionChanged: (details) async {
          if (details.selectedText != null) {
            try {
              await pdfValue.updateOrginalText(
                  details.selectedText!.replaceAll(RegExp(r'\n'), ' ').trim());
              final translator = GoogleTranslator();
              var t = await translator.translate(pdfValue.orginalText!,
                  from: 'en', to: 'ar');
              await pdfValue
                  .updateText(t.text.replaceAll(RegExp(r'\n'), ' ').trim());
              final gt = SimplyTranslator(EngineType.google);
              String textResult =
                  await gt.trSimply(pdfValue.orginalText!, "en", 'ar');
              await pdfValue.updateOtherText(
                  textResult.replaceAll(RegExp(r'\n'), ' ').trim());
            } catch (_) {}
          }
        },
      ),
    );
  }
}

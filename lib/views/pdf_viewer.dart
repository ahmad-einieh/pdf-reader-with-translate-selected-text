import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_translator/controllers/pdf_ctr.dart';
import 'package:simplytranslate/simplytranslate.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:translator/translator.dart';

class PDFViewer extends StatelessWidget {
  PDFViewer({super.key, required this.file, required this.pdfValue});
  File file;
  PDFctr pdfValue;

  @override
  Widget build(BuildContext context) => Expanded(
        child: SfPdfViewer.file(
          file,
          pageLayoutMode: pdfValue.isSingle
              ? PdfPageLayoutMode.single
              : PdfPageLayoutMode.continuous,
          onDocumentLoaded: (details) {
            pdfValue.updatePageCount(details.document.pages.count);
          },
          onPageChanged: (details) {
            pdfValue.updateCurrentPage(details.newPageNumber);
          },
          onTextSelectionChanged: (details) async {
            if (details.selectedText != null) {
              try {
                pdfValue.updateOrginalText(details.selectedText!
                    .replaceAll(RegExp(r'\n'), ' ')
                    .trim());

                final translator = GoogleTranslator();
                var t = await translator.translate(pdfValue.orginalText!,
                    from: 'en', to: 'ar');

                pdfValue
                    .updateText(t.text.replaceAll(RegExp(r'\n'), ' ').trim());

                final gt = SimplyTranslator(EngineType.google);
                String textResult =
                    await gt.trSimply(pdfValue.orginalText!, "en", 'ar');
                pdfValue.updateOtherText(
                    textResult.replaceAll(RegExp(r'\n'), ' ').trim());
              } catch (_) {}
            }
          },
        ),
      );
}

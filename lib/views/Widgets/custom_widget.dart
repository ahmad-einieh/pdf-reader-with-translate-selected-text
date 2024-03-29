import 'package:flutter/material.dart';
import 'package:simplytranslate/simplytranslate.dart';
import 'package:translator/translator.dart';

import '../../controllers/pdf_ctr.dart';
import '../../helper/tts_method.dart';

class CustomWidget extends StatelessWidget {
  const CustomWidget({
    super.key,
    required this.pdfValue,
  });

  final PDFctr pdfValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.005),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextField(
              onSubmitted: (value) async {
                if (value.isNotEmpty) {
                  final translator = GoogleTranslator();
                  var t =
                      await translator.translate(value, from: 'en', to: 'ar');
                  pdfValue.updateOrginalText(value);
                  pdfValue
                      .updateText(t.text.replaceAll(RegExp(r'\n'), ' ').trim());
                  final gt = SimplyTranslator(EngineType.google);
                  String textResult = await gt.trSimply(value, "en", 'ar');
                  pdfValue.updateOtherText(
                      textResult.replaceAll(RegExp(r'\n'), ' ').trim());
                }
              },
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
          Expanded(
            child: SelectableText(
              pdfValue.orginalText == null ? "" : pdfValue.orginalText!.trim(),
            ),
          ),
          IconButton(
              onPressed: () async {
                try {
                  await readText(pdfValue.orginalText);
                } catch (_) {}
              },
              icon: const Icon(Icons.volume_up)),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:simplytranslate/simplytranslate.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  String? _text;
  String? _anothertext;
  String? _orginaltext;
  int? pageCount;
  int? currentPage;
  bool isShow = true;
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  !isShow
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              isShow = true;
                              file = null;
                            });
                          },
                          icon: const Icon(Icons.close))
                      : const SizedBox(),
                  Text(
                    _text == null ? "" : _text!.trim(),
                    style: const TextStyle(fontSize: 20),
                    locale: const Locale('ar'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _orginaltext == null ? "" : _orginaltext!.trim(),
                    style: const TextStyle(fontSize: 20),
                    locale: const Locale('en'),
                  ),
                  IconButton(
                      onPressed: () async {
                        final SimplyTranslator gt =
                            SimplyTranslator(EngineType.google);
                        String x = gt.getTTSUrlSimply(_orginaltext!, "en");
                        final player = AudioPlayer();
                        await player.play(UrlSource(x));
                      },
                      icon: const Icon(Icons.speaker_sharp)),
                ],
              ),
            ),
            Text(
              _anothertext == null ? "" : _anothertext!.trim(),
              style: const TextStyle(fontSize: 20),
              locale: const Locale('ar'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) async {
                        if (value.isNotEmpty) {
                          final translator = GoogleTranslator();
                          var t = await translator.translate(value,
                              from: 'en', to: 'ar');
                          setState(() {
                            _text = t.text;
                            _text = _text!.replaceAll(RegExp(r'\n+'), '');
                          });
                        }
                      },
                    ),
                  ),
                  currentPage == null || pageCount == null
                      ? const SizedBox()
                      : SizedBox(
                          width: 66,
                          child: Text("$currentPage of $pageCount"),
                        ),
                ],
              ),
            ),
            isShow
                ? ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();
                      if (result != null) {
                        setState(() {
                          file = File(result.files.single.path!);
                          isShow = false;
                        });
                      }
                    },
                    child: const Text("select file"))
                : Container(),
            !isShow
                ? Expanded(
                    child: SfPdfViewer.file(
                      file!,
                      pageLayoutMode: PdfPageLayoutMode.single,
                      onDocumentLoaded: (details) {
                        try {
                          setState(() {
                            pageCount = details.document.pages.count;
                            currentPage = 1;
                          });
                        } catch (_) {}
                      },
                      onPageChanged: (details) {
                        try {
                          setState(() {
                            currentPage = details.newPageNumber;
                          });
                        } catch (_) {}
                      },
                      onTextSelectionChanged: (details) async {
                        if (details.selectedText != null) {
                          try {
                            setState(() {
                              _orginaltext = details.selectedText!
                                  .replaceAll(RegExp(r'\n'), ' ')
                                  .trim();
                              print(_orginaltext);
                            });
                            final translator = GoogleTranslator();
                            var t = await translator.translate(_orginaltext!,
                                from: 'en', to: 'ar');
                            setState(() {
                              _text = t.text;
                              _text =
                                  _text!.replaceAll(RegExp(r'\n'), ' ').trim();
                            });
                            final gt = SimplyTranslator(EngineType.google);
                            String textResult =
                                await gt.trSimply(_orginaltext!, "en", 'ar');
                            setState(() {
                              _anothertext = textResult
                                  .replaceAll(RegExp(r'\n'), ' ')
                                  .trim();
                            });
                          } catch (_) {}
                        }
                      },
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

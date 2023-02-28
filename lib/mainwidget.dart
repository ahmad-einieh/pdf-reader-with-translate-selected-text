import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simplytranslate/simplytranslate.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:translator/translator.dart';

import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';

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
  bool isSingle = true;
  String? fileName;

  readText(text) async {
    final encodedParams = {
      "src": "$text",
      "hl": "en-us",
      "r": "0",
      "c": "mp3",
      "f": "16khz_16bit_stereo"
    };
    final uri = Uri.parse(
        'https://voicerss-text-to-speech.p.rapidapi.com/?key=63cb6bc6ae5148339cf6858442f5bed5');
    final headers = {
      'content-type': 'application/x-www-form-urlencoded',
      'X-RapidAPI-Key': 'e115eb8e19msh1807594767d84d6p199db8jsn7fd5aa515e87',
      'X-RapidAPI-Host': 'voicerss-text-to-speech.p.rapidapi.com'
    };
    final request = http.Request('POST', uri)..headers.addAll(headers);
    request.bodyFields = encodedParams;
    final http.StreamedResponse response = await http.Client().send(request);
    final http.Response responseData = await http.Response.fromStream(response);
    final result = responseData.bodyBytes;
    File inFile = File('test.mp3');
    var x = await inFile.writeAsBytes(result);
    final player = AudioPlayer();
    await player.play(DeviceFileSource(x.path));
    inFile.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      onSubmitted: (value) async {
                        if (value.isNotEmpty) {
                          final translator = GoogleTranslator();
                          var t = await translator.translate(value,
                              from: 'en', to: 'ar');
                          setState(() {
                            _orginaltext = value;
                            _text =
                                t.text.replaceAll(RegExp(r'\n'), ' ').trim();
                          });
                          final gt = SimplyTranslator(EngineType.google);
                          String textResult =
                              await gt.trSimply(value, "en", 'ar');
                          setState(() {
                            _anothertext = textResult
                                .replaceAll(RegExp(r'\n'), ' ')
                                .trim();
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SelectableText(
                      _orginaltext == null ? "" : _orginaltext!.trim(),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        try {
                          await readText(_orginaltext);
                        } catch (_) {}
                        // try {
                        //   final SimplyTranslator gt =
                        //       SimplyTranslator(EngineType.google);
                        //   String speechFile =
                        //       gt.getTTSUrlSimply(_orginaltext!, "en");
                        //   final player = AudioPlayer();
                        //   await player.play(UrlSource(speechFile));
                        // } catch (_) {}
                      },
                      icon: const Icon(Icons.volume_up)),
                ],
              ),
            ),
            SelectableText(
              _text == null ? "" : _text!.trim(),
              style: const TextStyle(fontSize: 32),
            ),
            SelectableText(
              _anothertext == null ? "" : _anothertext!.trim(),
              style: const TextStyle(fontSize: 32),
            ),
            isShow
                ? ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();
                      if (result != null) {
                        setState(() {
                          file = File(result.files.single.path!);
                          fileName = result.files.single.name;
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
                      pageLayoutMode: isSingle
                          ? PdfPageLayoutMode.single
                          : PdfPageLayoutMode.continuous,
                      onDocumentLoaded: (details) {
                        setState(() {
                          pageCount = details.document.pages.count;
                          currentPage = 1;
                        });
                      },
                      onPageChanged: (details) {
                        setState(() {
                          currentPage = details.newPageNumber;
                        });
                      },
                      onTextSelectionChanged: (details) async {
                        if (details.selectedText != null) {
                          try {
                            setState(() {
                              _orginaltext = details.selectedText!
                                  .replaceAll(RegExp(r'\n'), ' ')
                                  .trim();
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  !isShow
                      ? IconButton(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          tooltip: "close $fileName",
                          onPressed: () {
                            setState(() {
                              isShow = true;
                              file = null;
                              fileName = null;
                              _text = null;
                              _orginaltext = null;
                              _anothertext = null;
                              pageCount = null;
                              currentPage = null;
                              isSingle = true;
                            });
                          },
                          icon: const Icon(Icons.close))
                      : const SizedBox(),
                  currentPage == null || pageCount == null
                      ? const SizedBox()
                      : Text(
                          "$currentPage of $pageCount",
                          style: const TextStyle(fontSize: 24),
                        ),
                  fileName == null
                      ? const SizedBox()
                      : Text(
                          fileName!,
                          style: const TextStyle(fontSize: 16),
                        ),
                  IconButton(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      onPressed: () {
                        setState(() {
                          isSingle = !isSingle;
                        });
                      },
                      icon: const Icon(Icons.change_circle))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
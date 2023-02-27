import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:simplytranslate/simplytranslate.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:translator/translator.dart';

import 'dart:io';

import 'package:http/http.dart' as http;

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

  readText(text) async {
    final encodedParams = {
      "src": "$text",
      "hl": "en-us",
      "r": "2",
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

    print(x.absolute.path);
    print(x.path);
    final player = AudioPlayer();
    // await player.setSourceUrl(speechFile);
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
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _orginaltext == null ? "" : _orginaltext!.trim(),
                      style: const TextStyle(fontSize: 20),
                      locale: const Locale('en'),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await readText(_orginaltext);

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
                            _text =
                                t.text.replaceAll(RegExp(r'\n'), ' ').trim();
                          });
                          final gt = SimplyTranslator(EngineType.google);
                          String textResult =
                              await gt.trSimply(value, "en", 'ar');
                          setState(() {
                            _orginaltext = value;
                            _anothertext = textResult
                                .replaceAll(RegExp(r'\n'), ' ')
                                .trim();
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
          ],
        ),
      ),
    );
  }
}

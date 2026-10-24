import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

readText(text) async {
  final encodedParams = {
    "src": "$text",
    "hl": "en-us",
    "r": "0",
    "c": "mp3",
    "f": "16khz_16bit_stereo"
  };
  final uri = Uri.parse(
      'https://voicerss-text-to-speech.p.rapidapi.com/?key=CONFIGURE_GENERIC_API_KEY');
  final headers = {
    'content-type': 'application/x-www-form-urlencoded',
    'X-RapidAPI-Key': 'CONFIGURE_RAPIDAPI_ACCESS_TOKEN',
    'X-RapidAPI-Host': 'voicerss-text-to-speech.p.rapidapi.com'
  };
  final request = http.Request('POST', uri)..headers.addAll(headers);
  request.bodyFields = encodedParams;
  final http.StreamedResponse response = await http.Client().send(request);
  if (response.statusCode == 200) {
    final http.Response responseData = await http.Response.fromStream(response);
    if (responseData.statusCode == 200) {
      File inFile = File('audio.mp3');
      var x = await inFile.writeAsBytes(responseData.bodyBytes);
      final player = AudioPlayer();
      await player.play(DeviceFileSource(x.path));
      inFile.delete();
    } else {
      debugPrint("${responseData.headers}");
    }
  } else {
    debugPrint("${response.headers}");
  }
}

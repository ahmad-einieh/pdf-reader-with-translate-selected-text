# PDF Reader with Selected-Text Translation

Speech-provider/RapidAPI credentials in `lib/helper/tts_method.dart` were replaced with `CONFIGURE_...` placeholders. Configure authorized development access privately before speech requests; move privileged credentials behind a backend for distribution. Rotate exposed historical keys and review third-party text disclosure. No live speech requests were tested.

A Flutter desktop-oriented PDF reader with file picking/drag-and-drop, multiple-file navigation, page/search state, selected-text translation, and speech-related helpers.

## Local setup

Use legacy Flutter/Dart `>=2.19.0 <3.0.0` and a supported desktop toolchain. Run `flutter pub get`, list targets with `flutter devices`, then `flutter run -d <device-id>`. Native file/audio/viewer dependencies can limit platform support; review the Syncfusion viewer's applicable license requirements.

`lib/views/mainwidget.dart` handles opening files, `lib/views/pdf_viewer.dart` renders the document, and `lib/controllers/pdf_ctr.dart` manages file/page/search state. Translation and speech helpers depend on additional services/plugins.

**Selected text may be sent to external translation/speech services.** Do not use confidential documents without reviewing those flows and provider policies. Scanned/image-only PDFs may not offer selectable text. Builds, PDFs, translation services, and audio behavior were not tested for this documentation refresh.

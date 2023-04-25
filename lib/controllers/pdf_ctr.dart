import 'package:cross_file/cross_file.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFctr extends GetxController {
  int? pageCount;
  int? currentPage;

  String? orginalText;
  String? text;
  String? otherText;

  List<XFile> filesList = [];

  bool isShow = true;
  bool isSingle = true;

  int currentFileIndex = 0;

  bool dragging = false;

  late final PdfViewerController pdfViewerController;
  late final PdfTextSearchResult searchResult;

  @override
  void onInit() {
    super.onInit();
    pdfViewerController = PdfViewerController();
    searchResult = PdfTextSearchResult();
  }

  updateDragging(bool dragging) {
    this.dragging = dragging;
    update();
  }

  updateIsShow() {
    isShow = !isShow;
    update();
  }

  updateIsSingle() {
    isSingle = !isSingle;
    update();
  }

  updateFileList(List<XFile> files) {
    filesList = files;
    update();
  }

  updatePageCount(int count) {
    pageCount = count;
    update();
  }

  updateCurrentPage(int page) {
    currentPage = page;
    update();
  }

  updateOrginalText(String? text) {
    orginalText = text;
    update();
  }

  updateText(String? text) {
    this.text = text;
    update();
  }

  updateOtherText(String? text) {
    otherText = text;
    update();
  }

  closeFile() {
    filesList.removeAt(currentFileIndex);
    currentFileIndex = 0;
    if (filesList.isEmpty) {
      isShow = true;
      pageCount = null;
      currentPage = null;
      dragging = false;
    }
    text = null;
    orginalText = null;
    otherText = null;
    update();
  }

  goNextFile() {
    if (currentFileIndex < filesList.length - 1) {
      currentFileIndex++;
      currentPage = 1;
      update();
    } else {
      currentFileIndex = 0;
      currentPage = 1;
      update();
    }
  }

  goPreviousFile() {
    if (currentFileIndex > 0) {
      currentFileIndex--;
      currentPage = 1;
      update();
    } else {
      currentFileIndex = filesList.length - 1;
      currentPage = 1;
      update();
    }
  }

  clearReslut() {
    searchResult.clear();
    update();
  }
}

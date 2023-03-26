import 'dart:io';

import 'package:get/get.dart';

class PDFctr extends GetxController {
  int? pageCount;
  int? currentPage;

  String? orginalText;
  String? text;
  String? otherText;

  File? file;
  String? fileName;

  bool isShow = true;
  bool isSingle = true;

  updateIsShow() {
    isShow = !isShow;
    update();
  }

  updateIsSingle() {
    isSingle = !isSingle;
    update();
  }

  updateFile(String filePath, String fileName) {
    file = File(filePath);
    fileName = fileName;
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
    isShow = true;
    file = null;
    fileName = null;
    text = null;
    orginalText = null;
    otherText = null;
    pageCount = null;
    currentPage = null;
    isSingle = true;
    update();
  }
}

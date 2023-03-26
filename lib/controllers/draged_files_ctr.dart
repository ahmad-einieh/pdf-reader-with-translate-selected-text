import 'package:cross_file/cross_file.dart';
import 'package:get/get.dart';

class DragedFilesctr extends GetxController {
  final List<XFile> filesList = [];
  bool dragging = false;

  updateFilesList(List<XFile> files) {
    filesList.addAll(files);
    update();
  }

  updateDragging(bool dragging) {
    this.dragging = dragging;
    update();
  }
}

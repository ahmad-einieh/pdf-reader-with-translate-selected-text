import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_translator/controllers/pdf_ctr.dart';
import 'package:pdf_translator/views/pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';

import '../Widgets/custom_selectable_text.dart';
import '../Widgets/custom_widget.dart';
import '../Widgets/statues_bar.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PDFctr>(
        init: PDFctr(),
        builder: (pdfValue) => Center(
          child: Column(
            children: [
              CustomWidget(pdfValue: pdfValue),
              CustomSelectableText(
                  text: pdfValue.text == null ? "" : pdfValue.text!.trim()),
              CustomSelectableText(
                  text: pdfValue.otherText == null
                      ? ""
                      : pdfValue.otherText!.trim()),
              pdfValue.isShow
                  ? Expanded(
                      child: TextButton(
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                    dialogTitle: "open PDF files",
                                    allowedExtensions: ['pdf'],
                                    type: FileType.custom,
                                    allowMultiple: true,
                                    lockParentWindow: true);
                            if (result != null) {
                              List<XFile> xFilesFromOut = result.files
                                  .map((file) => XFile(file.path!))
                                  .toList();
                              pdfValue.updateFileList(xFilesFromOut);
                              await pdfValue.updateIsShow();
                            }
                          },
                          child: DropTarget(
                            onDragDone: (detail) async {
                              await pdfValue.updateFileList(detail.files);

                              await pdfValue.updateIsShow();
                            },
                            onDragEntered: (detail) {
                              pdfValue.updateDragging(true);
                            },
                            onDragExited: (detail) {
                              pdfValue.updateDragging(false);
                            },
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              color: pdfValue.dragging
                                  ? Colors.blue.withOpacity(0.4)
                                  : Colors.black26,
                              child: pdfValue.filesList.isEmpty
                                  ? const Center(
                                      child: Text(
                                          "Drop here or click to open files"))
                                  : const SizedBox(),
                            ),
                          )),
                    )
                  : PDFViewer(
                      pdfValue: pdfValue,
                    ),
              StatuesBar(pdfValue: pdfValue)
            ],
          ),
        ),
      ),
    );
  }
}

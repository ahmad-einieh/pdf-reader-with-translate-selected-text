import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_translator/controllers/draged_files_ctr.dart';
import 'package:pdf_translator/controllers/pdf_ctr.dart';
import 'package:pdf_translator/views/pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';

import '../Widgets/custom_selectable_text.dart';
import '../Widgets/custom_widget.dart';

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
              !pdfValue.isShow
                  ? PDFViewer(
                      file: pdfValue.file!,
                      pdfValue: pdfValue,
                    )
                  : Expanded(
                      child: Stack(
                        children: [
                          TextButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                      dialogTitle: "open PDF files",
                                      allowedExtensions: ['pdf'],
                                      type: FileType.custom,
                                      allowMultiple: true,
                                      lockParentWindow: true);
                              if (result != null) {
                                pdfValue.updateFile(result.files.single.path!,
                                    result.files.single.name);
                                pdfValue.updateIsShow();
                              }
                            },
                            child: GetBuilder<DragedFilesctr>(
                                init: DragedFilesctr(),
                                builder: (dragValue) {
                                  return DropTarget(
                                    onDragDone: (detail) {
                                      dragValue.updateFilesList(detail.files);
                                      pdfValue.updateFile(
                                          detail.files.first.path,
                                          detail.files.first.name);
                                      pdfValue.updateIsShow();
                                    },
                                    onDragEntered: (detail) {
                                      dragValue.updateDragging(true);
                                    },
                                    onDragExited: (detail) {
                                      dragValue.updateDragging(false);
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      color: dragValue.dragging
                                          ? Colors.blue.withOpacity(0.4)
                                          : Colors.black26,
                                      child: dragValue.filesList.isEmpty
                                          ? const Center(
                                              child: Text("Drop here"))
                                          : Text(
                                              dragValue.filesList.join("\n")),
                                    ),
                                  );
                                }),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                        dialogTitle: "open PDF files",
                                        allowedExtensions: ['pdf'],
                                        type: FileType.custom,
                                        allowMultiple: true,
                                        lockParentWindow: true);
                                if (result != null) {
                                  pdfValue.updateFile(result.files.single.path!,
                                      result.files.single.name);
                                  pdfValue.updateIsShow();
                                }
                              },
                              child: const Text("select PDF files")),
                        ],
                      ),
                    ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.blueGrey,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.01),
                  height: 32,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      !pdfValue.isShow
                          ? IconButton(
                              padding: EdgeInsets.zero,
                              tooltip: "close ${pdfValue.fileName}",
                              onPressed: () {
                                pdfValue.closeFile();
                              },
                              icon: const Icon(Icons.close))
                          : const SizedBox(),
                      pdfValue.currentPage == null || pdfValue.pageCount == null
                          ? const SizedBox()
                          : Text(
                              "${pdfValue.currentPage} of ${pdfValue.pageCount}",
                              style: const TextStyle(fontSize: 24),
                            ),
                      pdfValue.fileName == null
                          ? const SizedBox()
                          : Text(
                              pdfValue.fileName!,
                              style: const TextStyle(fontSize: 16),
                            ),
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            pdfValue.updateIsSingle();
                          },
                          icon: const Icon(Icons.change_circle)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

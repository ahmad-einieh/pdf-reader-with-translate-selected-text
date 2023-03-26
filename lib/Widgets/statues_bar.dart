import 'package:flutter/material.dart';
import '../controllers/pdf_ctr.dart';

class StatuesBar extends StatelessWidget {
  const StatuesBar({super.key, required this.pdfValue});
  final PDFctr pdfValue;

  @override
  Widget build(BuildContext context) {
    return Align(
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
                    tooltip:
                        "close ${pdfValue.filesList[pdfValue.currentFileIndex].name}",
                    onPressed: () async {
                      await pdfValue.closeFile();
                    },
                    icon: const Icon(Icons.close))
                : const SizedBox(),
            Row(
              children: [
                IconButton(
                    padding: EdgeInsets.zero,
                    tooltip: "go to pervious page",
                    onPressed: () {
                      pdfValue.pdfViewerController.previousPage();
                    },
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 33,
                    )),
                pdfValue.currentPage == null || pdfValue.pageCount == null
                    ? const SizedBox()
                    : Text(
                        "${pdfValue.currentPage} of ${pdfValue.pageCount}",
                        style: const TextStyle(fontSize: 24),
                      ),
                IconButton(
                    padding: EdgeInsets.zero,
                    tooltip: "go to next page",
                    onPressed: () {
                      pdfValue.pdfViewerController.nextPage();
                    },
                    icon: const Icon(
                      Icons.chevron_right,
                      size: 33,
                    )),
              ],
            ),
            pdfValue.filesList.isEmpty
                ? const SizedBox()
                : Text(
                    pdfValue.filesList[pdfValue.currentFileIndex].name,
                    style: const TextStyle(fontSize: 16),
                  ),
            Row(
              children: [
                IconButton(
                    padding: EdgeInsets.zero,
                    tooltip: "go to previous file",
                    onPressed: () async {
                      await pdfValue.goPreviousFile();
                    },
                    icon: const Icon(
                      Icons.arrow_left,
                      size: 33,
                    )),
                pdfValue.filesList.isEmpty
                    ? const SizedBox()
                    : Text(
                        "${pdfValue.currentFileIndex + 1} of ${pdfValue.filesList.length}",
                        style: const TextStyle(fontSize: 24),
                      ),
                IconButton(
                    padding: EdgeInsets.zero,
                    tooltip: "go to next file",
                    onPressed: () async {
                      await pdfValue.goNextFile();
                    },
                    icon: const Icon(
                      Icons.arrow_right,
                      size: 33,
                    )),
              ],
            ),
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  await pdfValue.updateIsSingle();
                },
                icon: const Icon(Icons.change_circle)),
          ],
        ),
      ),
    );
  }
}

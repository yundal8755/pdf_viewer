import 'package:flutter/material.dart';
import 'package:pdf_viewer_example/pages/pdf_viewer_page.dart';

void main() {
  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PdfViewerPage());
  }
}

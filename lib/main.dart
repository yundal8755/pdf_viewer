import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

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

class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({super.key});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? _filePath;

  // PDF 파일 선택 함수
  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF 파일 선택 및 보기'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickPdfFile,
            child: const Text('PDF 파일 선택하기'),
          ),
          if (_filePath != null)
            Expanded(
              child: PDFView(
                filePath: _filePath,
              ),
            ),
          if (_filePath == null)
            const Center(
              child: Text('PDF 파일이 선택되지 않았습니다.'),
            ),
        ],
      ),
    );
  }
}

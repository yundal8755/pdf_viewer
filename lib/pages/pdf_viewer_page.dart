import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({super.key});

  @override
  PdfViewerPageState createState() => PdfViewerPageState();
}

class PdfViewerPageState extends State<PdfViewerPage> {
  List<String> _savedFilePaths = []; // 로컬에 저장된 PDF 파일들의 경로 리스트
  String? selectedFilePath; // 선택된 PDF 파일의 경로

  @override
  void initState() {
    super.initState();
    _loadSavedPdfFiles(); // 초기화 시 저장된 파일 불러오기
  }

  // 저장된 PDF 파일들 불러오기 함수
  Future<void> _loadSavedPdfFiles() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = appDocDir.listSync(); // 디렉토리 내의 파일 목록 불러오기
    List<String> pdfFiles = files
        .where((file) => file.path.endsWith('.pdf')) // PDF 파일만 필터링
        .map((file) => file.path)
        .toList();

    setState(() {
      _savedFilePaths = pdfFiles; // 저장된 파일 경로 리스트에 추가
    });
  }

  // PDF 파일 선택 및 로컬 저장 함수
  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true, // 여러 개의 파일을 선택할 수 있도록 설정
    );

    if (result != null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      for (var file in result.files) {
        String filePath = file.path!;
        String savedFilePath = '${appDocDir.path}/${file.name}';

        // PDF 파일을 로컬에 저장
        File savedFile = await File(filePath).copy(savedFilePath);

        setState(() {
          _savedFilePaths.add(savedFile.path); // 저장된 경로를 리스트에 추가
        });
      }
    }
  }

  // PDF 열람 화면
  void _openPdf(BuildContext context, String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(filePath: filePath),
      ),
    );
  }

  // 면접 보기 화면으로 이동
  void _goToInterviewScreen(BuildContext context) {
    if (selectedFilePath != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InterviewScreen(filePath: selectedFilePath!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          AppBar(backgroundColor: Colors.white, title: const Text('이력서 선택하기')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _savedFilePaths.isNotEmpty
                  ? ListView.builder(
                      itemCount: _savedFilePaths.length,
                      itemBuilder: (context, index) {
                        String filePath = _savedFilePaths[index];
                        return GestureDetector(
                          onTap: () => _openPdf(context, filePath),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.blue.shade100,
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: selectedFilePath == filePath,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedFilePath =
                                            filePath; // 선택된 파일 경로 저장
                                      } else {
                                        selectedFilePath = null;
                                      }
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '파일: ${filePath.split('/').last}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 10),
                                            const Text('클릭하여 파일 열람하기'),
                                          ],
                                        ),
                                        const Icon(
                                            Icons.arrow_forward_ios_rounded)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('저장된 PDF 파일이 없습니다.'),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _pickPdfFile,
                    child: const Text('새로운 이력서 업로드'),
                  ),
                  ElevatedButton(
                    onPressed: selectedFilePath != null
                        ? () => _goToInterviewScreen(context)
                        : null, // 파일이 선택되지 않으면 비활성화
                    child: const Text('면접보기'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PdfViewerScreen extends StatelessWidget {
  final String filePath;

  const PdfViewerScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF 보기'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: PDFView(
          filePath: filePath,
          autoSpacing: false,
          pageFling: true,
          fitEachPage: true, // 페이지 크기에 맞게 확대
          enableSwipe: true, // 스와이프 가능 여부
          onRender: (pages) {
            // 첫 번째 페이지가 로드되었을 때 호출
            print('총 페이지 수: $pages');
          },
          onViewCreated: (controller) {
            controller.setPage(0); // 첫 페이지로 시작
          },
          onPageChanged: (page, total) {
            print('현재 페이지: $page / 총 페이지: $total');
          },
        ),
      ),
    );
  }
}

// 임의의 InterviewScreen 클래스 추가
class InterviewScreen extends StatelessWidget {
  final String filePath;

  const InterviewScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('면접 화면'),
      ),
      body: Center(
        child: Text('선택된 이력서: ${filePath.split('/').last}'),
      ),
    );
  }
}

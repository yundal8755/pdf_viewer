import 'package:flutter/material.dart';
import 'package:pdf_viewer_example/widgets/resume_interview_card.dart';

void main() {
  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('이력서 면접 예제'),
      ),
      body: const Column(
        children: [
          ResumeInterviewCard(),
        ],
      ),
    );
  }
}

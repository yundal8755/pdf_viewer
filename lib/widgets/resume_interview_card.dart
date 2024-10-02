import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf_viewer_example/pages/pdf_viewer_page.dart';

class ResumeInterviewCard extends StatelessWidget {
  const ResumeInterviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PdfViewerPage())),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), color: Colors.blue[100]),
          padding: const EdgeInsets.fromLTRB(24, 12, 0, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '이력서 면접',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SvgPicture.asset('assets/icons/round_blue_circle.svg')
                ],
              ),
              const Text(
                '이력서를 기반으로 실전 면접 연습을 진행해보세요!',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

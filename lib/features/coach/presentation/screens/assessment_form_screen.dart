import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/shared/widgets/feature_in_progress_view.dart';

/// Placeholder shown until the grading endpoint integration lands.
/// Real save target: `POST /v1/coach/sessions/{sessionId}/progress`.
class AssessmentFormScreen extends StatelessWidget {
  final String? sessionId;
  final String? sessionTitle;
  final String? studentId;
  final String? studentName;
  final Sport? sport;
  final DateTime? sessionDate;

  const AssessmentFormScreen({
    super.key,
    this.sessionId,
    this.sessionTitle,
    this.studentId,
    this.studentName,
    this.sport,
    this.sessionDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Penilaian Baru')),
      body: const SafeArea(
        child: FeatureInProgressView(
          icon: Icons.assessment_outlined,
          title: 'Penilaian belum dapat disimpan',
          description:
              'Form penilaian sedang diintegrasikan dengan backend. '
              'Saat fitur siap, hasil penilaian akan tersinkronisasi otomatis '
              'ke dashboard murid.',
        ),
      ),
    );
  }
}

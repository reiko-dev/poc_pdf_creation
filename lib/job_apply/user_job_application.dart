import 'package:poc_pdf_creation/job_apply/job.dart';
import 'package:poc_pdf_creation/job_apply/job_apply.dart';

class UserJobApplication {
  final JobApply apply;
  final Job job;

  const UserJobApplication({
    required this.apply,
    required this.job,
  });
}

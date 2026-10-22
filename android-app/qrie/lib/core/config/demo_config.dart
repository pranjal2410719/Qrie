/// Qrie Student Application — Demo Mode Configuration
///
/// Contains predefined development credentials and demo student profile details.
/// These credentials are isolated for local development and review flows and MUST NOT
/// be used for real student production authentication.
class DemoConfig {
  DemoConfig._();

  /// Default demo login credentials
  static const String demoEmail = 'student.demo@qrie.local';
  static const String demoPassword = 'QrieDemo123!';

  /// Fallback demo school-code credentials
  static const String demoSchoolCode = 'DPS-RKP-042';
  static const String demoRollNumber = 'DPS-2026-10A-07';

  /// Identified demo student profile
  static const String demoStudentId = 'demo_student_qrie';
  static const String demoStudentName = 'Aarav Sharma';
  static const String demoGrade = 'Class 10';
  static const String demoBoard = 'CBSE';
  static const String demoSchoolName = 'Delhi Public School, R.K. Puram';
  static const String demoToken = 'qrie_demo_session_token_local';

  /// Helper to check if provided credentials match demo values
  static bool validateCredentials(String email, String password) {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();
    return cleanEmail == demoEmail.toLowerCase() && cleanPassword == demoPassword;
  }
}

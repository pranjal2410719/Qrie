import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../models/school_branding_config.dart';

class SchoolThemeProvider extends ChangeNotifier {
  SchoolBrandingConfig _branding = SchoolBrandingConfig.dpsDefault();

  SchoolBrandingConfig get branding => _branding;

  void updateBranding(SchoolBrandingConfig newBranding) {
    if (_branding.schoolId != newBranding.schoolId ||
        _branding.primaryColor != newBranding.primaryColor) {
      _branding = newBranding;
      notifyListeners();
    }
  }

  ThemeData get themeData {
    final base = AppTheme.lightTheme;
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: _branding.primaryColor,
        secondary: _branding.secondaryColor,
        tertiary: _branding.accentColor,
      ),
    );
  }
}

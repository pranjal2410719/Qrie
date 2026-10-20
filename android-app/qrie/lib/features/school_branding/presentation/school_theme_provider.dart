import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: _branding.primaryColor,
        secondary: _branding.secondaryColor,
        tertiary: _branding.accentColor,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSurface: const Color(0xFF4B4B4B), // Charcoal
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: ThemeData.light().textTheme.apply(fontFamily: GoogleFonts.nunito().fontFamily),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: _branding.primaryColor),
        titleTextStyle: GoogleFonts.nunito(
          color: const Color(0xFF4B4B4B),
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _branding.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }
}

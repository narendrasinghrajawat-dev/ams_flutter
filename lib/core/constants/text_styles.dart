import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/text_sizes.dart';

/// Defines the base font styles using a consistent font and size scale.
/// Colors are omitted here and applied dynamically via AppTextWidget.
class AppStyles {

  static final veryLarge = GoogleFonts.openSans(
    fontSize: TextSizes.veryLarge,
    fontWeight: FontWeight.w700,
  );

  static final large = GoogleFonts.openSans(
    fontSize: TextSizes.large,
    fontWeight: FontWeight.w600,
  );

  static final medium = GoogleFonts.openSans(
    fontSize: TextSizes.medium,
    fontWeight: FontWeight.w500,
  );

  static final small = GoogleFonts.openSans(
    fontSize: TextSizes.small,
    fontWeight: FontWeight.w400,
  );

  static final verySmall = GoogleFonts.openSans(
    fontSize: TextSizes.verySmall,
    fontWeight: FontWeight.w400,
  );
}
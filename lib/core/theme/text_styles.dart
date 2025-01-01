import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 34.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.37,
    fontFamily: '.SF Pro Display',
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.34,
    fontFamily: '.SF Pro Display',
    height: 1.21,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: -0.41,
    fontFamily: '.SF Pro Text',
    height: 1.29,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: -0.24,
    fontFamily: '.SF Pro Text',
    height: 1.33,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: -0.32,
    fontFamily: '.SF Pro Text',
    height: 1.31,
  );

  // Input Fields
  static const TextStyle input = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: -0.41,
    fontFamily: '.SF Pro Text',
    height: 1.29,
  );

  static const TextStyle inputHint = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
    letterSpacing: -0.41,
    fontFamily: '.SF Pro Text',
    height: 1.29,
  );

  // Buttons
  static const TextStyle button = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    color: AppColors.buttonText,
    letterSpacing: -0.41,
    fontFamily: '.SF Pro Text',
    height: 1.29,
  );

  // Links
  static const TextStyle link = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.accent,
    letterSpacing: -0.32,
    fontFamily: '.SF Pro Text',
    height: 1.31,
    decoration: TextDecoration.underline,
  );

  static const h3 = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.35,
    fontFamily: '.SF Pro Display',
    height: 1.27,
  );


  // Profile screen title text (smaller, refined)
  static const TextStyle profileTitle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.profilePrimaryText,
    fontFamily: '.SF Pro Display',
  );

  // Profile screen subtitle text
  static const TextStyle profileSubtitle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.profileSecondaryText,
    fontFamily: '.SF Pro Text',
  );

  // Glass effect stat title text
  static const TextStyle glassStatTitle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.profileSecondaryText,
    fontFamily: '.SF Pro Text',
  );

  // Glass effect stat value text
  static const TextStyle glassStatValue = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    color: AppColors.profilePrimaryText,
    fontFamily: '.SF Pro Display',
  );

  // Link text without underline
  static const TextStyle linkText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.profileAccent,
    decoration: TextDecoration.none,
    fontFamily: '.SF Pro Text',
  );
}
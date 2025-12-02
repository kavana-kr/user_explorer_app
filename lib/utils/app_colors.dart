import 'package:flutter/material.dart';

class AppColors {
  // ----------- BRAND COLORS -----------
  // core violet color used across the app
  static const primary = Color(0xFF8C4AF2);       
  // secondary highlight color for subtle accents
  static const accent = Color(0xFFC77DFF);        

  // ----------- LIGHT MODE COLORS -----------
  // main background for light theme
  static const lightBackground = Color(0xFFF8F4FF);   
  // card + surface color in light mode
  static const lightSurface = Color(0xFFFFFFFF);       
  // primary text color in light mode
  static const textDark = Color(0xFF2F2A38);           

  // light mode gradient (soft violet blend)
  static const gradientLightTop = Color(0xFFD7B3FF);       
  static const gradientLightBottom = Color(0xFFF3D1FF);    

  // ----------- DARK MODE COLORS -----------
  // main background for dark theme
  static const darkBackground = Color(0xFF1B1526);      
  // card + surface color in dark theme
  static const darkSurface = Color(0xFF2A2235);         
  // primary text color in dark mode
  static const textLight = Color(0xFFECE3FF);           

  // dark mode gradient (neon purple look)
  static const gradientDarkTop = Color(0xFFB388FF);      
  static const gradientDarkBottom = Color(0xFF8C4AF2);   

  // ----------- BUTTON GRADIENT -----------
  // start color of action buttons
  static const buttonGradientStart = Color(0xFF8C4AF2);
  // end color of action buttons
  static const buttonGradientEnd = Color(0xFFC77DFF);
}

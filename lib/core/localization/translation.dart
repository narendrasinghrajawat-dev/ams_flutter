import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TranslationService extends Translations {
  static final locale = Locale('en', 'US');
  static final fallbackLocale = Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'login': 'Login',
      'email': 'Email',
      'password': 'Password',
      'admin_dashboard': 'Admin Dashboard',
      'user_dashboard': 'User Dashboard',
      'mark_attendance': 'Mark Attendance',
    },
    'hi_IN': {
      'login': 'लॉगिन',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'admin_dashboard': 'अडमिन डैशबोर्ड',
      'user_dashboard': 'उपयोगकर्ता डैशबोर्ड',
      'mark_attendance': 'अटेंडेंस मार्क करें',
    }
  };
}

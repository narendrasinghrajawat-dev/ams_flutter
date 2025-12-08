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


      // 🔹 Admin Home Page
      'total_employees': 'Total Employees',
      'total_registered_staff': 'Total registered staff',
      'present_today': 'Present Today',
      'attendance_percentage': 'attendance',
      'on_leave': 'On Leave',
      'pending_leaves': 'pending approval',
      'late_arrivals': 'Late Arrivals',
      'attendance_issues_today': 'Attendance issues today',
      'quick_actions': 'Quick Actions',
      'recent_activity': 'Recent Activity',
      'view_all': 'View All',
      'no_recent_activity': 'No recent activity found.',





    },
    'hi_IN': {
      'login': 'लॉगिन',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'admin_dashboard': 'अडमिन डैशबोर्ड',
      'user_dashboard': 'उपयोगकर्ता डैशबोर्ड',
      'mark_attendance': 'अटेंडेंस मार्क करें',



      // 🔹 Admin Home Page (Hindi)
      'total_employees': 'कुल कर्मचारी',
      'total_registered_staff': 'कुल पंजीकृत स्टाफ',
      'present_today': 'आज उपस्थित',
      'attendance_percentage': 'उपस्थिति',
      'on_leave': 'छुट्टी पर',
      'pending_leaves': 'लंबित स्वीकृतियाँ',
      'late_arrivals': 'देर से आने वाले',
      'attendance_issues_today': 'आज की उपस्थिति समस्याएँ',
      'quick_actions': 'त्वरित क्रियाएँ',
      'recent_activity': 'हाल की गतिविधियाँ',
      'view_all': 'सभी देखें',
      'no_recent_activity': 'कोई हाल की गतिविधि नहीं मिली।',


    }
  };
}

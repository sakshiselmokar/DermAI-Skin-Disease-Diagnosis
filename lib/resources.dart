import 'package:flutter/material.dart';

// Brand primary colour used across the app
const Color c = Color(0xFF1DC25F);

// Secondary / accent
const Color cDark = Color(0xFF14873F);

class FormValidator {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(email)) return 'Enter a valid email';
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Minimum 6 characters';
    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) return 'Name is required';
    return null;
  }
}

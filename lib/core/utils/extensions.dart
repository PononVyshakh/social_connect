// lib/core/utils/extensions.dart
import 'package:flutter/material.dart';

extension StringExtensions on String {
  /// Check if string is email
  bool get isEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(this);
  }

  /// Check if string is phone number
  bool get isPhone {
    final digits = replaceAll(RegExp(r'[^\d]'), '');
    return digits.length == 10;
  }

  /// Check if string is numeric
  bool get isNumeric {
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Reverse string
  String get reverse {
    return split('').reversed.join('');
  }

  /// Check if string contains only letters
  bool get isAlpha {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }

  /// Remove all whitespace
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Get initials from name
  String get initials {
    final parts = split(' ');
    if (parts.isEmpty) return '';
    
    final first = parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '';
    final last = parts.length > 1 && parts[1].isNotEmpty
        ? parts[1][0].toUpperCase()
        : '';
    
    return (first + last).substring(0, 2);
  }

  /// Truncate string
  String truncate(int length) {
    if (this.length <= length) return this;
    return '${substring(0, length)}...';
  }
}

extension BuildContextExtensions on BuildContext {
  /// Get screen width
  double get screenWidth {
    return MediaQuery.of(this).size.width;
  }

  /// Get screen height
  double get screenHeight {
    return MediaQuery.of(this).size.height;
  }

  /// Get screen size
  Size get screenSize {
    return MediaQuery.of(this).size;
  }

  /// Check if device is in landscape
  bool get isLandscape {
    return MediaQuery.of(this).orientation == Orientation.landscape;
  }

  /// Check if device is in portrait
  bool get isPortrait {
    return MediaQuery.of(this).orientation == Orientation.portrait;
  }

  /// Get padding from MediaQuery
  EdgeInsets get padding {
    return MediaQuery.of(this).padding;
  }

  /// Get view insets (keyboard height)
  EdgeInsets get viewInsets {
    return MediaQuery.of(this).viewInsets;
  }

  /// Check if keyboard is shown
  bool get isKeyboardShown {
    return viewInsets.bottom > 0;
  }

  /// Get device pixel ratio
  double get devicePixelRatio {
    return MediaQuery.of(this).devicePixelRatio;
  }

  /// Show snackbar
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}

extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Format time
  String get formattedTime {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Format date
  String get formattedDate {
    return '$day/$month/$year';
  }

  /// Format date and time
  String get formattedDateTime {
    return '$formattedDate $formattedTime';
  }
}

extension IntExtensions on int {
  /// Format as currency
  String toCurrency({String symbol = '₹'}) {
    return '$symbol${this.toString()}';
  }

  /// Check if even
  bool get isEven {
    return this % 2 == 0;
  }

  /// Check if odd
  bool get isOdd {
    return this % 2 != 0;
  }
}

extension DoubleExtensions on double {
  /// Format as currency
  String toCurrency({String symbol = '₹'}) {
    return '$symbol${toStringAsFixed(2)}';
  }

  /// Round to decimal places
  double roundToDecimal(int decimalPlaces) {
    final factor = 10.0 * decimalPlaces;
    return (this * factor).round() / factor;
  }
}

extension ListExtensions<T> on List<T> {
  /// Check if list is empty
  bool get isEmpty => length == 0;

  /// Check if list is not empty
  bool get isNotEmpty => length > 0;

  /// Get first element safely
  T? get firstOrNull {
    return isEmpty ? null : first;
  }

  /// Get last element safely
  T? get lastOrNull {
    return isEmpty ? null : last;
  }

  /// Duplicate list
  List<T> duplicate() {
    return List<T>.from(this);
  }
}

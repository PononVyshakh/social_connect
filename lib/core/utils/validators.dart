// lib/core/utils/validators.dart

class Validators {
  // Phone number validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove +91 prefix if present
    String phone = value.replaceFirst('+91', '').replaceFirst('91', '');
    phone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (phone.length != 10) {
      return 'Phone number must be 10 digits';
    }
    
    return null;
  }

  // Display name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    if (value.length > 50) {
      return 'Name must not exceed 50 characters';
    }
    
    // Check if name contains only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    
    return null;
  }

  // OTP validation
  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'OTP must contain only digits';
    }
    
    return null;
  }

  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    const pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);
    
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }

  // Gender validation
  static String? validateGender(String? value) {
    if (value == null || value.isEmpty || value == 'unknown') {
      return 'Please select a gender';
    }
    
    return null;
  }

  // About/Bio validation
  static String? validateAbout(String? value) {
    if (value == null) {
      return null; // About is optional
    }
    
    if (value.length > 250) {
      return 'About must not exceed 250 characters';
    }
    
    return null;
  }

  // General text validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Confirm password validation
  static String? validatePasswordMatch(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
}

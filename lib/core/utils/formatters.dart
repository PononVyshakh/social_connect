// lib/core/utils/formatters.dart

class Formatters {
  // Format phone number with +91 prefix
  static String formatPhoneNumber(String phone) {
    // Remove any non-digit characters
    phone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    // Remove leading 0 if present (common in Indian numbers)
    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }
    
    // Add +91 prefix
    if (!phone.startsWith('+91')) {
      phone = '+91$phone';
    }
    
    return phone;
  }

  // Format phone number for display (without +91)
  static String formatPhoneNumberForDisplay(String phone) {
    phone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (phone.length >= 10) {
      return phone.substring(phone.length - 10);
    }
    
    return phone;
  }

  // Format timestamp to readable date-time
  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  // Format time of day
  static String formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Format currency
  static String formatCurrency(double amount, {String symbol = '₹'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  // Format large numbers with K, M, B suffix
  static String formatNumber(int number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Truncate text with ellipsis
  static String truncate(String text, int length) {
    if (text.length <= length) return text;
    return '${text.substring(0, length)}...';
  }

  // Format initials from name
  static String getInitials(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return '';
    
    final firstInitial = parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '';
    final lastInitial = parts.length > 1 && parts[1].isNotEmpty
        ? parts[1][0].toUpperCase()
        : '';
    
    return (firstInitial + lastInitial).substring(0, 2);
  }
}

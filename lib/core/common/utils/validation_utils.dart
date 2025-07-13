/// Validation Utilities
/// Contains common validation functions used throughout the application

/// Validation utility class providing common validation operations
class ValidationUtils {
  /// Private constructor to prevent instantiation
  ValidationUtils._();

  /// Validate email address
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return email.contains('@') && email.contains('.');
  }

  /// Validate phone number
  static bool isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    return phone.length >= 10;
  }

  /// Validate URL
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  /// Validate password strength
  static bool isValidPassword(String password) {
    if (password.isEmpty) return false;
    return password.length >= 8;
  }

  /// Get password strength level
  static PasswordStrength getPasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;
    
    int score = 0;
    
    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    
    // Character type checks
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'\d'))) score++;
    
    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  /// Validate required field
  static bool isRequired(String value) {
    return value.trim().isNotEmpty;
  }

  /// Validate minimum length
  static bool hasMinLength(String value, int minLength) {
    return value.length >= minLength;
  }

  /// Validate maximum length
  static bool hasMaxLength(String value, int maxLength) {
    return value.length <= maxLength;
  }

  /// Validate exact length
  static bool hasExactLength(String value, int length) {
    return value.length == length;
  }

  /// Validate numeric value
  static bool isNumeric(String value) {
    if (value.isEmpty) return false;
    return double.tryParse(value) != null;
  }

  /// Validate integer value
  static bool isInteger(String value) {
    if (value.isEmpty) return false;
    return int.tryParse(value) != null;
  }

  /// Validate positive number
  static bool isPositive(String value) {
    final number = double.tryParse(value);
    return number != null && number > 0;
  }

  /// Validate non-negative number
  static bool isNonNegative(String value) {
    final number = double.tryParse(value);
    return number != null && number >= 0;
  }

  /// Validate date format
  static bool isValidDate(String date) {
    try {
      DateTime.parse(date);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validate username (alphanumeric, 3-20 characters)
  static bool isValidUsername(String username) {
    if (username.isEmpty) return false;
    return username.length >= 3 && username.length <= 20;
  }

  /// Validate file extension
  static bool isValidFileExtension(String fileName, List<String> allowedExtensions) {
    if (fileName.isEmpty) return false;
    
    final extension = fileName.split('.').last.toLowerCase();
    return allowedExtensions.contains(extension);
  }

  /// Validate file size (in bytes)
  static bool isValidFileSize(int fileSize, int maxSizeInBytes) {
    return fileSize <= maxSizeInBytes;
  }

  /// Sanitize input (remove special characters)
  static String sanitizeInput(String input) {
    return input.replaceAll('<', '').replaceAll('>', '').replaceAll('"', '').replaceAll("'", '');
  }

  /// Format phone number
  static String formatPhoneNumber(String phoneNumber) {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanNumber.length == 10) {
      return '(${cleanNumber.substring(0, 3)}) ${cleanNumber.substring(3, 6)}-${cleanNumber.substring(6)}';
    }
    
    return phoneNumber;
  }

  /// Get validation error message
  static String getErrorMessage(ValidationError error) {
    switch (error) {
      case ValidationError.required:
        return 'This field is required';
      case ValidationError.email:
        return 'Please enter a valid email address';
      case ValidationError.phone:
        return 'Please enter a valid phone number';
      case ValidationError.password:
        return 'Password must be at least 8 characters';
      case ValidationError.minLength:
        return 'Minimum length not met';
      case ValidationError.maxLength:
        return 'Maximum length exceeded';
      case ValidationError.numeric:
        return 'Please enter a valid number';
      case ValidationError.positive:
        return 'Please enter a positive number';
      case ValidationError.url:
        return 'Please enter a valid URL';
      case ValidationError.date:
        return 'Please enter a valid date';
      case ValidationError.username:
        return 'Username must be 3-20 characters';
    }
  }
}

/// Password strength levels
enum PasswordStrength {
  weak,
  medium,
  strong,
}

/// Validation error types
enum ValidationError {
  required,
  email,
  phone,
  password,
  minLength,
  maxLength,
  numeric,
  positive,
  url,
  date,
  username,
} 
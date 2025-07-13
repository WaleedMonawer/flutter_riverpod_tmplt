/// String Utilities
/// Contains common string manipulation functions used throughout the application

/// String utility class providing common string operations
class StringUtils {
  /// Private constructor to prevent instantiation
  StringUtils._();

  /// Check if string is null or empty
  static bool isNullOrEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  /// Check if string is null, empty or whitespace
  static bool isNullOrWhitespace(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// Capitalize first letter of string
  static String capitalize(String value) {
    if (isNullOrEmpty(value)) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  /// Capitalize first letter of each word
  static String capitalizeWords(String value) {
    if (isNullOrEmpty(value)) return value;
    
    final words = value.split(' ');
    final capitalizedWords = words.map((word) => capitalize(word));
    return capitalizedWords.join(' ');
  }

  /// Convert string to camel case
  static String toCamelCase(String value) {
    if (isNullOrEmpty(value)) return value;
    
    final words = value.split(RegExp(r'[\s\-_]'));
    if (words.isEmpty) return value;
    
    final firstWord = words[0].toLowerCase();
    final remainingWords = words.skip(1).map((word) => capitalize(word));
    
    return firstWord + remainingWords.join();
  }

  /// Convert string to snake case
  static String toSnakeCase(String value) {
    if (isNullOrEmpty(value)) return value;
    
    return value
        .replaceAll(RegExp(r'([a-z])([A-Z])'), r'$1_$2')
        .replaceAll(RegExp(r'[\s\-]'), '_')
        .toLowerCase();
  }

  /// Convert string to kebab case
  static String toKebabCase(String value) {
    if (isNullOrEmpty(value)) return value;
    
    return value
        .replaceAll(RegExp(r'([a-z])([A-Z])'), r'$1-$2')
        .replaceAll(RegExp(r'[\s_]'), '-')
        .toLowerCase();
  }

  /// Convert string to title case
  static String toTitleCase(String value) {
    if (isNullOrEmpty(value)) return value;
    
    final words = value.split(RegExp(r'[\s\-_]'));
    final titleWords = words.map((word) => capitalize(word));
    return titleWords.join(' ');
  }

  /// Truncate string to specified length
  static String truncate(String value, int maxLength, {String suffix = '...'}) {
    if (isNullOrEmpty(value) || value.length <= maxLength) return value;
    return value.substring(0, maxLength - suffix.length) + suffix;
  }

  /// Remove extra whitespace from string
  static String removeExtraWhitespace(String value) {
    if (isNullOrEmpty(value)) return value;
    return value.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Remove all whitespace from string
  static String removeWhitespace(String value) {
    if (isNullOrEmpty(value)) return value;
    return value.replaceAll(RegExp(r'\s'), '');
  }

  /// Reverse string
  static String reverse(String value) {
    if (isNullOrEmpty(value)) return value;
    return String.fromCharCodes(value.codeUnits.reversed);
  }

  /// Check if string is palindrome
  static bool isPalindrome(String value) {
    if (isNullOrEmpty(value)) return true;
    
    final cleanValue = value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return cleanValue == reverse(cleanValue);
  }

  /// Count words in string
  static int wordCount(String value) {
    if (isNullOrEmpty(value)) return 0;
    return value.trim().split(RegExp(r'\s+')).length;
  }

  /// Count characters in string (excluding whitespace)
  static int characterCount(String value) {
    if (isNullOrEmpty(value)) return 0;
    return removeWhitespace(value).length;
  }

  /// Extract numbers from string
  static String extractNumbers(String value) {
    if (isNullOrEmpty(value)) return '';
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Extract letters from string
  static String extractLetters(String value) {
    if (isNullOrEmpty(value)) return '';
    return value.replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }

  /// Extract alphanumeric characters from string
  static String extractAlphanumeric(String value) {
    if (isNullOrEmpty(value)) return '';
    return value.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  /// Check if string contains only numbers
  static bool isNumeric(String value) {
    if (isNullOrEmpty(value)) return false;
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }

  /// Check if string contains only letters
  static bool isAlphabetic(String value) {
    if (isNullOrEmpty(value)) return false;
    return RegExp(r'^[a-zA-Z]+$').hasMatch(value);
  }

  /// Check if string contains only alphanumeric characters
  static bool isAlphanumeric(String value) {
    if (isNullOrEmpty(value)) return false;
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);
  }

  /// Generate random string
  static String generateRandomString(int length, {bool includeNumbers = true, bool includeSymbols = false}) {
    const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
    
    String chars = letters;
    if (includeNumbers) chars += numbers;
    if (includeSymbols) chars += symbols;
    
    final random = RegExp(r'[a-zA-Z]');
    String result = '';
    
    for (int i = 0; i < length; i++) {
      result += chars[random.hashCode % chars.length];
    }
    
    return result;
  }

  /// Mask string (e.g., for credit card numbers)
  static String mask(String value, {String maskChar = '*', int visibleStart = 0, int visibleEnd = 0}) {
    if (isNullOrEmpty(value)) return value;
    
    if (value.length <= visibleStart + visibleEnd) return value;
    
    final start = value.substring(0, visibleStart);
    final end = value.substring(value.length - visibleEnd);
    final masked = maskChar * (value.length - visibleStart - visibleEnd);
    
    return start + masked + end;
  }

  /// Format phone number
  static String formatPhoneNumber(String phoneNumber) {
    if (isNullOrEmpty(phoneNumber)) return phoneNumber;
    
    final cleanNumber = extractNumbers(phoneNumber);
    
    if (cleanNumber.length == 10) {
      return '(${cleanNumber.substring(0, 3)}) ${cleanNumber.substring(3, 6)}-${cleanNumber.substring(6)}';
    } else if (cleanNumber.length == 11 && cleanNumber.startsWith('1')) {
      return '+1 (${cleanNumber.substring(1, 4)}) ${cleanNumber.substring(4, 7)}-${cleanNumber.substring(7)}';
    }
    
    return phoneNumber;
  }

  /// Format credit card number
  static String formatCreditCard(String cardNumber) {
    if (isNullOrEmpty(cardNumber)) return cardNumber;
    
    final cleanNumber = extractNumbers(cardNumber);
    
    if (cleanNumber.length == 16) {
      return '${cleanNumber.substring(0, 4)} ${cleanNumber.substring(4, 8)} ${cleanNumber.substring(8, 12)} ${cleanNumber.substring(12)}';
    }
    
    return cardNumber;
  }

  /// Convert string to initials
  static String toInitials(String value) {
    if (isNullOrEmpty(value)) return '';
    
    final words = value.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }
    
    return '${words[0][0]}${words.last[0]}'.toUpperCase();
  }

  /// Check if string starts with any of the given prefixes
  static bool startsWithAny(String value, List<String> prefixes) {
    if (isNullOrEmpty(value)) return false;
    
    for (final prefix in prefixes) {
      if (value.startsWith(prefix)) return true;
    }
    return false;
  }

  /// Check if string ends with any of the given suffixes
  static bool endsWithAny(String value, List<String> suffixes) {
    if (isNullOrEmpty(value)) return false;
    
    for (final suffix in suffixes) {
      if (value.endsWith(suffix)) return true;
    }
    return false;
  }

  /// Remove prefix from string if it exists
  static String removePrefix(String value, String prefix) {
    if (isNullOrEmpty(value) || isNullOrEmpty(prefix)) return value;
    
    if (value.startsWith(prefix)) {
      return value.substring(prefix.length);
    }
    return value;
  }

  /// Remove suffix from string if it exists
  static String removeSuffix(String value, String suffix) {
    if (isNullOrEmpty(value) || isNullOrEmpty(suffix)) return value;
    
    if (value.endsWith(suffix)) {
      return value.substring(0, value.length - suffix.length);
    }
    return value;
  }

  /// Repeat string
  static String repeat(String value, int count) {
    if (isNullOrEmpty(value) || count <= 0) return '';
    
    return value * count;
  }

  /// Pad string to specified length
  static String padLeft(String value, int length, {String padding = ' '}) {
    if (isNullOrEmpty(value)) return value;
    
    if (value.length >= length) return value;
    
    final padLength = length - value.length;
    return repeat(padding, padLength) + value;
  }

  /// Pad string to specified length on the right
  static String padRight(String value, int length, {String padding = ' '}) {
    if (isNullOrEmpty(value)) return value;
    
    if (value.length >= length) return value;
    
    final padLength = length - value.length;
    return value + repeat(padding, padLength);
  }

  /// Center string within specified length
  static String center(String value, int length, {String padding = ' '}) {
    if (isNullOrEmpty(value)) return value;
    
    if (value.length >= length) return value;
    
    final padLength = length - value.length;
    final leftPad = padLength ~/ 2;
    final rightPad = padLength - leftPad;
    
    return repeat(padding, leftPad) + value + repeat(padding, rightPad);
  }
} 
class ValidationConstants {
  // Minimum lengths
  static const int minPasswordLength = 6;
  static const int minNameLength = 2;

  // Maximum lengths
  static const int maxNameLength = 50;
  static const int maxEmailLength = 100;

  // Photo upload limits
  static const int maxPhotoSizeBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.webp'
  ];
}

class ValidationRegExp {
  // Email validation - RFC 5322 compliant
  static final RegExp email = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  // Name validation - only letters, spaces, and common characters
  static final RegExp name = RegExp(
    r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s\-\.]+$',
  );

  // Phone number validation (Turkish format)
  static final RegExp phoneNumber = RegExp(
    r'^(\+90|0)?[5][0-9]{2}[0-9]{3}[0-9]{2}[0-9]{2}$',
  );

  // URL validation
  static final RegExp url = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  );

  // Only numbers
  static final RegExp numbersOnly = RegExp(r'^[0-9]+$');

  // Only letters and spaces
  static final RegExp lettersAndSpaces = RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s]+$');
}

class ValidationHelper {
  // Email validation
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return ValidationRegExp.email.hasMatch(email.trim());
  }

  // Name validation
  static bool isValidName(String? name) {
    if (name == null || name.isEmpty) return false;
    final trimmedName = name.trim();
    return trimmedName.length >= ValidationConstants.minNameLength &&
        trimmedName.length <= ValidationConstants.maxNameLength &&
        ValidationRegExp.name.hasMatch(trimmedName);
  }

  // Phone number validation
  static bool isValidPhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    return ValidationRegExp.phoneNumber.hasMatch(phone.trim());
  }

  // File extension validation
  static bool isValidImageFile(String filePath) {
    final lowerPath = filePath.toLowerCase();
    return ValidationConstants.allowedImageExtensions
        .any((ext) => lowerPath.endsWith(ext));
  }

  // File size validation
  static bool isValidFileSize(int sizeInBytes) {
    return sizeInBytes <= ValidationConstants.maxPhotoSizeBytes;
  }
}

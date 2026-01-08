String? firstNameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Enter first name';
  }
  return null;
}

String? lastNameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Enter last name';
  }
  return null;
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}

String? mobileNumberValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Enter mobile number';
  }

  final trimmed = value.trim();

  if (!RegExp(r'^\d+$').hasMatch(trimmed)) {
    return 'Mobile number must contain only digits';
  }

  if (trimmed.length != 11) {
    return 'Mobile number must be 11 digits';
  }

  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Enter Password';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters';
  }
  return null;
}

String? newPasswordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Enter Password';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters';
  }
  return null;
}

// Confirm Password Validator
String? confirmPasswordValidator(String? value, String? originalPassword) {
  if (value == null || value.isEmpty) {
    return 'Please confirm your password';
  }
  if (value != originalPassword) {
    return 'Passwords do not match';
  }
  return null;
}

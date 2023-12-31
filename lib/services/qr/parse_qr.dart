int parseQRCode(String value) {
  // Try to parse as URL
  try {
    final Uri uri = Uri.parse(value);
    // Return parameter code if it exists
    if (uri.queryParameters.containsKey("code")) {
      return int.parse(uri.queryParameters["code"]!);
    }
  } catch (e) {
    if (e is FormatException) {
      // Do nothing
    } else {
      throw Exception("Failed to parse QR code");
    }
  }

  // Try to parse as integer
  try {
    return int.parse(value);
  } catch (e) {
    throw Exception("Failed to parse QR code");
  }
}

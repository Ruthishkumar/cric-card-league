extension ValidPhoneNumber on String {
  bool hasValidPhoneNumber() {
    return (length >= 10);
  }
}

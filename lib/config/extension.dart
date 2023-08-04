extension PasswordValidator on String {
  bool isValidPassword() => this.isNotEmpty && this.length >= 8;
}

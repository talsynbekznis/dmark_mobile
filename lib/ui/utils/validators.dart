bool isValidGtin(String s) {
  final reg = RegExp(r'^\d{13}$');
  return reg.hasMatch(s);
}

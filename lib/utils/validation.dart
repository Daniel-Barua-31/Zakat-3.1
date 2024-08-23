String? validateCash(String value) {
  if (value.isEmpty) {
    return 'Enter your cash amount!';
  } else if (double.tryParse(value) == null) {
    return 'Error: Cash must be a number';
  }
  return null;
}

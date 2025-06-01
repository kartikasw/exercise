extension XDouble on double {
  String get format {
    if (this % 1 == 0) {
      return toInt().toString();
    } else {
      return toStringAsFixed(1);
    }
  }
}

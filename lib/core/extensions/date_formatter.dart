extension DateFormatter on String {
  String format(){
    final value = replaceAll("T", " ");
    return value.substring(0, 16);
  }
}
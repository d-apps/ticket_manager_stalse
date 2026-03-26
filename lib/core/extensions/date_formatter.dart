extension DateFormatter on String {
  String format(){
    final value = this.replaceAll("T", " ");
    return value.substring(0, 16);
  }
}
class Util {
  static String timeFormat(int time) {
    int seconds = time % 60;
    int minutes = time ~/ 60;

    if (minutes != 0) {
      return "$minutes분 $seconds초";
    } else {
      return "$seconds초";
    }
  }
}
extension DateTimeExtensions on DateTime {
  getDateOnly({String separator = '-'}) =>
      '$year$separator$month$separator$day';

  String getDayOfWeekAsString() {
    return dayOfWeek[weekday]!;
  }
}

Map<int, String> dayOfWeek = {
  1: 'Monday',
  2: 'Tuesday',
  3: 'Wednesday',
  4: 'Thursday',
  5: 'Friday',
  6: 'Saturday',
  7: 'Sunday',
};

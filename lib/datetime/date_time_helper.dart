String convertDateTimeToString(DateTime dateTime) {
  // year format yyyy
  String year = dateTime.year.toString();

  //mont format mm
  String month = dateTime.month.toString();
  if (month.length == 1){
    month = '0$month';
  }

  //day format dd
  String day = dateTime.day.toString();
  if (day.length == 1){
    day = '0$day';
  }

  String yyyymmdd = year+month+day;

  return yyyymmdd;
}
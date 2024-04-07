class Apiconst {
  static String get baseurl => "http://10.0.2.2:3000/";

  // static String get baseurl => "http://192.168.1.33:3000/";
  // 192.168.1.33
  static String logincheck = '$baseurl' + 'login/check';
  static String addholidays = '$baseurl' + 'holidays';
  static String getholidays = '$baseurl' + 'holidays';
  static String updateHoliday = '$baseurl' + 'holidays/update';
  static String findShift = '$baseurl' + 'shift/find';
  static String listallShift = '$baseurl' + 'shift';
  static String listallEvents = '$baseurl' + 'events';
  static String addEvent = '$baseurl' + 'events';
}

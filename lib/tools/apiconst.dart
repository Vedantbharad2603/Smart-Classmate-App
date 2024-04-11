class Apiconst {
  static String get baseurl => "https://0404-103-107-61-110.ngrok-free.app/";

  // static String get baseurl => "http://192.168.1.33:3000/";
  // http://10.0.2.2:3000/
  static String logincheck = '${baseurl}login/check';
  static String addLogindata = '${baseurl}login';
  static String changeLoginstatus = '${baseurl}login/change';
  static String changeType = '${baseurl}login/changeType';
  static String giveuserlogin = '${baseurl}login/username';
  static String getTeacher = '${baseurl}login/getTeacher';
  static String getCourses = '${baseurl}courses';
  static String addCourses = '${baseurl}courses';
  static String getCourseLevels = '${baseurl}courselevels/getlevels';
  static String addholidays = '${baseurl}holidays';
  static String getholidays = '${baseurl}holidays';
  static String updateHoliday = '${baseurl}holidays/update';
  static String findShift = '${baseurl}shift/find';
  static String listallShift = '${baseurl}shift';
  static String listallEvents = '${baseurl}events';
  static String addEvent = '${baseurl}events';
  static String addTeacher = '${baseurl}teacher';
}

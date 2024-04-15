class Apiconst {
  static String get baseurl => "https://smart-classmate-server.onrender.com/";
  //live api baseurl "https://smart-classmate-server.onrender.com/
  //Emulator baseurl "http://10.0.2.2:3000/"
  // static String get baseurl => "http://laptopip:3000/"
  static String logincheck = '${baseurl}login/check';
  static String addLogindata = '${baseurl}login';
  static String changeLoginstatus = '${baseurl}login/change';
  static String changeType = '${baseurl}login/changeType';
  static String giveuserlogin = '${baseurl}login/username';
  static String getTeacher = '${baseurl}login/getTeacher';
  static String addTeacher = '${baseurl}teacher';
  static String updateTeacher = '${baseurl}teacher/update';
  static String addStudent = '${baseurl}student';
  static String getCourses = '${baseurl}courses';
  static String addCourses = '${baseurl}courses';
  static String listallCourses = '${baseurl}courses';
  static String addCourseLevels = '${baseurl}courselevels';
  static String getCourseLevels = '${baseurl}courselevels/getlevels';
  static String addCourseConcepts = '${baseurl}courseconcepts';
  static String getConcepts = '${baseurl}courseconcepts/getconcepts';
  static String updateConcepts = '${baseurl}courseconcepts/update';
  static String addholidays = '${baseurl}holidays';
  static String getholidays = '${baseurl}holidays';
  static String upcomingholiday = '${baseurl}holidays/upcoming';
  static String updateHoliday = '${baseurl}holidays/update';
  static String findShift = '${baseurl}shift/find';
  static String listallShift = '${baseurl}shift';
  static String listallEvents = '${baseurl}events';
  static String addEvent = '${baseurl}events';
}

class ApiConstants {
  static const String baseUrl = "https://vms-dev.zsgov.ng";

  static String patchChangePassword(String userId) =>
      "/api/v1/auth/password/$userId";
  static String patchChangePicture(String userId) =>
      "/api/v1/auth/picture/$userId";

  static const String postLogin = "/api/v1/auth/login";

  static const String postRegisterUser = "/api/v1/staff/register";

  static const String putChangePassword = "/change-password";

  static const String getUsers = "/api/v1/staff/";

  static const String getVisitors = "/api/v1/guest/";
  static const String searchAppointmentsByPhone =
      "/api/v1/appointment/phone/:phone";
  static const String assignTagToVisitor = "/api/v1/guest/phone/:phone";
  static const String getMyDashboardTv = "/api/v1/dashboard/my-dashboard";
  static const String createMyDashboardTv =
      "/api/v1/dashboard/create-dashboard";

  static const String postRegisterVisitor = "/api/v1/guest/";
  static const String postUpdateVisitor = "/api/v1/guest/:id";

  static const String getTags = "/api/v1/viptag/";
  static const String assignTagToAppointment =
      "/api/v1/appointment/assign-tag/:appointmentId";

  static const String postCreateAppointment = "/api/v1/appointment/";
  static String putRescheduleAppointment(String apId) =>
      "/api/v1/appointment/reschedule-appointment/$apId";
  static String putCancelAppointment(String apId) =>
      "/api/v1/appointment/cancel-appointment/$apId";

  static const String getMyAppointments = "/api/v1/appointment/by-staffid";

  static const String postCreateReminder = "/api/v1/reminder";

  static String searchVisitorsByPhone(phone) =>
      "/api/v1/guest/autocomplete?phone=$phone";

  static String getAllCards = "/api/v1/card/";
  static String uploadCards = "/api/v1/card/";
  static String getACardByQrCode(String value) =>
      "/api/v1/card/by-qrcode?qrCode=$value";
  static String getACardBySerialNo(String value) =>
      "/api/v1/card/by-sno?sno=$value";
  static const String getLocations = "/api/v1/location/";
}

class ApiConstants {
  static String baseUrl = "https://paddie-api.volvrit.org";
  static String imageUrl = "https://paddie-api.volvrit.org/";

  ///Auth
  static String login = "/api/user/login";

  ///Profile
  static String profile = "/api/user/profile";

  ///Delivery
  static String allPurchaseRequest = "/api/transport/allpurchaserequest";

  ///QC
  static String createInitialQC = "/api/qccheck/create";
  static String getAllQC = "/api/qccheck/getallqccheck";
  static String submitFinalQC = "/api/finalqc/qc-check";

  ///Factory
  static String getAllFactory = "/api/factory/getallfactory";

  ///SubUser
  static String createSubUser = "/api/user/create";
  static String getSubUser = "/api/user/getsubuserbysuperuser";

  ///Notification
  static String getAllNotification = "/api/notification/notification";

}

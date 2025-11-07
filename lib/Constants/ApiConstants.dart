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
  static String updateQcStatus = '/api/qccheck/updatestatus/';
  static String getFinalQc = '/api/finalqc/getfinalqc/';

  ///Factory
  static String getAllFactory = "/api/factory/getallfactory";

  ///SubUser
  static String createSubUser = "/api/user/create";
  static String getSubUser = "/api/user/getsubuserbysuperuser";

  ///Notification
  static String getAllNotification = "/api/notification/notification";

  ///Billing
  static String getBillingData = "/api/billing/getallbilling";
  static String generateBilling = "/api/billing/generate";

  ///Sales
  static String getAllSalesLeadsForSuperUser = "/api/saleslead/getallsalesleads";

  ///Product
  static String getAllProduct = "/api/product/allproduct";
  static String createProduct = "/api/product/create";


    ///getAllLabourCharge
  static String getAllLabourCharge = "/api/labourcharge/getalllabourcharge";
  static String createLabourCharge = "/api/labourcharge/create";


    ///getAllLabourCharge
  static String getAllBroker = "/api/broker/all-brokers";

    ///Expense
  static String getAllExpense = "/api/expense/getallexpense";
  static String createExpense = "/api/expense/create";

  ///Profile
  static String getAttendance = "/api/worker/attandancerecord";

  ///Salary
  static String createSalary = "/api/salary/create";

}

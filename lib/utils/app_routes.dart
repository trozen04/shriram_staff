import 'package:flutter/material.dart';
import '../screens/CommonScreens/Notification/notification_screen.dart';
import '../screens/CommonScreens/Profile/profile_screen.dart';
import '../screens/CommonScreens/Report/report_screen.dart';
import '../screens/CommonScreens/Sales/create_sales_lead_screen.dart';
import '../screens/CommonScreens/Sales/sales_details_page.dart';
import '../screens/CommonScreens/Sales/sales_screen.dart';
import '../screens/CommonScreens/auth/login_screen.dart';
import '../screens/SubUser/Billing/billing_details.dart';
import '../screens/SubUser/Billing/billing_fill_details_screen.dart';
import '../screens/CommonScreens/BillingCommonScreen/billing_screen.dart';
import '../screens/SubUser/DetailsPage/after_qc_detail_page.dart';
import '../screens/SubUser/DetailsPage/delivery_qc_detail_page.dart';
import '../screens/SubUser/Delivery/delivery_qc_page.dart';
import '../screens/SubUser/Factory/factory_screen.dart';
import '../screens/SubUser/LoadingProducts/loading_product_screen.dart';
import '../screens/SubUser/QualityCheck/quality_check_submit_page.dart';
import '../screens/SubUser/WeightConfirmationPage/weight_confirmation_page.dart';
import '../screens/SuperUser/Attendance/attendance_screen.dart';
import '../screens/SuperUser/Attendance/mark_attendance_screen.dart';
import '../screens/SuperUser/BillingSuperUser/billing_details.dart';
import '../screens/SuperUser/BillingSuperUser/billing_fill_details_super_user.dart';
import '../screens/SuperUser/Broker/broker_detail_screen.dart';
import '../screens/SuperUser/Broker/broker_screen.dart';
import '../screens/SuperUser/Expense/expense_screen.dart';
import '../screens/SuperUser/Home/super_user_home_screen.dart';
import '../screens/SuperUser/InitialQC/initial_qc_approval_screen.dart';
import '../screens/SuperUser/InitialQC/initial_qc_screen.dart';
import '../screens/SuperUser/Labour/add_labour_charges_screen.dart';
import '../screens/SuperUser/Labour/labour_screen.dart';
import '../screens/SuperUser/Products/add_product_screen.dart';
import '../screens/SuperUser/Products/product_master_screen.dart';
import '../screens/SuperUser/Purchase/purchase_request_detail.dart';
import '../screens/SuperUser/Purchase/purchase_request_screen.dart';
import '../screens/SuperUser/Salary/salary_rollout_screen.dart';
import '../screens/SuperUser/Salary/salary_screen.dart';
import '../screens/SuperUser/SubUsers/create_subusers.dart';
import '../screens/SuperUser/SubUsers/staff_details.dart';
import '../screens/SuperUser/SubUsers/sub_users_list.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String deliveryPage = '/deliveryPage';
  static const String deliveryDetailPage = '/deliveryDetailPage';
  static const String afterQcDetailPage = '/afterQcDetailPage';
  static const String weightConfirmationPage = '/weightConfirmationPage';
  static const String qualityCheckSubmitPage = '/qualityCheckSubmitPage';
  static const String factoryScreen = '/factoryScreen';
  static const String salesScreen = '/salesScreen';
  static const String profileScreen = '/profileScreen';
  static const String loadingProductScreen = '/loadingProductScreen';
  static const String reportScreen = '/reportScreen';
  static const String billingScreen = '/billingScreen';
  static const String billingFillDetailsScreen = '/billingFillDetailsScreen';
  static const String billingDetailsScreen = '/billingDetailsScreen';
  static const String notificationScreen = '/notificationScreen';

  ///Super User Routes
  static const String superUserHomeScreen = '/superUserHomeScreen';
  static const String subUsersList = '/subUsersList';
  static const String createSubUserPage = '/createSubUserPage';
  static const String staffDetails = '/staffDetails';
  static const String attendanceScreen = '/attendanceScreen';
  static const String markAttendanceScreen = '/markAttendanceScreen';
  static const String initialQcScreen = '/initialQcScreen';
  static const String initialQcApprovalScreen = '/initialQcApprovalScreen';
  static const String createSalesLeadScreen = '/createSalesLeadScreen';
  static const String salesDetailScreen = '/salesDetailScreen';
  static const String billingFillDetailsSuperUser =
      '/billingFillDetailsSuperUser';
  static const String billingDetailScreenSuperUser =
      '/billingDetailScreenSuperUser';
  static const String expenseScreen = '/expenseScreen';
  static const String salaryScreen = '/salaryScreen';
  static const String salaryRolloutScreen = '/salaryRolloutScreen';
  static const String purchaseRequestScreen = '/purchaseRequestScreen';
  static const String purchaseRequestDetail = '/purchaseRequestDetail';
  static const String brokerScreen = '/brokerScreen';
  static const String brokerDetailScreen = '/brokerDetailScreen';
  static const String labourScreen = '/labourScreen';
  static const String addLabourChargesScreen = '/addLabourChargesScreen';
  static const String productMasterScreen = '/productMasterScreen';
  static const String addProductScreen = '/addProductScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _buildPageRoute(const LoginScreen(), settings);
      case deliveryPage:
        final isQC = settings.arguments as bool? ?? false;
        return _buildPageRoute(DeliveryQcPage(isQCPage: isQC), settings);


      case AppRoutes.deliveryDetailPage:
        final args = settings.arguments as Map<String, dynamic>;
        final data = args['data'];
        final bool isQcPage = args['isQcPage'] ?? false;

        return _buildPageRoute(
          DeliveryQcDetailPage(
            userData: data,
            isQcPage: isQcPage,
          ),
          settings,
        );
      case AppRoutes.afterQcDetailPage:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildPageRoute(
          AfterQcDetailPage(
            qcData: args['qcData'],
            userData: args['userData'],
          ),
          settings,
        );

      case AppRoutes.weightConfirmationPage:
        final data = settings.arguments;
        return _buildPageRoute(
          WeightConfirmationPage(userData: data),
          settings,
        );
      case AppRoutes.qualityCheckSubmitPage:
        final data = settings.arguments;
        return _buildPageRoute(
          QualityCheckSubmitPage(userData: data),
          settings,
        );
      case AppRoutes.factoryScreen:
        return _buildPageRoute(FactoryScreen(), settings);
      case AppRoutes.salesScreen:
        final bool isSuperUser = settings.arguments as bool? ?? false;
        return _buildPageRoute(SalesScreen(isSuperUser: isSuperUser), settings);

      case AppRoutes.profileScreen:
        final bool isSuperUser = settings.arguments as bool? ?? false;
        return _buildPageRoute(
          ProfileScreen(isSuperUser: isSuperUser),
          settings,
        );
      case AppRoutes.loadingProductScreen:
        final data = settings.arguments;
        return _buildPageRoute(LoadingProductScreen(userData: data), settings);
      case AppRoutes.reportScreen:
        final args = settings.arguments as Map?;
        return _buildPageRoute(
          ReportScreen(
            isSuperUser: args?['isSuperUser'] ?? false,
          ),
          settings,
        );

      case AppRoutes.billingScreen:
        final bool isSuperUser = settings.arguments as bool? ?? false;
        return _buildPageRoute(
          BillingScreen(isSuperUser: isSuperUser),
          settings,
        );
      case AppRoutes.billingFillDetailsScreen:
        final data = settings.arguments;
        return _buildPageRoute(
          BillingFillDetailsScreen(billingData: data),
          settings,
        );
      case AppRoutes.billingDetailsScreen:
        final data = settings.arguments;
        return _buildPageRoute(BillingDetails(billingData: data), settings);
      case notificationScreen:
        return _buildPageRoute(const NotificationScreen(), settings);

      /// Super User Screens
      case superUserHomeScreen:
        return _buildPageRoute(const SuperUserHomeScreen(), settings);
      case subUsersList:
        return _buildPageRoute(const SubUsersList(), settings);
      case createSubUserPage:
        final data = settings.arguments;
        return _buildPageRoute(CreateSubUserPage(subUserData: data), settings);
      case staffDetails:
        final data = settings.arguments;
        return _buildPageRoute(StaffDetails(subUserData: data), settings);
      case attendanceScreen:
        return _buildPageRoute(AttendanceScreen(), settings);
      case markAttendanceScreen:
        return _buildPageRoute(MarkAttendanceScreen(), settings);
      case initialQcScreen:
        return _buildPageRoute(InitialQcScreen(), settings);
      case initialQcApprovalScreen:
        final data = settings.arguments;
        return _buildPageRoute(InitialQcApprovalScreen(qcData: data), settings);
      case createSalesLeadScreen:
        return _buildPageRoute(CreateSalesLeadScreen(), settings);
      case salesDetailScreen:
        final data = settings.arguments;
        return _buildPageRoute(SalesDetailScreen(salesData: data), settings);
      case billingFillDetailsSuperUser:
        final data = settings.arguments;
        return _buildPageRoute(BillingFillDetailsSuperUser(billingData: data), settings);
      case billingDetailScreenSuperUser:
        final data = settings.arguments;
        return _buildPageRoute(BillingDetailScreen(billingData: data,), settings);

      case expenseScreen:
        return _buildPageRoute(ExpenseScreen(), settings);
      case salaryScreen:
        return _buildPageRoute(SalaryScreen(), settings);
      case salaryRolloutScreen:
        return _buildPageRoute(SalaryRolloutScreen(), settings);
      case purchaseRequestScreen:
        return _buildPageRoute(PurchaseRequestScreen(), settings);
      case purchaseRequestDetail:
        final data = settings.arguments;
        return _buildPageRoute(PurchaseRequestDetail(purchaseData: data,), settings);
      case brokerScreen:
        return _buildPageRoute(BrokerScreen(), settings);
      case brokerDetailScreen:
        final data = settings.arguments;
        return _buildPageRoute(BrokerDetailScreen(brokerData: data!), settings);
      case labourScreen:
        return _buildPageRoute(LabourScreen(), settings);
      case addLabourChargesScreen:
        return _buildPageRoute(AddLabourChargesScreen(), settings);
      case productMasterScreen:
        return _buildPageRoute(ProductMasterScreen(), settings);
      case addProductScreen:
        return _buildPageRoute(AddProductScreen(), settings);

      default:
        return _buildPageRoute(
          const LoginScreen(),
          settings,
        ); // Changed to DashboardScreen
    }
  }

  static PageRouteBuilder _buildPageRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, animation, secondaryAnimation) => page,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        const beginOffset = Offset(1.0, 0.0);
        const endOffset = Offset.zero;
        final tween = Tween(
          begin: beginOffset,
          end: endOffset,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
    );
  }
}

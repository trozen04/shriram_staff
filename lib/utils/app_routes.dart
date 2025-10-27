import 'package:flutter/material.dart';
import '../screens/CommonScreens/Notification/notification_screen.dart';
import '../screens/CommonScreens/Profile/profile_screen.dart';
import '../screens/CommonScreens/auth/login_screen.dart';
import '../screens/CommonScreens/auth/registration_screen.dart';
import '../screens/SubUser/Billing/billing_details.dart';
import '../screens/SubUser/Billing/billing_fill_details_screen.dart';
import '../screens/SubUser/Billing/billing_screen.dart';
import '../screens/SubUser/DetailsPage/delivery_qc_detail_page.dart';
import '../screens/SubUser/Delivery/delivery_qc_page.dart';
import '../screens/SubUser/Factory/factory_screen.dart';
import '../screens/SubUser/LoadingProducts/loading_product_screen.dart';
import '../screens/SubUser/QualityCheck/quality_check_submit_page.dart';
import '../screens/SubUser/Report/report_screen.dart';
import '../screens/SubUser/Sales/sales_screen.dart';
import '../screens/SubUser/WeightConfirmationPage/weight_confirmation_page.dart';
import '../screens/SuperUser/Home/super_user_home_screen.dart';
import '../screens/SuperUser/SubUsers/create_subusers.dart';
import '../screens/SuperUser/SubUsers/staff_details.dart';
import '../screens/SuperUser/SubUsers/sub_users_list.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String deliveryPage = '/deliveryPage';
  static const String deliveryDetailPage = '/deliveryDetailPage';
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

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
         return _buildPageRoute(const LoginScreen(), settings);
      case register:
        return _buildPageRoute(const RegistrationScreen(), settings);
      case deliveryPage:
        final isQC = settings.arguments as bool? ?? false;
        return _buildPageRoute(DeliveryQcPage(isQCPage: isQC), settings);


      case AppRoutes.deliveryDetailPage:
        final args = settings.arguments as Map<String, dynamic>;
        final data = args['data'];
        final isAfterQC = args['isAfterQC'] as bool? ?? false;
        final isPendingQC = args['isPendingQC'] as bool? ?? false;
        return _buildPageRoute(
            DeliveryQcDetailPage(userData: data, isAfterQC: isAfterQC, isPendingQC: isPendingQC,),
            settings
        );

      case AppRoutes.weightConfirmationPage:
        final data = settings.arguments;
        return _buildPageRoute(
            WeightConfirmationPage(userData: data,),
            settings
        );
      case AppRoutes.qualityCheckSubmitPage:
        final data = settings.arguments;
        return _buildPageRoute(
            QualityCheckSubmitPage(userData: data),
            settings
        );
      case AppRoutes.factoryScreen:
        return _buildPageRoute(FactoryScreen(),settings);
      case AppRoutes.salesScreen:
        return _buildPageRoute(SalesScreen(),settings);
      case AppRoutes.profileScreen:
        return _buildPageRoute(ProfileScreen(),settings);
      case AppRoutes.loadingProductScreen:
        final data = settings.arguments;
        return _buildPageRoute(LoadingProductScreen(userData: data),settings);
      case AppRoutes.reportScreen:
        final data = settings.arguments;
        return _buildPageRoute(ReportScreen(reportData: data),settings);
      case AppRoutes.billingScreen:
        return _buildPageRoute(BillingScreen(),settings);
      case AppRoutes.billingFillDetailsScreen:
        final data = settings.arguments;
        return _buildPageRoute(BillingFillDetailsScreen(billingData: data),settings);
      case AppRoutes.billingDetailsScreen:
        final data = settings.arguments;
        return _buildPageRoute(BillingDetails(billingData: data),settings);
      case notificationScreen:
        return _buildPageRoute(const NotificationScreen(), settings);

        /// Super User Screens
      case superUserHomeScreen:
        return _buildPageRoute(const SuperUserHomeScreen(), settings);
      case subUsersList:
        return _buildPageRoute(const SubUsersList(), settings);
      case createSubUserPage:
        final data = settings.arguments;
        return _buildPageRoute(CreateSubUserPage(subUserData: data,), settings);
      case staffDetails:
        final data = settings.arguments;
        return _buildPageRoute(StaffDetails(subUserData: data,), settings);


      default:
        return _buildPageRoute(const RegistrationScreen(), settings); // Changed to DashboardScreen
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
        final tween = Tween(begin: beginOffset, end: endOffset)
            .chain(CurveTween(curve: Curves.easeOutCubic));

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
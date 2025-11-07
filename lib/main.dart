import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/screens/CommonScreens/auth/login_screen.dart';
import 'package:shree_ram_staff/screens/SubUser/Home/home_screen.dart';
import 'package:shree_ram_staff/screens/SuperUser/home/super_user_home_screen.dart';
import 'package:shree_ram_staff/utils/app_routes.dart';
import 'package:shree_ram_staff/utils/pref_utils.dart';
import 'Bloc/AttendanceBloc/attendance_bloc.dart';
import 'Bloc/AuthBloc/auth_bloc.dart';
import 'Bloc/BillingBloc/billing_bloc.dart';
import 'Bloc/Broker/broker_bloc.dart';
import 'Bloc/ExpenseBloc/expense_bloc.dart';
import 'Bloc/FactoryBloc/factory_bloc.dart';
import 'Bloc/LabourBloc/labour_bloc.dart';
import 'Bloc/ProductBloc/product_bloc.dart';
import 'Bloc/ProfileBloc/profile_bloc.dart';
import 'Bloc/PurchaseRequest/purchase_request_bloc.dart';
import 'Bloc/QCBloc/qc_bloc.dart';
import 'Bloc/SalaryBloc/salary_bloc.dart';
import 'Bloc/SalesBloc/sales_bloc.dart';
import 'Bloc/SubUsers/subusers_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔒 Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 🧠 Initialize SharedPreferences
  await PrefUtils.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
        BlocProvider<PurchaseRequestBloc>(create: (_) => PurchaseRequestBloc()),
        BlocProvider<QcBloc>(create: (_) => QcBloc()),
        BlocProvider<FactoryBloc>(create: (_) => FactoryBloc()),
        BlocProvider<SubusersBloc>(create: (_) => SubusersBloc()),
        BlocProvider<BillingBloc>(create: (_) => BillingBloc()),
        BlocProvider<SalesBloc>(create: (_) => SalesBloc()),
        BlocProvider<ProductBloc>(create: (_) => ProductBloc()),
        BlocProvider<LabourBloc>(create: (_) => LabourBloc()),
        BlocProvider<BrokerBloc>(create: (_) => BrokerBloc()),
        BlocProvider<ExpenseBloc>(create: (_) => ExpenseBloc()),
        BlocProvider<AttendanceBloc>(create: (_) => AttendanceBloc()),
        BlocProvider<SalaryBloc>(create: (_) => SalaryBloc()),
      ],
      child: MaterialApp(
        title: 'Broker App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
        ),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
        home: const SplashScreen(),
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = PrefUtils.isLoggedIn();
    final String role = PrefUtils.getUserRole();

    if (isLoggedIn) {
      if (role == 'superuser') {
        return const SuperUserHomeScreen();
      } else {
        return const HomeScreen();
      }
    } else {
      return const LoginScreen();
    }
  }
}

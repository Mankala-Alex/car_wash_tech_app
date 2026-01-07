import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:my_new_app/app/bindings/dashboard/dashboard_bindings.dart';
import 'package:my_new_app/app/bindings/dashboard/service_history_binding.dart';
import 'package:my_new_app/app/bindings/profile/change_password_binding.dart';
import 'package:my_new_app/app/bindings/washing_flow/all_tasks_bindings.dart';
import 'package:my_new_app/app/bindings/washing_flow/car_status_bindings.dart';
import 'package:my_new_app/app/bindings/washing_flow/cust_location_bindings.dart';
import 'package:my_new_app/app/bindings/washing_flow/payment_screen_binding.dart';
import 'package:my_new_app/app/bindings/washing_flow/pre_task_checklist_bindings.dart';
import 'package:my_new_app/app/bindings/washing_flow/task_completed_bindings.dart';
import 'package:my_new_app/app/bindings/washing_flow/task_details_bindings.dart';
import 'package:my_new_app/app/views/dashboard/dashboard_view.dart';
import 'package:my_new_app/app/views/dashboard/service_history_view.dart';
import 'package:my_new_app/app/views/profile/change_password_view.dart';
import 'package:my_new_app/app/views/washing_flow/all_tasks_view.dart';
import 'package:my_new_app/app/views/washing_flow/car_status_view.dart';
import 'package:my_new_app/app/views/washing_flow/cust_location_view.dart';
import 'package:my_new_app/app/views/washing_flow/payment_screen_view.dart';
import 'package:my_new_app/app/views/washing_flow/pre_task_checklist_view.dart';
import 'package:my_new_app/app/views/washing_flow/task_completed_view.dart';
import 'package:my_new_app/app/views/washing_flow/task_details_view.dart';

import '../bindings/auth/lang_selection_binding.dart';
import '../bindings/auth/login_binding.dart';
import '../bindings/auth/otp_binding.dart';
import '../bindings/splash_screen_bindings.dart';
import '../views/auth/lang_selection_view.dart';
import '../views/auth/login_page_view.dart';
import '../views/auth/otp_screen_view.dart';
import '../views/splash_screen_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initialPage = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreenView(),
      binding: SplashScreenBindings(),
    ),
    GetPage(
      name: Routes.langeSelection,
      page: () => const LangSelectionView(),
      binding: LangSelectionBindings(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPageView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.otpPage,
      page: () => const OtpScreenView(),
      binding: OtpBinding(),
    ),

    //dashboard

    GetPage(
      name: Routes.dashboard,
      page: () => DashboardView(),
      binding: DashboardBindings(),
    ),

    //washing flow

    GetPage(
      name: Routes.alltasks,
      page: () => const AllTasksView(),
      binding: AllTasksBindings(),
    ),
    GetPage(
      name: Routes.custLocation,
      page: () => CustLocationView(),
      binding: CustLocationBindings(),
    ),
    GetPage(
      name: Routes.preTaskChecklist,
      page: () => const PreTaskChecklistView(),
      binding: PreTaskChecklistBindings(),
    ),
    GetPage(
      name: Routes.taskDetails,
      page: () => const TaskDetailsView(),
      binding: TaskDetailsBindings(),
    ),
    GetPage(
      name: Routes.carstatus,
      page: () => const CarStatusView(),
      binding: CarStatusBindings(),
    ),
    GetPage(
      name: Routes.paymentScreen,
      page: () => const PaymentScreenView(),
      binding: PaymentScreenBindings(),
    ),
    GetPage(
      name: Routes.taskCompleted,
      page: () => const TaskCompletedView(),
      binding: TaskCompletedBindings(),
    ),
    GetPage(
      name: Routes.changepassword,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: Routes.serviceHistory,
      page: () => const ServiceHistoryView(),
      binding: ServiceHistoryBinding(),
    ),
  ];
}

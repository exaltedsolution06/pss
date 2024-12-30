import 'package:get/get.dart';
import 'package:picturesourcesomerset/app/middlewares/auth_guard.dart';

import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/login_screen/bindings/login_screen_binding.dart';
import '../modules/login_screen/views/login_screen_view.dart';
import '../modules/register/bindings/consumer_register_binding.dart';
import '../modules/register/views/consumer_register_view.dart';
import '../modules/register/bindings/retailer_register_binding.dart';
import '../modules/register/views/retailer_register_view.dart';

import '../modules/forgot_screen/views/forgot_screen_view.dart';
import '../modules/otp_verification_screen/views/otp_verification_screen_view.dart';
import '../modules/reset_password_screen/views/reset_password_screen_view.dart';
import '../modules/otp_verification_screen/bindings/otp_verification_screen_binding.dart';
import '../modules/reset_password_screen/bindings/reset_password_screen_binding.dart';
import '../modules/forgot_screen/bindings/forgot_screen_binding.dart';

//import '../modules/register/views/terms_and_conditions_screen_view.dart';
//import '../modules/register/views/privacy_policy_screen_view.dart';
import '../modules/proflie_screen/bindings/proflie_screen_binding.dart';
import '../modules/proflie_screen/views/proflie_screen_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

import '../modules/Onboarding1/bindings/onboarding1_binding.dart';
import '../modules/Onboarding1/views/onboarding1_view.dart';


import 'package:picturesourcesomerset/app/modules/activity_screen/activity_screen_binding.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/activity_screen_view.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/faq_screen_view.dart';
//import 'package:picturesourcesomerset/app/modules/addpost_screen/bindings/addpost_screen_binding.dart';
//import 'package:picturesourcesomerset/app/modules/addpost_screen/views/addpost_screen_view.dart';
import 'package:picturesourcesomerset/app/modules/editpictre_screen/bindings/editpictre_screen_binding.dart';
import 'package:picturesourcesomerset/app/modules/editpictre_screen/views/editpictre_screen_view.dart';
import 'package:picturesourcesomerset/app/modules/live_screen/bindings/live_screen_binding.dart';
import 'package:picturesourcesomerset/app/modules/live_screen/views/live_screen_view.dart';
//import 'package:picturesourcesomerset/app/modules/postdetail_screen/postdetail_screen_binding.dart';
//import 'package:picturesourcesomerset/app/modules/postdetail_screen/postdetail_screen_view.dart';


import '../modules/addcard_screen/bindings/addcard_screen_binding.dart';
import '../modules/addcard_screen/views/addcard_screen_view.dart';
import '../modules/newpost_screen/bindings/newpost_screen_binding.dart';
import '../modules/newpost_screen/views/newpost_screen_view.dart';
import '../modules/editpost_screen/bindings/editpost_screen_binding.dart';
import '../modules/editpost_screen/views/editpost_screen_view.dart';
import '../modules/editprofile_screen/bindings/editprofile_screen_binding.dart';
import '../modules/editprofile_screen/views/editprofile_screen_view.dart';
import '../modules/filter_screen/bindings/filter_screen_binding.dart';
import '../modules/filter_screen/views/filter_screen_view.dart';
import '../modules/follow_screen/bindings/follow_screen_binding.dart';
import '../modules/follow_screen/views/follow_screen_view.dart';
import '../modules/view_proflie_screen/bindings/view_proflie_screen_binding.dart';
import '../modules/view_proflie_screen/views/view_proflie_screen_view.dart';
import '../modules/serach_screen/bindings/serach_screen_binding.dart';
import '../modules/serach_screen/views/serach_screen_view.dart';
import '../modules/notification_screen/bindings/notification_screen_binding.dart';
import '../modules/notification_screen/views/notification_screen_view.dart';
import '../modules/message_screen/bindings/message_screen_binding.dart';
import '../modules/message_screen/views/message_screen_view.dart';

//import 'package:picturesourcesomerset/app/modules/zegocloud/zim_chat_list_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [		
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => SplashScreenView(),
      binding: SplashScreenBinding(),
    ),	
    GetPage(
      name: _Paths.CONSUMER_REGISTER,
      page: () =>  ConsumerRegisterView(),
      binding: ConsumerRegisterBinding(),
    ),
	GetPage(
      name: _Paths.RETAILER_REGISTER,
      page: () =>  RetailerRegisterView(),
      binding: RetailerRegisterBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_SCREEN,
      page: () => LoginScreenView(),
      binding: LoginScreenBinding(),
    ),	
    GetPage(
      name: _Paths.FORGOT_SCREEN,
      page: () => ForgotScreenView(),
      binding: ForgotScreenBinding(),
    ),
	GetPage(
	  name: _Paths.OTP_VERIFICATION_SCREEN,
	  page: () {
		final String email = Get.parameters['email'] ?? ''; // Fetch the email parameter
		final String contextStr = Get.parameters['context'] ?? 'forgotPassword'; // Fetch the context parameter
		return OtpVerificationScreenView(email: email, context: contextStr);
	  },
	  binding: OtpVerificationScreenBinding(),
	),
	GetPage(
		name: _Paths.RESET_PASSWORD_SCREEN,
		page: () {
			final String email = Get.parameters['email'] ?? ''; // Fetch the email parameter
			return ResetPasswordScreenView(email: email);
		},
		binding: ResetPasswordScreenBinding(),
    ),
	/*GetPage(
      name: _Paths.TERMS_CONDITIONS_SCREEN,
      page: () =>  TermsAndConditionsScreenView(),
      binding: RegisterBinding(),
    ),
	GetPage(
      name: _Paths.PRIVACY_POLICY_SCREEN,
      page: () =>  PrivacyPolicyScreenView(),
      binding: RegisterBinding(),
    ),*/
    GetPage(
      name: _Paths.PROFLIE_SCREEN,
      page: () =>  ProflieScreenView(),
      binding: ProflieScreenBinding(),
	  middlewares: [AuthGuard()], // After Login
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
	  middlewares: [AuthGuard()], // After Login
    ),	
	GetPage(
      name: _Paths.NOTIFICATION_SCREEN,
      page: () => NotificationScreenView(),
      binding: NotificationScreenBinding(),
	  middlewares: [AuthGuard()], // After Login
    ),
	GetPage(
      name: _Paths.MESSAGE_SCREEN,
      page: () => MessageScreenView(),
      binding: MessageScreenBinding(),
	  middlewares: [AuthGuard()], // After Login
    ),
	/*GetPage(
      name: _Paths.ZIMKIT_MESSAGE_SCREEN,
      page: () => ZIMKitChatsListsPage(),
	  middlewares: [AuthGuard()], // After Login
    ),*/
    GetPage(
      name: _Paths.ONBOARDING1,
      page: () => Onboarding1View(),
      binding: Onboarding1Binding(),
    ),
    GetPage(
      name: _Paths.SERACH_SCREEN,
      page: () => SerachScreenView(),
      binding: SerachScreenBinding(),
	  middlewares: [AuthGuard()], // After Login
    ),
    GetPage(
		name: Routes.VIEW_PROFLIE_SCREEN,
		page: () {
			final args = Get.arguments as Map<String, dynamic>;
			return ViewProflieScreenView(userId: args['userId']); // Pass userId to the view
		},
		binding: ViewProflieScreenBinding(),
		middlewares: [AuthGuard()], // After Login
    ),
    GetPage(
      name: _Paths.FILTER_SCREEN,
      page: () => const FilterScreenView(),
      binding: FilterScreenBinding(),
	  middlewares: [AuthGuard()], // After Login
    ),
    GetPage(
      name: _Paths.FOLLOW_SCREEN,
      page: () => FollowScreenView(),
      binding: FollowScreenBinding(),
	  middlewares: [AuthGuard()], // After Login
    ),
	GetPage(
      name: _Paths.NEWPOST_SCREEN,
      page: () => NewpostScreenView(),
      binding: NewpostScreenBinding(),
	  middlewares: [AuthGuard()], // After Login
    ),
	GetPage(
		name: Routes.EDITPOST_SCREEN,
		page: () {
			final args = Get.arguments as Map<String, dynamic>;
			return EditpostScreenView(postId: args['postId']); // Pass userId to the view
		},
		binding: EditpostScreenBinding(),
		middlewares: [AuthGuard()], // After Login
    ),
	GetPage(
      name: _Paths.ADDCARD_SCREEN,
      page: () => AddcardScreenView(),
      binding: AddcardScreenBinding(),
	  middlewares: [AuthGuard()], // After Login
    ),
    GetPage(
      name: _Paths.EDITPROFILE_SCREEN,
      page: () => EditprofileScreenView(),
      binding: EditprofileScreenBinding(),
	  middlewares: [AuthGuard()], // After Login
    ),
    GetPage(
      name: _Paths.EDITPICTRE_SCREEN,
      page: () => EditpictreScreenView(),
      binding: EditpictreScreenBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVITY_SCREEN,
      page: () =>  ActivityScreenView(),
      binding: ActivityScreenBinding(),
	  middlewares: [AuthGuard()], // After Login
    ),
	
  ];
}

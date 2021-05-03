import 'package:flutter/material.dart';
import 'package:frontendWeb/services/userServices.dart';
import 'package:frontendWeb/src/pages/login.dart';
import 'package:frontendWeb/src/pages/pageNotFound.dart';
import 'package:frontendWeb/src/pages/register.dart';
import 'package:frontendWeb/src/pages/welcomePage.dart';
import 'package:frontendWeb/utils/app_routes.dart';
import 'package:frontendWeb/views/addAdmin/addAdmin_view.dart';
import 'package:frontendWeb/views/commentReportDetails/commentReportDetails_view.dart';
import 'package:frontendWeb/views/commentReports/commentReports_view.dart';
import 'package:frontendWeb/views/dashboard/dashboard_view.dart';
import 'package:frontendWeb/views/editProfile/edit_profile.dart';
import 'package:frontendWeb/views/home/home_view.dart';
import 'package:frontendWeb/views/homeInstitution/home_view_institution.dart';
import 'package:frontendWeb/views/institutionProfile/institution_profile_view.dart';
import 'package:frontendWeb/views/institutions/institutions_view.dart';
import 'package:frontendWeb/views/postReportDetails.dart/postReportDetails_view.dart';
import 'package:frontendWeb/views/postReports/postReports_view.dart';
import 'package:frontendWeb/views/recommended/recommended_view.dart';
import 'package:frontendWeb/views/userProfile/userProfile_view.dart';
import 'package:frontendWeb/views/users/users_view.dart';
import 'package:frontendWeb/views/verification/verification_view.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserService()),
      ],
      child: Consumer<UserService>(
        builder: (context, service, _) => MaterialApp(
          title: "Moj grad",
          theme: ThemeData(
            primarySwatch: Colors.lightGreen
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: service.isAuthorized ? ( service.isAdmin ? AppRoutes.dashboard : AppRoutes.home ) : AppRoutes.welcome,
          onUnknownRoute: (settings) => MaterialPageRoute(builder: (context) => PageNotFound()),
          routes: {
            AppRoutes.welcome: (context) => WelcomePage(),
            AppRoutes.login: (context) => Login(),
            AppRoutes.registration: (context) => RegistrationPage(),

            AppRoutes.dashboard: (context) => HomeView(DashboardView()),
            AppRoutes.users: (context) => HomeView(UsersView()),
            AppRoutes.institutionUsers: (context) => HomeView(InstitutionsView()),
            AppRoutes.postReports: (context) => HomeView(PostReportsView()),
            AppRoutes.commentReports: (context) => HomeView(CommentReportsView()),
            AppRoutes.editProfile: (context) => HomeView(EditProfileView()),
            AppRoutes.addAdmin: (context) => HomeView(AddAdminView()),
            AppRoutes.verification: (context) => HomeView(VerificationView()),
            AppRoutes.postReportDetails: (context) => HomeView(PostReportDetails()),
            AppRoutes.commentReportDetails: (context) => HomeView(CommentReportDetails()),
            AppRoutes.userDetails: (context) => HomeView(UserProfile()),
            AppRoutes.institutionDetails: (context) => HomeView(UserProfile()),

            AppRoutes.home: (context) => HomeViewInstitution(RecommendedView()),
            AppRoutes.profile: (context) => HomeViewInstitution(InstitutionProfile()),
            AppRoutes.editInstitutionProfile: (context) => HomeViewInstitution(EditProfileView()),
          },
          navigatorObservers: [routeObserver],
        ),
      ),
    );
  }
}

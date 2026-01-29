import 'package:go_router/go_router.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/dashboard/progress_timeline_screen.dart';
import '../screens/auth/login_screen.dart'; 
import '../screens/auth/register_screen.dart';
import '../screens/services/service_detail_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/change_password_screen.dart';
import '../screens/profile/notification_settings_screen.dart';
import '../screens/profile/help_support_screen.dart';
import '../screens/booking/booking_screen.dart';
import '../screens/booking/booking_detail_screen.dart';
import '../screens/notifications/notification_screen.dart';
import '../screens/vehicles/vehicles_screen.dart';
import '../providers/auth_provider.dart';

class AppRouter {
  static GoRouter getRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isLoggedIn = authProvider.isAuthenticated;
        final isLoggingIn = state.uri.toString() == '/login';
        final isRegistering = state.uri.toString() == '/register';
        
        // Redirect to login if not logged in and not accessing auth pages
        if (!isLoggedIn && !isLoggingIn && !isRegistering) {
          return '/login';
        }
        
        // Redirect to dashboard if logged in and trying to access auth pages
        if (isLoggedIn && (isLoggingIn || isRegistering)) {
          return '/';
        }
        
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/timeline/:projectId',
          builder: (context, state) {
            final projectId = state.pathParameters['projectId']!;
            return ProgressTimelineScreen(projectId: projectId);
          },
        ),
        GoRoute(
          path: '/service-detail/:type',
          builder: (context, state) {
            final type = state.pathParameters['type']!;
            final serviceData = state.extra as Map<String, dynamic>?;
            return ServiceDetailScreen(serviceType: type, serviceData: serviceData);
          },
        ),
        GoRoute(
          path: '/edit-profile',
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: '/booking',
          builder: (context, state) => const BookingScreen(),
        ),
        GoRoute(
          path: '/booking/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return BookingDetailScreen(projectId: id);
          },
        ),
        GoRoute(
          path: '/change-password',
          builder: (context, state) => const ChangePasswordScreen(),
        ),
        GoRoute(
          path: '/notification-settings',
          builder: (context, state) => const NotificationSettingsScreen(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationScreen(),
        ),
        GoRoute(
          path: '/vehicles',
          builder: (context, state) => const VehiclesScreen(),
        ),
        GoRoute(
          path: '/help',
          builder: (context, state) => const HelpSupportScreen(),
        ),
      ],
    );
  }
}


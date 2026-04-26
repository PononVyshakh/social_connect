// lib/core/routes/app_router.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/auth_wrapper.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/chat/presentation/screens/users_list_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_name_screen.dart';
import '../../features/profile/presentation/screens/edit_about_screen.dart';
import '../../features/profile/presentation/screens/edit_gender_screen.dart';
import 'route_names.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    redirect: _handleRedirect,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const AuthWrapper(),
      ),
      GoRoute(
        path: RouteNames.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RouteNames.otp,
        name: 'otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OtpScreen(
            mobileNumber: extra?['mobileNumber'] ?? '',
            isLogin: extra?['isLogin'] ?? true,
            gender: extra?['gender'],
            displayName: extra?['displayName'],
          );
        },
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return RegisterScreen(
            gender: extra?['gender'] ?? 'unknown',
            mobileNumber: extra?['mobileNumber'],
          );
        },
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return HomeScreen(
            mobileNumber: extra?['mobileNumber'],
            gender: extra?['gender'],
          );
        },
      ),
      GoRoute(
        path: RouteNames.chatScreen,
        name: 'chatScreen',
        builder: (context, state) => const ChatScreenWidget(),
      ),
      GoRoute(
        path: RouteNames.usersList,
        name: 'usersList',
        builder: (context, state) => const UsersListScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.editName,
        name: 'editName',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return EditNameScreen(
            currentName: extra?['currentName'] ?? '',
          );
        },
      ),
      GoRoute(
        path: RouteNames.editAbout,
        name: 'editAbout',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return EditAboutScreen(
            currentAbout: extra?['currentAbout'] ?? '',
          );
        },
      ),
      GoRoute(
        path: RouteNames.editGender,
        name: 'editGender',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return EditGenderScreen(
            currentGender: extra?['currentGender'] ?? 'other',
          );
        },
      ),
    ],
  );

  // Redirect logic for auth state
  static String? _handleRedirect(BuildContext context, GoRouterState state) {
    // Allow splash route to always be accessible
    if (state.matchedLocation == RouteNames.splash) {
      return null;
    }

    final user = FirebaseAuth.instance.currentUser;
    final isAuthRoute = state.matchedLocation.contains(RouteNames.welcome) ||
        state.matchedLocation.contains(RouteNames.otp) ||
        state.matchedLocation.contains(RouteNames.register);

    // If not logged in and trying to access protected route, redirect to splash
    if (user == null && !isAuthRoute) {
      return RouteNames.splash;
    }

    // Allow OTP route even if user is partially authenticated
    if (state.matchedLocation.contains(RouteNames.otp)) {
      return null;
    }

    // If logged in and trying to access auth routes (except OTP), stay on current page
    // (handled by splash/AuthWrapper)
    if (user != null && isAuthRoute) {
      return RouteNames.splash;
    }

    return null; // No redirect needed
  }

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
}

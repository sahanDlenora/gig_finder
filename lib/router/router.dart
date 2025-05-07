import 'package:flutter/material.dart';
import 'package:gig_finder/models/job_model.dart';
import 'package:gig_finder/views/auth_views/login.dart';
import 'package:gig_finder/views/auth_views/register.dart';
import 'package:gig_finder/views/auth_views/start.dart';
import 'package:gig_finder/views/main_screen.dart';
import 'package:gig_finder/views/main_views/job_screen.dart';
import 'package:gig_finder/views/sub_pages/about_me.dart';
import 'package:gig_finder/views/sub_pages/job_details.dart';
import 'package:gig_finder/views/responsive/mobile_layout.dart';
import 'package:gig_finder/views/responsive/responsive_layout.dart';
import 'package:gig_finder/views/responsive/web_layout.dart';
import 'package:go_router/go_router.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/",
    errorPageBuilder: (context, state) {
      return const MaterialPage(
        child: Scaffold(
          body: Center(
            child: Text("This page is not found"),
          ),
        ),
      );
    },
    routes: [
      //initial Route (Responsive Layout)
      GoRoute(
        name: "start",
        path: "/start",
        builder: (context, state) {
          return Start();
        },
      ),
      GoRoute(
        path: "/",
        name: "nav_layout",
        builder: (context, state) {
          return const ResponsiveLayoutScreen(
              MobileScreenLayout: MobileScreenLayout(),
              WebScreenLayout: WebScreenLayout());
        },
      ),

      //register Page
      GoRoute(
        name: "register",
        path: "/register",
        builder: (context, state) {
          return RegisterScreen();
        },
      ),

      // login Page
      GoRoute(
        name: "/login",
        path: "/login",
        builder: (context, state) {
          return LoginScreen();
        },
      ),

      //Main Screen
      GoRoute(
        name: "main screen",
        path: "/main-screen",
        builder: (context, state) {
          return MainScreen();
        },
      ),

      //Job details page
      GoRoute(
        path: "/job-details",
        name: "job-details",
        builder: (context, state) {
          final Job job = state.extra as Job;
          return JobDetails(
            job: job,
          );
        },
      ),

      // About Me Page
      GoRoute(
        name: "about-me",
        path: "/about-me",
        builder: (context, state) => EditProfileScreen(),
      ),
    ],
  );
}

import 'package:drrr/src/pages/browser/browser.dart';
import 'package:drrr/src/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      name: "home",
      path: '/',
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      name: "webBrowser",
      path: '/webBrowser',
      builder: (context, state) => Browser(
        title: state.uri.queryParameters['title'] ?? 'Web Browser',
        url: state.uri.queryParameters['url'] ?? 'https://www.google.com',
      ),
    ),
  ],
  errorBuilder: (context, state) => Text(state.error.toString()),
);

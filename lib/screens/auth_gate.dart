import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'login_screen.dart';
import 'home_shell.dart';

enum _AuthStage { home, login, signup }

/// Entry point widget: checks local auth state on launch and shows the
/// right screen — signup (no account yet), login (account exists but
/// logged out), or straight into the app (already logged in).
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _authService = AuthService();
  late Future<_AuthStage> _stageFuture;

  @override
  void initState() {
    super.initState();
    _stageFuture = _resolveStage();
  }

  Future<_AuthStage> _resolveStage() async {
    try {
      final loggedIn = await _authService.isLoggedIn();
      if (loggedIn) return _AuthStage.home;
      final hasAccount = await _authService.hasAccount();
      return hasAccount ? _AuthStage.login : _AuthStage.signup;
    } catch (_) {
      // If local storage can't be read (e.g. plugin not registered yet),
      // fail safe to signup rather than spinning forever.
      return _AuthStage.signup;
    }
  }

  void _refresh() => setState(() => _stageFuture = _resolveStage());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_AuthStage>(
      future: _stageFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: AppColors.paper,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        switch (snapshot.data!) {
          case _AuthStage.home:
            return HomeShell(onLoggedOut: _refresh);
          case _AuthStage.login:
            return LoginScreen(onAuthenticated: _refresh);
          case _AuthStage.signup:
            return SignupScreen(onAuthenticated: _refresh);
        }
      },
    );
  }
}

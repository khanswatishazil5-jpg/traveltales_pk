import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'home_shell.dart';

/// Entry point widget: checks local auth state on launch.
/// - Logged in already -> straight into the app.
/// - Otherwise -> Login screen (the only first stop). Signup is reached
///   from a link on the Login screen, not shown separately here.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _authService = AuthService();
  late Future<bool> _loggedInFuture;

  @override
  void initState() {
    super.initState();
    _loggedInFuture = _resolveLoggedIn();
  }

  Future<bool> _resolveLoggedIn() async {
    try {
      return await _authService.isLoggedIn();
    } catch (_) {
      // If local storage can't be read (e.g. plugin not registered yet),
      // fail safe to the login screen rather than spinning forever.
      return false;
    }
  }

  void _refresh() => setState(() {
        _loggedInFuture = _resolveLoggedIn();
      });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loggedInFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: AppColors.paper,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data == true) {
          return HomeShell(onLoggedOut: _refresh);
        }
        return LoginScreen(onAuthenticated: _refresh);
      },
    );
  }
}

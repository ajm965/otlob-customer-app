import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthSession extends ChangeNotifier {
  AuthSession({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    _subscription = _firebaseAuth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  final FirebaseAuth _firebaseAuth;
  late final StreamSubscription<User?> _subscription;
  User? _user;

  bool get isSignedIn => _user != null;

  User? get currentUser => _user;

  Future<String?> getIdToken({bool forceRefresh = false}) async {
    final User? user = _user ?? _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }
    return user.getIdToken(forceRefresh);
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}

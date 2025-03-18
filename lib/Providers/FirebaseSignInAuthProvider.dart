import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nofap/Reposoteries/FirebaseSignInAuthRepo.dart';

class FirebaseSignInAuthProvider with ChangeNotifier {
  final Firebasesigninauthrepo _authRepository;
  User? _user;

  bool _isLoading = false;
  //FirebaseSignInAuthProvider();

  User? get user => _user;
  bool get isLoading => _isLoading;

  FirebaseSignInAuthProvider(this._authRepository) {
    _checkUser();
  }

  Future<void> _checkUser() async {
    _user = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _user = await _authRepository.signInWithGoogle();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    _user = null;
    notifyListeners();
  }
}

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Register method for Firebase, returns null if User is unable to register
  Future<dynamic> register(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      return e;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Sign in method for Firebase, returns null if User is unable to log in
  Future<dynamic> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      return e;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Sign out method for Firebase
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // On auth state change stream
  Stream<User?> get userStream {
    return _firebaseAuth.userChanges();
  }

  // Retrieves the latest User profile
  void reloadUser() {
    if (_firebaseAuth.currentUser != null) {
      _firebaseAuth.currentUser!.reload();
    }
  }

  // Resends verification email
  void resendVerificationEmail() {
    if (_firebaseAuth.currentUser != null) {
      _firebaseAuth.currentUser!.sendEmailVerification();
    }
  }

  //Checks if user is verified
  bool isVerified() {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      return user.emailVerified;
    }

    return false;
  }

  // Get the current user
  User? get user {
    return _firebaseAuth.currentUser;
  }
}

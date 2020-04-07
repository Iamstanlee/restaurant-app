import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fgrestaurant/api/firebase.dart';
import 'package:fgrestaurant/api/google_auth.dart';
import 'package:fgrestaurant/data/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthBloc with ChangeNotifier {
  User _currentUser = User();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Firebase firebase = new Firebase(path: 'users');
  String _verificationId;
  String get verificationId => _verificationId;
  User get currentUser => _currentUser;
  set currentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  set verificationId(String id) {
    _verificationId = id;
    notifyListeners();
  }

  void getUser(String uid) {
    currentUser = User(uid: uid);
    getUserStream(uid).listen((DocumentSnapshot snapshot) {
      User user = User.fromMap(snapshot.data);
      currentUser = user;
      // User.toLocalStorage(currentUser);
    });
  }

  Stream<DocumentSnapshot> getUserStream(String uid) {
    return firebase.getDocumentById(uid).asStream();
  }

  void setUser(String uid, {@required User user}) async {
    Map<String, dynamic> document = User.toMap(user);
    await firebase.setDocument(uid, document).then((_) {
      currentUser = User.fromMap(document);
      // User.toLocalStorage(currentUser);
    });
  }

  void signInWithPassword(Map signInInfo,
      {@required Function onDone, Function(dynamic error) onError}) async {
    try {
      var res = await _firebaseAuth.signInWithEmailAndPassword(
          email: signInInfo['email'], password: signInInfo['password']);
      Stream<DocumentSnapshot> userStream = getUserStream(res.user.uid);
      userStream.listen((DocumentSnapshot snapshot) {
        User user = User.fromMap(snapshot.data);
        currentUser = user;
        // User.toLocalStorage(currentUser);
      });
      onDone();
    } catch (error) {
      onError(error);
    }
  }

  /// handles signIn from google auth provider takes [onDone] & [onError] params
  void signInWithGoogle(
      {@required Function(User user) onDone,
      @required Function(dynamic error) onError}) async {
    FirebaseUser user = await google(onError: onError);
    if (user != null) {
      await firebase
          .getDocumentById(user.uid)
          .then((DocumentSnapshot documentSnapshot) async {
        if (!documentSnapshot.exists) {
          User newUser = new User(
              name: user.displayName,
              email: user.email,
              phone: user.phoneNumber,
              uid: user.uid,
              verified: false,
              restaurantRegistered: false);
          await documentSnapshot.reference.setData(User.toMap(newUser));
          currentUser = newUser;
        } else {
          currentUser = User.fromMap(documentSnapshot.data);
        }
        onDone(currentUser);
      }).catchError((err) {
        print('**Error Signing In -> $err**');
        onError(err);
      });
    }
  }

  /// verify phone [onDone] is called when verification is successful and [onError] otherwise
  void verifyPhone(
      {String number, Map signUpInfo, Function onDone, Function onError}) {
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: number,
        timeout: Duration(seconds: 60),
        verificationFailed: (AuthException authException) {
          verificationFailed(authException, onError: onError);
        },
        verificationCompleted: (AuthCredential credential) {
          verificationCompleted(credential, signUpInfo,
              onDone: onDone, onError: onError);
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  verificationCompleted(AuthCredential credential, signUpInfo,
      {Function onDone, Function onError}) async {
    try {
      var res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: signUpInfo['email'], password: signUpInfo['password']);
      var linkedRes = await res.user.linkWithCredential(credential);
      signUpInfo['uid'] = linkedRes.user.uid;
      signUpInfo['restaurantRegistered'] = false;
      signUpInfo['verified'] = false;
      setUser(linkedRes.user.uid, user: User.fromMap(signUpInfo));
      onDone();
    } catch (error) {
      onError(error);
    }
  }

  /// called when phone verification fails returns [onError] with the error message
  verificationFailed(AuthException authException, {Function onError}) {
    onError(authException.message);
  }

  /// called after the verification SMS is sent from firebase, set the [verificationId] for verification
  void codeSent(String id, [int forceResentToken]) {
    verificationId = id;
  }

  void codeAutoRetrievalTimeout(String code) {}

  /// this is called when the phone doesnt auto-get the verification SMS
  void signInWithPhoneNumber(String smsCode, Map signUpInfo,
      {Function onDone, Function(dynamic error) onError}) async {
    try {
      AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: smsCode);
      var res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: signUpInfo['email'], password: signUpInfo['password']);
      var linkedRes = await res.user.linkWithCredential(credential);
      signUpInfo['uid'] = linkedRes.user.uid;
      signUpInfo['restaurantRegistered'] = false;
      signUpInfo['verified'] = false;
      setUser(linkedRes.user.uid, user: User.fromMap(signUpInfo));
      onDone();
    } catch (error) {
      onError(error);
    }
  }

  /// signOut the currently signedIn user
  void signOut({Function onDone}) {
    _firebaseAuth.signOut().then((emptyUser) {
      onDone();
    });
  }
}

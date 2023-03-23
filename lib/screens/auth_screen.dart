import 'package:chatter/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const dbAttrUserName = 'username';
  static const dbAttrEmail = 'email';

  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        isLoading: _isLoading,
        onSubmit: _submitAuthForm,
      ),
    );
  }

  void _submitAuthForm(
      {required String email,
      required String password,
      required String userName,
      required BuildContext ctx,
      required FormType type}) async {
    setState(() {
      _isLoading = true;
    });
    type == FormType.login
        ? _login(
            email: email,
            password: password,
            onFirebaseError: (err) {
              _handleFirebaseError(err, ctx);
            },
          )
        : _signup(
            email: email,
            userName: userName,
            password: password,
            onFirebaseError: (err) {
              _handleFirebaseError(err, ctx);
            },
          );
  }

  void _login({
    required String email,
    required String password,
    required Function(FirebaseException) onFirebaseError,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (err) {
      onFirebaseError(err);
    } catch (err) {
      print(err);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _signup({
    required String email,
    required String userName,
    required String password,
    required Function(FirebaseException) onFirebaseError,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await _store.collection('users').doc(credential.user!.uid).set({
          dbAttrUserName: userName,
          dbAttrEmail: email,
        });
      }
    } on FirebaseAuthException catch (err) {
      onFirebaseError(err);
    } catch (err) {
      print(err);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleFirebaseError(FirebaseException err, BuildContext ctx) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(
        err.message ?? 'An error occurred, please check credentials.',
      ),
      backgroundColor: Theme.of(ctx).errorColor,
    ));
  }
}

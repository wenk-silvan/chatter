import 'dart:io';

import 'package:chatter/firebase_util.dart';
import 'package:chatter/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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
      required File? image,
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
              FirebaseUtil.showFirebaseError(err, ctx);
            },
          )
        : _signup(
            email: email,
            userName: userName,
            password: password,
            image: image!,
            onFirebaseError: (err) {
              FirebaseUtil.showFirebaseError(err, ctx);
            },
          );
  }

  void _login({
    required String email,
    required String password,
    required Function(FirebaseException) onFirebaseError,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
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
    required File image,
    required Function(FirebaseException) onFirebaseError,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        final downloadUrl =
            await _addUserImageToStorage(credential.user!.uid, image);
        await _addUserDataToStore(
            credential.user!.uid, userName, email, downloadUrl);
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

  Future<String> _addUserImageToStorage(String uid, File image) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('chatter/user_image')
        .child('$uid.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  Future _addUserDataToStore(
      String uid, String name, String email, String imageUrl) {
    return _store.collection(FirebaseUtil.colUsers).doc(uid).set({
      FirebaseUtil.attrUserName: name,
      FirebaseUtil.attrEmail: email,
      FirebaseUtil.attrImageUrl: imageUrl,
    });
  }
}

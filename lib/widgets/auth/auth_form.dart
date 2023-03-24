import 'dart:io';

import 'package:chatter/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({required this.isLoading, required this.onSubmit, super.key});

  final bool isLoading;
  final void Function({
    required String email,
    required String password,
    required String userName,
    required File? image,
    required BuildContext ctx,
    required FormType type,
  }) onSubmit;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

enum FormType { login, signup }

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userPassword = '';
  var _userName = '';
  var _formType = FormType.login;
  File? _userImageFile;

  void _onImagePicked(File image) {
    _userImageFile = image;
  }

  void _toggleFormType() {
    setState(() {
      _formType =
          _formType == FormType.login ? FormType.signup : FormType.login;
    });
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && _isSignup()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please pick an image.'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState?.save();
      widget.onSubmit(
        email: _userEmail.trim(),
        password: _userPassword.trim(),
        userName: _userName.trim(),
        image: _userImageFile,
        ctx: context,
        type: _formType,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isSignup()) UserImagePicker(_onImagePicked),
                  emailFormField(),
                  if (_isSignup()) userNameFormField(),
                  passwordFormField(),
                  const SizedBox(height: 12),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading) ...[
                    loginButton(),
                    insteadButton(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget emailFormField() {
    return TextFormField(
      key: const ValueKey('email'),
      validator: (value) {
        return value == null || value.isEmpty || !value.contains('@')
            ? 'Please enter a valid email address.'
            : null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email address',
      ),
      onSaved: (value) {
        _userEmail = value ?? _userEmail;
      },
    );
  }

  Widget userNameFormField() {
    return TextFormField(
      key: const ValueKey('username'),
      validator: (value) {
        return value == null || value.isEmpty || value.length < 4
            ? 'Please enter at least 4 characters.'
            : null;
      },
      decoration: const InputDecoration(labelText: 'Username'),
      onSaved: (value) {
        _userName = value ?? _userEmail;
      },
    );
  }

  Widget passwordFormField() {
    return TextFormField(
      key: const ValueKey('password'),
      validator: (value) {
        return value == null || value.isEmpty || value.length < 7
            ? 'Password must be at least 7 characters long.'
            : null;
      },
      obscureText: true,
      onSaved: (value) {
        _userPassword = value ?? _userPassword;
      },
      decoration: const InputDecoration(labelText: 'Password'),
    );
  }

  Widget loginButton() {
    return FilledButton(
      onPressed: _trySubmit,
      child: Text(_isSignup() ? 'Signup' : 'Login'),
    );
  }

  Widget insteadButton() {
    return TextButton(
      onPressed: _toggleFormType,
      child:
          Text(_isSignup() ? 'I already have an account' : 'Create an account'),
    );
  }

  _isSignup() {
    return _formType == FormType.signup;
  }
}

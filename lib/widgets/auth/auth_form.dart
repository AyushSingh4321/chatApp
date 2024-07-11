import 'dart:ffi';
import 'dart:io';
import '../pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this._isLoading);
  final bool _isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userImageFile;
  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!_isLogin && _userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image...'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail,
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: _isLogin ? 120 : 70,
        ),
        Center(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(10),
            child: Text(
              _isLogin ? 'Welcome Back...' : 'Welcome...',
              style: TextStyle(
                fontSize: _isLogin ? 47 : 60,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
                // fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Center(
          child: Card(
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_isLogin) UserImagePicker(_pickedImage),
                      TextFormField(
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
                        key: ValueKey('email'),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email address',
                        ),
                        onSaved: (value) {
                          _userEmail = value!;
                        },
                      ),
                      if (!_isLogin)
                        TextFormField(
                            autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: false,
                          key: ValueKey('username'),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return 'Please enter at least 4 characters';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Username',
                          ),
                          onSaved: (value) {
                            _userName = value!;
                          },
                        ),
                      TextFormField(
                        key: ValueKey('password'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return 'Password must be atleast 7 characters long.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                        ),
                        onSaved: (value) {
                          _userPassword = value!;
                        },
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      if (widget._isLoading) CircularProgressIndicator(),
                      if (!widget._isLoading)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink),
                          child: Text(_isLogin ? 'Login' : 'SignUp',
                              style: TextStyle(color: Colors.white)),
                          onPressed: _trySubmit,
                        ),
                      if (!widget._isLoading)
                        TextButton(
                          child: Text(_isLogin
                              ? 'Create new account'
                              : 'I already have an account'),
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

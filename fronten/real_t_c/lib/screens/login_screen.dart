// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'chat_screen.dart';

class _UIConstants {
  static const double maxWidth = 400.0;
  static const double horizontalPadding = 24.0;
  static const double verticalPadding = 16.0;
  static const double formSpacing = 24.0;
  static const double headerSpacing = 32.0;
  static const double borderRadius = 8.0;
  static const double headerFontSize = 28.0;
  static const double buttonFontSize = 16.0;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // The `?.` operator handles the case where currentState is null.
    // The `?? false` ensures we have a non-nullable boolean.
    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      return;
    }

    final username = _usernameController.text.trim();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ChatScreen(username: username)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _UIConstants.maxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _UIConstants.horizontalPadding,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  const SizedBox(height: _UIConstants.headerSpacing),
                  _buildUsernameTextField(),
                  const SizedBox(height: _UIConstants.formSpacing),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Welcome to Chat',
      style: TextStyle(
        fontSize: _UIConstants.headerFontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildUsernameTextField() {
    return TextFormField(
      controller: _usernameController,
      decoration: const InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your username';
        }
        return null; // Return null when the input is valid.
      },
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _submitForm(),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: _UIConstants.verticalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_UIConstants.borderRadius),
          ),
        ),
        child: const Text(
          'Join Chat',
          style: TextStyle(fontSize: _UIConstants.buttonFontSize),
        ),
      ),
    );
  }
}

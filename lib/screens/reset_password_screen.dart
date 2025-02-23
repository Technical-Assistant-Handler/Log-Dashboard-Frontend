import 'package:flutter/material.dart';
import '../services/backend_service.dart';
import '../utils/colour_theme.dart';
import '../utils/text_utils.dart';
import '../widgets/login_button.dart';
import '../widgets/login_form_field.dart';
import '../widgets/popup_box_widget.dart';
import '../widgets/background_widget.dart';
import '../widgets/heading_widget.dart';
import '../widgets/logo_widget.dart';
import 'login_screen.dart'; // Import the login screen

class ResetPasswordScreen extends StatefulWidget {
  final String tpNumber;

  ResetPasswordScreen({required this.tpNumber});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpBox(
            title: 'Missing Information',
            message: 'Please enter both password fields.',
            icon: Icons.warning,
            iconColor: Colors.orange,
          );
        },
      );
      return;
    }

    if (password != confirmPassword) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpBox(
            title: 'Passwords Do Not Match',
            message: 'The passwords you entered do not match.',
            icon: Icons.error,
            iconColor: Colors.red,
          );
        },
      );
      return;
    }

    if (!_isPasswordValid(password)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpBox(
            title: 'Invalid Password',
            message:
                'Password must be 8-12 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character.',
            icon: Icons.error,
            iconColor: Colors.red,
          );
        },
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Call the backend service to reset the password
    final result = await update_password(widget.tpNumber, password);
    setState(() {
      _isLoading = false;
    });
    if (result['status']) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpBox(
            title: 'Password Reset Successful',
            message:
                'Your password has been reset successfully. You can now log in with your new password.',
            icon: Icons.check_circle,
            iconColor: Colors.green,
            onClosed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpBox(
            title: 'Password Reset Failed',
            message: result['message'],
            icon: Icons.error,
            iconColor: Colors.red,
          );
        },
      );
    }
  }

  bool _isPasswordValid(String password) {
    final passwordPattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,12}$';
    final regExp = RegExp(passwordPattern);
    return regExp.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final containerWidth = screenSize.width * 0.6;
    final containerHeight = screenSize.height * 0.5;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundWidget(
            child: Center(
              child: Column(
                children: [
                  HeadingWidget(topPadding: screenSize.height * 0.05),
                  Container(
                    width: containerWidth,
                    height: containerHeight,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      color: ColorTheme.boxColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextUtil.getTextWidget(
                          'Reset Password',
                          TextStyleType.mainHeading,
                          color: ColorTheme.textColorPrimary,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        LoginFormField(
                          controller: _passwordController,
                          label: 'New Password',
                          icon: Icons.lock,
                          obscureText: true,
                          styleType: TextStyleType.loginFormField,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        LoginFormField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          icon: Icons.lock,
                          obscureText: true,
                          styleType: TextStyleType.loginFormField,
                        ),
                        SizedBox(height: screenSize.height * 0.03),
                        _isLoading
                            ? CircularProgressIndicator()
                            : LoginButton(
                                onPressed: _resetPassword,
                                label: 'Reset Password',
                                buttonColor: ColorTheme.buttonColor,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          LogoWidget(),
        ],
      ),
    );
  }
}

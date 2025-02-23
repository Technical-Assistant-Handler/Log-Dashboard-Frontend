import 'dart:async';

import 'package:flutter/material.dart';
import '../services/backend_service.dart'; // Import the backend service
import '../utils/colour_theme.dart';
import '../utils/text_utils.dart';
import '../widgets/background_widget.dart';
import '../widgets/heading_widget.dart';
import '../widgets/login_button.dart';
import '../widgets/login_form_field.dart';
import '../widgets/logo_widget.dart';
import '../widgets/popup_box_widget.dart';
import 'reset_password_screen.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  @override
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final TextEditingController _tpNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String? _otp;
  bool _otpSent = false;
  bool _isLoading = false;
  int _remainingTime = 0; // in seconds

  // Timer function
  late final Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (_tpNumberController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpBox(
            title: 'Missing Information',
            message: 'Please Enter Your TP Number.',
            icon: Icons.warning,
            iconColor: Colors.orange,
          );
        },
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Generate OTP using backend service
    final result = await generate_otp(_tpNumberController.text);

    if (result['status']) {
      setState(() {
        _otp = result['otp'];
        _otpSent = true;
        _remainingTime = 60; // 1 minute countdown
        _isLoading = false;
      });

      // Start the countdown timer
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainingTime > 0) {
          setState(() {
            _remainingTime--;
          });
        } else {
          _timer.cancel();
        }
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpBox(
            title: 'OTP Sent',
            message:
                'A One-Time Password (OTP) has been sent to your registered email address.',
            icon: Icons.check_circle,
            iconColor: Colors.green,
          );
        },
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpBox(
            title: 'Error',
            message: result['message'],
            icon: Icons.error,
            iconColor: Colors.red,
          );
        },
      );
    }
  }

  Future<void> _verifyOTP() async {
    setState(() {
      _isLoading = true;
    });

    if (_otpController.text == _otp) {
      setState(() {
        _isLoading = false;
      });
      // Navigate to the reset password screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResetPasswordScreen(tpNumber: _tpNumberController.text),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpBox(
            title: 'Invalid OTP',
            message: 'The OTP you entered is incorrect.',
            icon: Icons.error,
            iconColor: Colors.red,
          );
        },
      );
    }
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
                          'Recover Password',
                          TextStyleType.mainHeading,
                          color: ColorTheme.textColorPrimary,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        LoginFormField(
                          controller: _tpNumberController,
                          label: 'TP Number',
                          icon: Icons.person,
                          styleType: TextStyleType.loginFormField,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        if (_otpSent) ...[
                          LoginFormField(
                            controller: _otpController,
                            label: 'Enter OTP',
                            icon: Icons.lock,
                            styleType: TextStyleType.loginFormField,
                          ),
                          SizedBox(height: screenSize.height * 0.01),
                          Text(
                            'OTP Sent To Your Registered Email. You Have $_remainingTime Seconds Left.',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: screenSize.width * 0.015),
                          ),
                          SizedBox(height: screenSize.height * 0.03),
                          _isLoading
                              ? CircularProgressIndicator()
                              : LoginButton(
                                  onPressed: _remainingTime > 0
                                      ? () {
                                          _verifyOTP(); // Call async function
                                        }
                                      : () {}, // Provide an empty function instead of null
                                  label: 'Verify OTP',
                                  buttonColor: _remainingTime > 0
                                      ? ColorTheme.buttonColor // Normal color
                                      : ColorTheme
                                          .buttonDisabledColor, // Disabled color
                                ),
                          if (_remainingTime == 0)
                            TextButton(
                              onPressed: () {
                                _sendOTP(); // Call async function
                              },
                              child: Text(
                                'Resend OTP',
                                style: TextStyle(
                                    color: ColorTheme.textColorPrimary),
                              ),
                            ),
                        ] else ...[
                          _isLoading
                              ? CircularProgressIndicator()
                              : LoginButton(
                                  onPressed: () {
                                    _sendOTP(); // Call async function
                                  },
                                  label: 'Send OTP',
                                  buttonColor: ColorTheme.buttonColor,
                                ),
                        ],
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/backend_service.dart';
import '../utils/colour_theme.dart';
import '../utils/text_utils.dart';
import '../widgets/background_widget.dart';
import '../widgets/login_button.dart';
import '../widgets/logout_button.dart';
import '../widgets/login_form_field.dart';
import '../widgets/logged_in_table.dart';
import '../widgets/popup_box_widget.dart';
import '../widgets/heading_widget.dart';
import '../widgets/logo_widget.dart';
import 'password_recover_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _tpNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isLoggingOut = false;
  final GlobalKey<LoggedInTableState> _tableKey =
      GlobalKey<LoggedInTableState>();

  Future<void> _login() async {
    if (_tpNumberController.text.isEmpty || _passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpBox(
            title: 'Missing Information',
            message: 'Please enter both TP Number and Password.',
            icon: Icons.warning,
            iconColor: Colors.orange,
          );
        },
      );
      return;
    }
    if (_tableKey.currentState!
        .getFirstColumnValues()
        .contains(_tpNumberController.text)) {
      // Show Dialog if TP Number already exists
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpBox(
            title: 'Existing Login Detected',
            message:
                '${_tpNumberController.text} Is Already Logged In. Please Log Out Before Attempting To Log In Again.',
            icon: Icons.check_circle,
            iconColor: Colors.blue,
          );
        },
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });

    // Call the authentication function and get the result
    final result = await authentication(
      _tpNumberController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['status']) {
      // If authentication is successful, use the returned username
      final username = result['username'] ?? "User Name";

      final now = DateTime.now();
      final formattedTime = DateFormat('hh:mm a').format(now);
      _tableKey.currentState?.addNewRow(
        _tpNumberController.text,
        username,
        formattedTime, // Current time
      );

      _tpNumberController.clear();
      _passwordController.clear();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpBox(
            title: 'Login Failed',
            message: 'Incorrect Username Or Password. Please Try Again.',
            icon: Icons.error,
            iconColor: Colors.red, // Red color for errors
          );
        },
      );
      return;
    }
  }

  Future<void> _logout() async {
    if (_tableKey.currentState?.selectedRowIndex == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpBox(
            title: 'No Selection Made',
            message: 'Please Select A Row Before Attempting To Log Out.',
            icon: Icons.check_circle,
            iconColor: Colors.blue,
          );
        },
      );
      return;
    }

    setState(() {
      _isLoggingOut = true;
    });
    // Get the TP number from the selected row
    final tpNumber = _tableKey.currentState
        ?.getFirstColumnValues()[_tableKey.currentState!.selectedRowIndex!];

    // Ensure tpNumber is not null before calling the logout function
    if (tpNumber != null) {
      // Call the logout function from backend_service.dart
      final result = await logout(tpNumber);

      setState(() {
        _isLoggingOut = false;
      });

      if (result['status']) {
        _tableKey.currentState
            ?.deleteRow(_tableKey.currentState!.selectedRowIndex!);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopUpBox(
              title: 'Logout Successful',
              message: 'You Have Been Logged Out Successfully.',
              icon: Icons.check_circle,
              iconColor: Colors.green,
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopUpBox(
              title: 'Logout Failed',
              message: 'Failed To Logout. Please Try Again.',
              icon: Icons.error,
              iconColor: Colors.red,
            );
          },
        );
      }
    } else {
      setState(() {
        _isLoggingOut = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;
    final containerWidth = screenSize.width * 0.28; // 28% of screen width
    final containerHeight = screenSize.height * 0.6; // 60% of screen height

    return Scaffold(
      body: Stack(
        children: [
          BackgroundWidget(
            child: Center(
              child: Column(
                children: [
                  HeadingWidget(topPadding: screenSize.height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: SizedBox()), // Add space on the left side
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
                              'Login',
                              TextStyleType.mainHeading,
                              color: ColorTheme.textColorPrimary,
                            ),
                            SizedBox(
                                height: screenSize.height *
                                    0.02), // 2% of screen height
                            LoginFormField(
                              controller: _tpNumberController,
                              label: 'TP Number',
                              icon: Icons.person,
                              styleType: TextStyleType.loginFormField,
                            ),
                            SizedBox(
                                height: screenSize.height *
                                    0.02), // 2% of screen height
                            LoginFormField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock,
                              obscureText: true,
                              styleType: TextStyleType.loginFormField,
                            ),
                            SizedBox(
                                height: screenSize.height *
                                    0.03), // 3% of screen height
                            _isLoading
                                ? CircularProgressIndicator()
                                : LoginButton(
                                    onPressed: _login,
                                    label: 'Login',
                                    buttonColor: ColorTheme.loginButtonColor,
                                  ),
                            SizedBox(
                                height: screenSize.height *
                                    0.02), // 2% of screen height
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PasswordRecoveryScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forget Password? Click here...',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: screenSize.width * 0.05), // 5% of screen width
                      Container(
                        width: containerWidth *
                            1.25, // Adjusted for layout balance
                        height: containerHeight,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: ColorTheme.boxColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: LoggedInTable(
                                key: _tableKey,
                                initialData: {},
                              ),
                            ),
                            SizedBox(
                                height: screenSize.height *
                                    0.02), // 2% of screen height
                            _isLoggingOut
                                ? CircularProgressIndicator()
                                : LogoutButton(
                                    onPressed: _logout,
                                  ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: SizedBox()), // Add space on the right side
                    ],
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

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Center(child: Text('Welcome to the Dashboard!')),
    );
  }
}

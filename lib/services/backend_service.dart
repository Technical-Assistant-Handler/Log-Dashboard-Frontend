import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

String ip_adress = "127.0.0.1";

Future<Map<String, dynamic>> authentication(
  String inputTpnumber,
  String inputPassword,
) async {
  try {
    final response = await http.post(
      Uri.parse('http://$ip_adress:8000/authenticate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tpnumber': inputTpnumber,
        'password': inputPassword,
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      //debugPrint('Authentication result: $result');
      return {
        'status': result['message'] == 'Login successful',
        'username': result['username'],
      };
    } else {
      print('Failed to authenticate. Status code: ${response.statusCode}');
      return {
        'status': false,
        'username': null,
      };
    }
  } catch (e) {
    print('Error running the authentication: $e');
    return {
      'status': false,
      'username': null,
    };
  }
}

Future<Map<String, dynamic>> get_user_log_data() async {
  try {
    final response = await http.get(
      Uri.parse('http://$ip_adress:8000/user_log_data'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = json.decode(response.body);

      if (result['status'] == false) {
        return {
          'status': false,
          'data': [],
          'message': result['message'] ?? 'No data available',
        };
      } else {
        return {'status': true, 'data': result['data']};
      }
    } else {
      print(
          'Failed to fetch user log data. Status code: ${response.statusCode}');
      return {'status': false, 'message': 'Failed to fetch user log data'};
    }
  } catch (e) {
    print('Error fetching user log data: $e');
    return {'status': false, 'message': 'Error fetching user log data'};
  }
}

// Function to logout
Future<Map<String, dynamic>> logout(String tpnumber) async {
  try {
    final response = await http.post(
      Uri.parse('http://$ip_adress:8000/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tpnumber': tpnumber,
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      //debugPrint('Logout result: $result');
      return {
        'status': result['message'] == 'Logout successful',
        'message': result['message'],
      };
    } else {
      print('Failed to logout. Status code: ${response.statusCode}');
      return {
        'status': false,
        'message': 'Failed to logout',
      };
    }
  } catch (e) {
    print('Error running the logout: $e');
    return {
      'status': false,
      'message': 'Error during logout',
    };
  }
}

// Function to generate OTP
Future<Map<String, dynamic>> generate_otp(String tpnumber) async {
  try {
    final response = await http.post(
      Uri.parse('http://$ip_adress:8000/generate_otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tpnumber': tpnumber,
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      debugPrint('OTP generation result: $result');
      return {
        'status': true,
        'otp': result['otp'],
        'message': result['message'],
      };
    } else {
      print('Failed to generate OTP. Status code: ${response.statusCode}');
      return {
        'status': false,
        'message': 'Failed to generate OTP',
      };
    }
  } catch (e) {
    print('Error generating OTP: $e');
    return {
      'status': false,
      'message': 'Error generating OTP',
    };
  }
}

// Function to update password
Future<Map<String, dynamic>> update_password(
  String tpnumber,
  String newPassword,
) async {
  try {
    final response = await http.post(
      Uri.parse('http://$ip_adress:8000/update_password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tpnumber': tpnumber,
        'password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return {
        'status': result['message'] == 'Password updated successfully',
        'message': result['message'],
      };
    } else {
      print('Failed to update password. Status code: ${response.statusCode}');
      return {
        'status': false,
        'message': 'Failed to update password',
      };
    }
  } catch (e) {
    print('Error updating password: $e');
    return {
      'status': false,
      'message': 'Error updating password',
    };
  }
}

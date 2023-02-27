import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

enum PhonePermission { denied, accepted, none }

class UserPhoneModel extends ChangeNotifier {
  PhonePermission _phonePermission = PhonePermission.none;

  PhonePermission get phonePermission => _phonePermission;

  set phonePermission(PhonePermission value) {
    if (value != phonePermission) {
      _phonePermission = value;
      notifyListeners();
    }
  }

  Future<bool> requestPermission() async {
    PermissionStatus result = PermissionStatus.denied;

    if (Platform.isAndroid) {
      result = await Permission.phone.request();
    }

    if (result.isGranted) {
      phonePermission = PhonePermission.accepted;
      return true;
    } else {
      phonePermission = PhonePermission.denied;
    }
    return false;
  }
}

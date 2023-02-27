import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

enum LocationPermission { denied, accepted, none }

class UserLocationModel extends ChangeNotifier {
  LocationPermission _locationPermission = LocationPermission.none;

  LocationPermission get locationPermission => _locationPermission;

  set locationPermission(LocationPermission value) {
    if (value != _locationPermission) {
      _locationPermission = value;
      notifyListeners();
    }
  }

  Future<bool> requestPermission() async {
    PermissionStatus result = PermissionStatus.denied;

    if (Platform.isAndroid) {
      result = await Permission.location.request();
    }

    if (result.isGranted) {
      locationPermission = LocationPermission.accepted;
      return true;
    } else {
      locationPermission = LocationPermission.denied;
    }
    return false;
  }
}

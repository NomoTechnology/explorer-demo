import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../screens/service_screen.dart';

import '../Models/phone_model.dart';

class PhonePermissionScreen extends StatefulWidget {
  static const routeName = 'storage-permission-screen';

  const PhonePermissionScreen({Key? key}) : super(key: key);

  @override
  State<PhonePermissionScreen> createState() => _PhonePermissionScreenState();
}

class _PhonePermissionScreenState extends State<PhonePermissionScreen>
    with WidgetsBindingObserver {
  late final UserPhoneModel _model;
  bool _detectPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _model = UserPhoneModel();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _detectPermission &&
        (_model.phonePermission == PhonePermission.denied)) {
      _detectPermission = false;
      _model.requestPermission();
    } else if (state == AppLifecycleState.paused &&
        _model.phonePermission == PhonePermission.denied) {
      _detectPermission = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<UserPhoneModel>(
        builder: (context, model, child) {
          Widget widget;

          switch (model.phonePermission) {
            case PhonePermission.none:
              widget = ImagePermissions(
                  isPermanent: false, onPressed: _checkPermissionsAndPick);
              break;
            case PhonePermission.denied:
              widget = ImagePermissions(
                  isPermanent: true, onPressed: _checkPermissionsAndPick);
              break;
            case PhonePermission.accepted:
              print("granted storage permission");
              widget = const Service();
              break;
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Handle permissions'),
            ),
            body: widget,
          );
        },
      ),
    );
  }

  Future<void> _checkPermissionsAndPick() async {
    final hasFilePermission = await _model.requestPermission();
    if (hasFilePermission) {
      try {
        print("permission done");
      } on Exception catch (e) {
        debugPrint('Error when picking a file: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred when picking a file'),
          ),
        );
      }
    }
  }
}

class ImagePermissions extends StatelessWidget {
  final bool isPermanent;
  final VoidCallback onPressed;

  const ImagePermissions({
    Key? key,
    required this.isPermanent,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 24.0,
              right: 16.0,
            ),
            child: Text(
              'Storage permission',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 24.0,
              right: 16.0,
            ),
            child: const Text(
              'We need to request your permission',
              textAlign: TextAlign.center,
            ),
          ),
          if (isPermanent)
            Container(
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 24.0,
                right: 16.0,
              ),
              child: const Text(
                'You need to give this permission from the system settings.',
                textAlign: TextAlign.center,
              ),
            ),
          Container(
            padding: const EdgeInsets.only(
                left: 16.0, top: 24.0, right: 16.0, bottom: 24.0),
            child: ElevatedButton(
              child: Text(isPermanent ? 'Open settings' : 'Allow access'),
              onPressed: () => isPermanent ? openAppSettings() : onPressed(),
            ),
          ),
        ],
      ),
    );
  }
}

class Service extends StatelessWidget {
  const Service({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: ElevatedButton(
          child: const Text('Next'),
          onPressed: () {
            Navigator.of(context).pushNamed(ServiceScreen.routeName);
          },
        ),
      );
}

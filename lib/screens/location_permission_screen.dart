import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import './phone_permission_screen.dart';
import '../widgets/step_permission.dart';
import '../models/location_model.dart';

class LocationPermissionScreen extends StatefulWidget {
  static const routeName = 'location-permission-screen';

  const LocationPermissionScreen({Key? key}) : super(key: key);

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen>
    with WidgetsBindingObserver {
  late final UserLocationModel _model;
  bool _detectPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _model = UserLocationModel();
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
        (_model.locationPermission == LocationPermission.denied)) {
      _detectPermission = false;
      _model.requestPermission();
    } else if (state == AppLifecycleState.paused &&
        _model.locationPermission == LocationPermission.denied) {
      _detectPermission = true;
    }
  }

  Widget createPermissionWidget(bool isPermanent, VoidCallback onPressed) {
    return StepPermission(
      isPermanent: isPermanent,
      onPressed: onPressed,
      image: Image.asset(
        'assets/images/location.png',
        fit: BoxFit.cover,
      ),
      title: 'Permissão de localização',
      message:
          'Precisamos acessar sua localização para verificar a qualidade da sua conexão de rede. Isso nos ajudará a identificar e solucionar quaisquer problemas com a rede de telecomunicações em sua área.',
    );
  }

  Future<void> _checkPermissionsAndPick() async {
    final hasFilePermission = await _model.requestPermission();
    if (hasFilePermission) {
      try {} on Exception catch (e) {
        debugPrint('Error when picking a file: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ocorreu um erro.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<UserLocationModel>(
        builder: (context, model, child) {
          Widget widget;

          switch (model.locationPermission) {
            case LocationPermission.none:
              widget = createPermissionWidget(false, _checkPermissionsAndPick);
              break;
            case LocationPermission.denied:
              widget = createPermissionWidget(true, openAppSettings);
              break;
            case LocationPermission.accepted:
              widget = const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF373D47),
                  strokeWidth: 3,
                ),
              );

              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context)
                    .pushNamed(PhonePermissionScreen.routeName);
              });
              break;
          }

          return Scaffold(
            body: widget,
          );
        },
      ),
    );
  }
}

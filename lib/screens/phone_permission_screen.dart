import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../widgets/step_permission.dart';
import '../screens/service_screen.dart';
import '../models/phone_model.dart';

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

  Widget createPermissionWidget(bool isPermanent, VoidCallback onPressed) {
    return StepPermission(
      isPermanent: isPermanent,
      onPressed: onPressed,
      image: Image.asset(
        'assets/images/phone.png',
        fit: BoxFit.cover,
      ),
      title: 'Permissão do telefone',
      message:
          'Precisa também acessar o estado do seu telefone para coletar informações básicas do dispositivo que nos ajudarão a fornecer o melhor serviço possível. Isso inclui detalhes como o modelo do seu dispositivo e a versão do sistema operacional, o que nos ajudará a otimizar o aplicativo para o seu dispositivo e fornecer relatórios de erros mais precisos. ',
    );
  }

  Future<void> _checkPermission() async {
    final hasFilePermission = await _model.requestPermission();
    if (hasFilePermission) {
      try {
        // Success
      } on Exception catch (e) {
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
      child: Consumer<UserPhoneModel>(
        builder: (context, model, child) {
          Widget widget;

          switch (model.phonePermission) {
            case PhonePermission.none:
              widget = createPermissionWidget(false, _checkPermission);
              break;
            case PhonePermission.denied:
              widget = createPermissionWidget(true, openAppSettings);
              break;
            case PhonePermission.accepted:
              widget = const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF373D47),
                  strokeWidth: 3,
                ),
              );

              Future.delayed(const Duration(seconds: 1), () {
                Navigator.of(context).pushNamed(ServiceScreen.routeName);
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

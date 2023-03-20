import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/primary_button.dart';

class ServiceScreen extends StatefulWidget {
  static const routeName = 'service-screen';

  const ServiceScreen({super.key});

  static const methodChannel = MethodChannel("explorer");

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  String _serverState = 'SDK não iniciada';
  bool _isServiceStarted = false;

  Future<void> _startService() async {
    try {
      final result = await ServiceScreen.methodChannel
          .invokeMethod('startExplorerService');
      setState(() {
        _serverState = result;
        _isServiceStarted = true;
      });
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    }
  }

  Future<void> _stopService() async {
    try {
      final result =
          await ServiceScreen.methodChannel.invokeMethod('stopExplorerService');
      setState(() {
        _serverState = result;
        _isServiceStarted = false;
      });
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PrimaryButton(
              text:
                  _isServiceStarted ? 'Pausar o serviço' : 'Iniciar o serviço',
              color: _isServiceStarted
                  ? const Color(0xFFEFAA9E)
                  : const Color(0xFFBEEDEA),
              onPressed: _isServiceStarted ? _stopService : _startService,
            ),
            Text(_serverState),
          ],
        ),
      ),
    );
  }
}

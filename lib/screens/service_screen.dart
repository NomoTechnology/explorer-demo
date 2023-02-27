import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ServiceScreen extends StatefulWidget {
  static const routeName = 'service';

  const ServiceScreen({super.key});

  static const methodChannel = MethodChannel("explorer");

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  String _serverState = 'Did not make the call yet';

  Future<void> _startService() async {
    try {
      final result = await ServiceScreen.methodChannel
          .invokeMethod('startExplorerService');
      setState(() {
        _serverState = result;
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
      });
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Service"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(_serverState),
            ElevatedButton(
              child: Text('Start Service'),
              onPressed: _startService,
            ),
            ElevatedButton(
              child: Text('Stop Service'),
              onPressed: _stopService,
            ),
          ],
        ),
      ),
    );
  }
}

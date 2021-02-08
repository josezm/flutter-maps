import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AccesoGpsPage extends StatefulWidget {
  @override
  _AccesoGpsPageState createState() => _AccesoGpsPageState();
}

class _AccesoGpsPageState extends State<AccesoGpsPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    print('=>>> $state');
    if(state == AppLifecycleState.resumed){
      if(await Permission.location.isGranted){
        Navigator.pushReplacementNamed(context, 'mapa');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Activa el GPS para poder continuar'),
            MaterialButton(
              onPressed: () async {
                final status = await Permission.location.request();
                this.accesoGPS(status, context);
              },
              child: Text(
                'Activar GPS',
                style: TextStyle(color: Colors.white),
              ),
              color: Color(0xff182C61),
            )
          ],
        ),
      ),
    );
  }

  void accesoGPS(PermissionStatus status, BuildContext context) {
    print(status);
    switch (status) {
      case PermissionStatus.granted:
        Navigator.pushReplacementNamed(context, 'mapa');
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
    }
  }
}

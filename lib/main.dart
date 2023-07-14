import 'package:flutter/material.dart';
import 'package:wakewake/server_list.dart';


void main() {
  runApp(const WakeWake());
}

class WakeWake extends StatelessWidget {
  const WakeWake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wake! Wake!',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const HostList(
        title: '',
      ),
    );
  }
}
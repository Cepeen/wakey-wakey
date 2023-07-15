import 'package:flutter/material.dart';
import 'hosts.dart';
import 'package:provider/provider.dart';
import 'server_list.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => HostListProvider(),
      child: const WakeWake(),
    ),
  );
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

class HostListProvider extends ChangeNotifier {
  List<Hosts> savedHosts = [];

  void removeHost(Hosts host) {
    savedHosts.remove(host);
    notifyListeners();
  }
}

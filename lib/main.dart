import 'widgets/host_list.dart';
import 'imports.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => HostListProvider(),
      child: const wakey_wakey(),
    ),
  );
}

class wakey_wakey extends StatelessWidget {
  const wakey_wakey({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wakey! Wakey!',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const HostList(
        title: 'Host List',
      ),
    );
  }
}

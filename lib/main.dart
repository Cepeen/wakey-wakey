import 'widgets/host_list.dart';
import 'imports.dart';

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

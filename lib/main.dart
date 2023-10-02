import 'widgets/host_list.dart';
import 'imports.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => HostListProvider(),
      child: const Wakeywakey(),
    ),
  );
}

class Wakeywakey extends StatelessWidget {
  const Wakeywakey({Key? key}) : super(key: key);

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

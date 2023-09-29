import 'widgets/host_list.dart';
import 'imports.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => HostListProvider(),
      child: const wakeywakey(),
    ),
  );
}

class wakeywakey extends StatelessWidget {
  const wakeywakey({Key? key}) : super(key: key);

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

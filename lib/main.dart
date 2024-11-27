import 'package:wakey_wakey/ui/global/theme/app_theme.dart';
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
      theme: whiteTheme,
      home: const HostList(
        title: 'Host List',
      ),
    );
  }
}

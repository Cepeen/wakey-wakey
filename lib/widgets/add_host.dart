import '../models/hosts.dart';
import '../imports.dart'; 

class AddHost extends StatefulWidget {
  const AddHost({Key? key, required this.title, this.host}) : super(key: key);

  final String title;
  final Host? host; // Add the host parameter

  @override
  State<AddHost> createState() => _AddHostState();
}

class _AddHostState extends State<AddHost> {
  final int port = 9;
  String macAddress = '';
  String ipAddress = '';
  String hostName = '';

  @override
  void initState() {
    super.initState();
    if (widget.host != null) {
      final hostProvider = context.read<HostListProvider>();
      final host = widget.host!;
      hostName = host.hostName;
      ipAddress = host.ipAddress;
      macAddress = host.macAddress;
    }
    loadPreferences();
  }

  Future<void> savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final hostProvider = context.read<HostListProvider>();
    List<String> hostList = hostProvider.savedHosts.map((host) => jsonEncode(host.toJson())).toList();
    prefs.setStringList('hosts', hostList);
  }

  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final hostProvider = context.read<HostListProvider>();
    List<String> hostList = prefs.getStringList('hosts') ?? [];
    hostProvider.savedHosts = hostList.map((item) => Host.fromJson(jsonDecode(item))).toList();
  }

  void _wakewake() {
    sendMagicPacket(macAddress, ipAddress);
  }

  void _saveHost() {
    final hostProvider = context.read<HostListProvider>();
    Host newHost = Host(hostName, ipAddress, macAddress);
    hostProvider.savedHosts.add(newHost);
    savePreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20.0),
              child: HostNameTextField(
                onChanged: (value) {
                  setState(() {
                    hostName = value;
                  });
                },
                hostName: hostName,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: MacAddressTextField(
                onChanged: (value) {
                  setState(() {
                    macAddress = value;
                  });
                },
                macAddress: macAddress,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: IPAddressTextField(
                onChanged: (value) {
                  setState(() {
                    ipAddress = value;
                  });
                },
                ipAddress: ipAddress,
              ),
            ),
            ElevatedButton(
              onPressed: _wakewake,
              child: const Text('Wake! Wake!'),
            ),
            ElevatedButton(
              onPressed: () {
                savePreferences();
                _saveHost();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

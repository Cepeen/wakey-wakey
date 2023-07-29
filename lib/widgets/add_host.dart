import '../models/hosts.dart';
import '../imports.dart';
import '../utils/utils.dart';

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

  Future<bool> _handleBackPress() async {
    // Close the modal and return to HostList screen
    Navigator.popUntil(context, ModalRoute.withName('/'));
    return true; // Allow back navigation
  }

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
    List<String> hostList =
        hostProvider.savedHosts.map((host) => jsonEncode(host.toJson())).toList();
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
    // Validation check: Ensure IP address is provided
    if (macAddress.trim().replaceAll(":", "").length != 12) {
      // Show a snackbar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a valid MAC address (12 characters).')),
      );
    } else if (ipAddress.trim().isEmpty | macAddress.trim().isEmpty) {
      // Show a snackbar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('IP and mac addresses are required.')),
      );
      return; // Exit the method without saving the host
    }
    final hostProvider = context.read<HostListProvider>();
    Host newHost = Host(hostName, ipAddress, macAddress);
    int existingHostIndex = hostProvider.savedHosts.indexWhere((host) => host.hostName == hostName);
    if (existingHostIndex != -1) {
      hostProvider.savedHosts[existingHostIndex] = newHost;
    } else {
      hostProvider.savedHosts.add(newHost);
    }

    savePreferences();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackPress,
      child: Scaffold(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _wakewake,
                    child: const Text('Wake! Wake!'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _saveHost();
                      savePreferences();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

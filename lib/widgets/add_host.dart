import '../models/hosts.dart';
import '../imports.dart';
import 'host_list.dart';

class AddHost extends StatefulWidget {
  const AddHost({Key? key, required this.title, this.host}) : super(key: key);

  final String title;
  final Host? host; // Add the host parameter

  @override
  State<AddHost> createState() => _AddHostState();
}

class _AddHostState extends State<AddHost> {
  final int port = 9;
  String hostId = '';
  String macAddress = '';
  String ipAddress = '';
  String hostName = '';
  String time = '';

// Prevents multiple instances of AddHost, removes modal
  Future<bool> _handleBackPress() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HostList(
          title: '',
        ),
      ),
      (route) => false,
    );
    return false;
  }

  @override
  void initState() {
    super.initState();
    if (widget.host != null) {
      final host = widget.host!;
      hostName = host.hostName;
      ipAddress = host.ipAddress;
      macAddress = host.macAddress;
      time = host.time;
    }
    loadPreferences();
  }

  bool _validateHostDetails(String macAddress, String ipAddress) {
    if (macAddress.trim().replaceAll(":", "").length != 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Provide a valid MAC address (17 characters withdots).')),
      );
      return false;
    } else if (ipAddress.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('IP and MAC addresses are required.')),
      );
      return false;
    } else if (!isIPv4Address32Bit(ipAddress)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a valid 32-bit IP address.')),
      );
      return false;
    }
    return true;
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
    if (_validateHostDetails(macAddress, ipAddress)) {
      // Host details are valid, execute the magic packet sending function
      checkAndExecuteOrNot(macAddress, ipAddress, context);
    }
  }

  void _saveHost() {
    // Extract host details from text fields
    String newHostName = hostName;
    String newMacAddress = macAddress;
    String newIpAddress = ipAddress;
    String newtime = time;

    if (!_validateHostDetails(newMacAddress, newIpAddress)) {
      // Validation failed, exit the method without saving
      return;
    }

    final hostProvider = context.read<HostListProvider>();
    if (widget.host != null) {
      int existingHostIndex =
          hostProvider.savedHosts.indexWhere((host) => host.hostId == widget.host!.hostId);
      if (existingHostIndex != -1) {
        Host updatedHost =
            Host(widget.host!.hostId, newHostName, newIpAddress, newMacAddress, time);
        hostProvider.savedHosts[existingHostIndex] = updatedHost;
      }
    } else {
      // New host, generate a hostId & save
      String hostId = generateHostId(); // generate hostId
      Host newHost = Host(hostId, newHostName, newIpAddress, newMacAddress, time);
      hostProvider.savedHosts.add(newHost);
    }
    savePreferences();
  }

  String generateHostId() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'host_$timestamp';
  }

  void executeWakeFunctionAtTime(Host host) {
    if (host.time == null) {
      debugPrint('Host does not have a specific time to start.');
      return;
    }

    DateTime scheduledTime = DateTime.parse(host.time); // Convert time string to DateTime object
    DateTime now = DateTime.now();

    if (scheduledTime.isBefore(now)) {
      debugPrint('Scheduled time is in the past.');
      return;
    }

    Duration delay = scheduledTime.difference(now);

    // Schedule the start function to run after the specified delay
    Future.delayed(delay, () {
      sendMagicPacket; // Call the start function
    });
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
              Container(
                padding: const EdgeInsets.all(20.0),
                child: TimeTextField(
                  onChanged: (value) {
                    setState(() {
                      time = value;
                    });
                  },
                  time: time,
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
                      executeWakeFunctionAtTime(
                          Host(hostId, hostName, ipAddress, macAddress, time));
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

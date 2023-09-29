import 'package:wakeywakey/widgets/time_picker.dart';

import '../imports.dart';
import '../models/hosts.dart';
import 'host_list.dart';
import 'host_validator.dart';

class AddHost extends StatefulWidget {
  const AddHost({Key? key, required this.title, this.host}) : super(key: key);

  final String title;
  final Host? host; // Add the host parameter

  @override
  State<AddHost> createState() => _AddHostState();
}

class _AddHostState extends State<AddHost> {
  late SharedPreferences prefs;
  TimeOfDay pickedTime = TimeOfDay.now();
  final int port = 9;
  int isChecked = 0;
  String hostId = '';
  String macAddress = '';
  String ipAddress = '';
  String hostName = '';
  String? macAddressError;
  String? ipAddressError;

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
    initializePreferences();
    if (widget.host != null) {
      final host = widget.host!;
      hostName = host.hostName;
      ipAddress = host.ipAddress;
      macAddress = host.macAddress;
      pickedTime = host.pickedTime;
      isChecked = host.isChecked;
    }
  }

  Future<void> initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool _validateHostDetails(String macAddress, String ipAddress) {
    macAddressError = HostValidator.validateMacAddress(macAddress);
    ipAddressError = HostValidator.validateIpAddress(ipAddress);

    setState(() {
      ipAddressError = ipAddressError;
      macAddressError = macAddressError;
    });

    return ipAddressError == null && macAddressError == null;
  }

  void updateIsChecked(int newValue) {
    setState(() {
      isChecked = newValue;
    });
  }

  void _wakeywakey() {
    if (_validateHostDetails(macAddress, ipAddress)) {
      checkAndExecuteOrNot(macAddress, ipAddress, context);
    }
  }

  void _saveHost() {
    String newHostName = hostName;
    String newMacAddress = macAddress;
    String newIpAddress = ipAddress;
    TimeOfDay newpickedTime = pickedTime;
    int newisChecked = isChecked;

    if (!_validateHostDetails(newMacAddress, newIpAddress)) {
      return;
    }

    final hostProvider = context.read<HostListProvider>();
    if (widget.host != null) {
      int existingHostIndex =
          hostProvider.savedHosts.indexWhere((host) => host.hostId == widget.host!.hostId);
      if (existingHostIndex != -1) {
        Host updatedHost = Host(
          hostId: widget.host!.hostId,
          hostName: newHostName,
          ipAddress: newIpAddress,
          macAddress: newMacAddress,
          pickedTime: newpickedTime,
          isChecked: newisChecked,
        );
        hostProvider.savedHosts[existingHostIndex] = updatedHost;

        if (newisChecked == 1) {
          TimeOfDay executeTime = newpickedTime;
          _scheduleExecution(executeTime, newMacAddress, newIpAddress);
        }
      }
    } else {
      String hostId = generateHostId();
      Host newHost = Host(
        hostId: hostId,
        hostName: newHostName,
        ipAddress: newIpAddress,
        macAddress: newMacAddress,
        pickedTime: newpickedTime,
        isChecked: isChecked,
      );
      hostProvider.savedHosts.add(newHost);
    }
    List<String> hostList =
        hostProvider.savedHosts.map((host) => jsonEncode(host.toJson())).toList();
    prefs.setStringList('hosts', hostList);
  }

  void _scheduleExecution(TimeOfDay executeTime, String macAddress, String ipAddress) {
    final now = TimeOfDay.now();
    final currentTime = Duration(hours: now.hour, minutes: now.minute);
    final scheduledTime = Duration(hours: executeTime.hour, minutes: executeTime.minute);

    if (scheduledTime > currentTime) {
      final delay = scheduledTime - currentTime;
      Future.delayed(delay, () {
        checkAndExecuteOrNotNE(macAddress, ipAddress);
      });
    }
  }

  String generateHostId() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'host_$timestamp';
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
                  errorText: macAddressError,
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
                  errorText: ipAddressError,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: TimePickerWidget(
                  onTimePicked: (TimeWithCheck newTimeWithCheck) {
                    setState(() {
                      pickedTime = newTimeWithCheck.time;
                      isChecked = newTimeWithCheck.isChecked;
                    });
                  },
                  pickedTime: TimeWithCheck(pickedTime, isChecked),
                ),
              ),
            ],
          ),
        ),
        persistentFooterButtons: [
          ElevatedButton(
            onPressed: _wakeywakey,
            child: const Text('Wake! Wake!'),
          ),
          ElevatedButton(
            onPressed: () {
              _saveHost();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'addserver.dart';
import 'hosts.dart';
import 'package:provider/provider.dart';
import 'main.dart';



List<Hosts> savedHosts = [];

class HostList extends AddHost {
  const HostList({super.key, required super.title});

  @override
  State<HostList> createState() => _HostListState();
}

class _HostListState extends State<HostList> {
  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final hostProvider = context.read<HostListProvider>();
    List<String> hostList = prefs.getStringList('hosts') ?? [];
    hostProvider.savedHosts = hostList.map((item) => Hosts.fromJson(jsonDecode(item))).toList();
  }

  @override
  Widget build(BuildContext context) {
    final hostProvider = context.watch<HostListProvider>(); // Access the HostListProvider
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hosts List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddHost(
                    title: 'Add Host',
                  ),
                ),
              ).then((_) {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: hostProvider.savedHosts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              sendMagicPacket(hostProvider.savedHosts[index].macAddress,
                  hostProvider.savedHosts[index].ipAddress);
            },
            onLongPress: () {
              _showContextMenu(context, index);
            },
            child: Card(
              child: ListTile(
                title: Text(hostProvider.savedHosts[index].hostName),
                subtitle: Text(
                  'IP: ${hostProvider.savedHosts[index].ipAddress}, MAC: ${hostProvider.savedHosts[index].macAddress}',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final hostProvider = context.read<HostListProvider>();
    List<String> hostList =
        hostProvider.savedHosts.map((host) => jsonEncode(host.toJson())).toList();
    prefs.setStringList('hosts', hostList);
  }

  void _showContextMenu(BuildContext context, int index) {
    final hostProvider = context.read<HostListProvider>(); // Access the HostListProvider

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddHost(
                      title: 'Add Host',
                      host: hostProvider.savedHosts[index],
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                hostProvider.removeHost(hostProvider.savedHosts[index]);
                savePreferences();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

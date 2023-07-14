
import 'package:flutter/material.dart';
import 'hosts.dart';
import 'addserver.dart';

List<Hosts> savedHosts = [];

class HostList extends AddHost {
  const HostList({super.key, required super.title});

  @override
  State<HostList> createState() => _HostListState();
}

class _HostListState extends State<HostList> {
  @override
  
  Widget build(BuildContext context) {
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
        itemCount: savedHosts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              sendMagicPacket(savedHosts[index].macAddress, savedHosts[index].ipAddress);
            },
            onLongPress: () {
              _showContextMenu(context, index);
            },
            child: Card(
              child: ListTile(
                title: Text(savedHosts[index].hostName),
                subtitle: Text(
                  'IP: ${savedHosts[index].ipAddress}, MAC: ${savedHosts[index].macAddress}',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void removeHost(Hosts host) {
    setState(() {
      savedHosts.remove(host);
    });
  }

  void _showContextMenu(BuildContext context, int index) {
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
                      host: savedHosts[index], // Pass the host to edit
                    ),
                  ),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                removeHost(savedHosts[index]); // Call the removeHost method to remove the host
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

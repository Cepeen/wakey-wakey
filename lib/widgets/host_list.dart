import '../imports.dart';

class HostList extends AddHost {
  const HostList({super.key, required super.title});

  @override
  State<HostList> createState() => _HostListState();
}

class _HostListState extends State<HostList> {
  late Future<void> _loadHostsFuture;

  @override
  void initState() {
    super.initState();
    _loadHostsFuture = context.read<HostListProvider>().loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final hostProvider = context.watch<HostListProvider>();
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
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'about') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => About()),
                );
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<String>(
                  value: 'about',
                  child: Text('About'),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _loadHostsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: hostProvider.savedHosts.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      checkAndExecuteOrNot(
                        hostProvider.savedHosts[index].macAddress,
                        hostProvider.savedHosts[index].ipAddress,
                        context,
                      );
                    },
                    onLongPress: () {
                      _showContextMenu(context, index);
                    },
                    child: Card(
                        child: Row(children: [
                      SizedBox(
                        width: 100,
                        height: 50, // Set the width for the Name column
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              hostProvider.savedHosts[index].hostName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 190,
                        // Set the width for the Details column
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'IP: ${hostProvider.savedHosts[index].ipAddress}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'MAC: ${hostProvider.savedHosts[index].macAddress}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 80, // Set the width for the Schedule column
                        child: hostProvider.savedHosts[index].isChecked == 1
                            ? Text(
                                hostProvider.savedHosts[index].pickedTime.format(context),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            : const Text("not set"),
                      )
                    ])));
              },
            );
          }
        },
      ),
    );
  }

  void _showContextMenu(BuildContext context, int index) {
    final hostProvider = context.read<HostListProvider>();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Edit'),
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm'),
                      content: const Text('Are you sure you want to delete this host?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            hostProvider.removeHost(hostProvider.savedHosts[index]);
                            Navigator.pop(context);
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}

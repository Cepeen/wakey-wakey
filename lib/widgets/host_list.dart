
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
        ],
      ),
      body: FutureBuilder<void>(
        future: _loadHostsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
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
                // savePreferences();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

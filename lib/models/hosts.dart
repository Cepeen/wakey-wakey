import '../imports.dart';

class Host {
  String hostId;
  String hostName;
  String ipAddress;
  String macAddress;
  TimeOfDay pickedTime;
  int isChecked; 

  Host({
    required this.hostId,
    required this.hostName,
    required this.ipAddress,
    required this.macAddress,
    required this.pickedTime,
    required this.isChecked, 
  });

  Map<String, dynamic> toJson() => {
        'hostId': hostId,
        'hostName': hostName,
        'ipAddress': ipAddress,
        'macAddress': macAddress,
        'time': '${pickedTime.hour}:${pickedTime.minute}',
        'isChecked': isChecked, 
      };

  factory Host.fromJson(Map<String, dynamic> json) => Host(
        hostId: json['hostId'] ?? '',
        hostName: json['hostName'],
        ipAddress: json['ipAddress'],
        macAddress: json['macAddress'],
        pickedTime: TimeOfDay(
          hour: int.parse(json['time'].split(':')[0]),
          minute: int.parse(json['time'].split(':')[1]),
        ),
        isChecked: json['isChecked'] ?? 0, 
      );
}
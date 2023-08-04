class Host {
  String hostId;
  String hostName;
  String ipAddress;
  String macAddress;
  String time;

  Host(this.hostId, this.hostName, this.ipAddress, this.macAddress, this.time);

  Map<String, dynamic> toJson() => {
        'hostId': hostId,
        'hostName': hostName,
        'ipAddress': ipAddress,
        'macAddress': macAddress,
        'time': time,
      };

  factory Host.fromJson(Map<String, dynamic> json) => Host(
        json['hostId'] ?? '',
        json['hostName'],
        json['ipAddress'],
        json['macAddress'],
        json['time'] ?? '',
      );
}

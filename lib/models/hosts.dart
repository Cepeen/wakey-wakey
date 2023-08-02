class Host {
  String hostId;
  String hostName;
  String ipAddress;
  String macAddress;

  Host(this.hostId, this.hostName, this.ipAddress, this.macAddress);
  Map<String, dynamic> toJson() => {
        'hostId': hostId,
        'hostName': hostName,
        'ipAddress': ipAddress,
        'macAddress': macAddress,
      };

  factory Host.fromJson(Map<String, dynamic> json) => Host(
        json['hostId'] ?? '',
        json['hostName'],
        json['ipAddress'],
        json['macAddress'],
      );
}

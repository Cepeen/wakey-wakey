
class Host {
  String hostName;
  String ipAddress;
  String macAddress;

  Host(this.hostName, this.ipAddress, this.macAddress);

  Map<String, dynamic> toJson() => {
    'hostName': hostName,
    'ipAddress': ipAddress,
    'macAddress': macAddress,
  };

  factory Host.fromJson(Map<String, dynamic> json) => Host(
    json['hostName'],
    json['ipAddress'],
    json['macAddress'],
  );
}



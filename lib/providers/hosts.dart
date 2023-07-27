class Hosts {
  String hostName;
  String ipAddress;
  String macAddress;

  Hosts(this.hostName, this.ipAddress, this.macAddress);

  Map<String, dynamic> toJson() => {
    'hostName': hostName,
    'ipAddress': ipAddress,
    'macAddress': macAddress,
  };

  factory Hosts.fromJson(Map<String, dynamic> json) => Hosts(
    json['hostName'],
    json['ipAddress'],
    json['macAddress'],
  );
}



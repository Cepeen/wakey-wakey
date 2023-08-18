import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/hosts.dart';

class HostListProvider extends ChangeNotifier {
  List<Host> savedHosts = [];

  void removeHost(Host host) {
    savedHosts.remove(host);
    savePreferences();
    notifyListeners();
  }

  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> hostList = prefs.getStringList('hosts') ?? [];
    savedHosts = hostList.map((item) => Host.fromJson(jsonDecode(item))).toList();
    notifyListeners();
  }

  Future<void> savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> hostList = savedHosts.map((host) => jsonEncode(host.toJson())).toList();
    prefs.setStringList('hosts', hostList);
  }
}

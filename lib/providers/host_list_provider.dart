import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/hosts.dart';


class HostListProvider extends ChangeNotifier {
  List<Hosts> savedHosts = [];

  void removeHost(Hosts host) {
    savedHosts.remove(host);
    savePreferences();
    notifyListeners();
  }

  Future<void> savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> hostList = savedHosts.map((host) => jsonEncode(host.toJson())).toList();
    prefs.setStringList('hosts', hostList);
  }

  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> hostList = prefs.getStringList('hosts') ?? [];
    savedHosts = hostList.map((item) => Hosts.fromJson(jsonDecode(item))).toList();
    notifyListeners();
  }
}



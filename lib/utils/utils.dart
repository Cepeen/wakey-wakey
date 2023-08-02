import 'dart:io';
import 'package:flutter/material.dart';

void sendMagicPacket(String macAddress, String ipAddress) {
  final List<int> macBytes = macAddress.split(':').map((e) => int.parse(e, radix: 16)).toList();
  final List<int> packet = [];

  // Add 6 bytes with a value of 0xFF as the packet's initial part
  for (int i = 0; i < 6; i++) {
    packet.add(0xFF);
  }

  // Repeat the MAC address in byte form 16 times
  for (int i = 0; i < 16; i++) {
    packet.addAll(macBytes);
  }

  // Create a UDP socket and send the packet to the broadcast address
  RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
    socket.send(packet, InternetAddress(ipAddress), 9);
    socket.close();
  });
}

void checkAndExecuteOrNot(String macAddress, String ipAddress, BuildContext context) {
  InternetAddress.lookup('google.com').then((result) {
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      sendMagicPacket(macAddress, ipAddress);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wake! Wake! Packet sent!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connection error.')),
      );
    }
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Connection error.')),
    );
  });
}

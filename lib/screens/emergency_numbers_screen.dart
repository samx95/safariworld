import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class _ParkContact {
  final String name;
  final String phone;

  const _ParkContact(this.name, this.phone);
}

// Publicly published head-office / main switchboard numbers. Phone numbers
// change over time — verify against the park's official website before
// relying on these in a real emergency.
const _parkContacts = [
  _ParkContact("SANParks Head Office (Pretoria)", "+27 12 428 9111"),
  _ParkContact("Kruger National Park (Skukuza)", "+27 13 735 4000"),
  _ParkContact("Addo Elephant National Park", "+27 42 233 8600"),
  _ParkContact("Table Mountain National Park", "+27 21 424 1037"),
  _ParkContact("Kgalagadi Transfrontier Park", "+27 54 561 2000"),
  _ParkContact("Golden Gate Highlands National Park", "+27 58 255 1000"),
  _ParkContact("Mapungubwe National Park", "+27 15 534 7923"),
  _ParkContact("Marakele National Park", "+27 14 777 1745"),
  _ParkContact("Ezemvelo KZN Wildlife Head Office", "+27 33 845 1000"),
  _ParkContact("Hluhluwe-iMfolozi Park", "+27 35 562 0848"),
];

class EmergencyNumbersScreen extends StatelessWidget {
  const EmergencyNumbersScreen({super.key});

  Future<void> _call(BuildContext context, String phone) async {
    final uri = Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
    final launched = await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't dial $phone")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🚨 Emergency Numbers"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.red.shade50,
            padding: const EdgeInsets.all(12),
            child: const Text(
              "In a life-threatening emergency, call your local emergency "
              "services first. Park office numbers below can change — please "
              "verify them against the park's official website.",
              style: TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _parkContacts.length,
              itemBuilder: (context, index) {
                final contact = _parkContacts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.local_phone, color: Colors.red),
                    title: Text(contact.name),
                    subtitle: Text(contact.phone),
                    trailing: IconButton(
                      icon: const Icon(Icons.call, color: Colors.green),
                      onPressed: () => _call(context, contact.phone),
                    ),
                    onTap: () => _call(context, contact.phone),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

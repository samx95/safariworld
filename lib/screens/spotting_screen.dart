import 'package:flutter/material.dart';

class _Animal {
  final String name;
  final String emoji;

  const _Animal(this.name, this.emoji);
}

const _spottableAnimals = [
  _Animal("Lion", "🦁"),
  _Animal("Elephant", "🐘"),
  _Animal("Giraffe", "🦒"),
  _Animal("Zebra", "🦓"),
  _Animal("Rhino", "🦏"),
  _Animal("Leopard", "🐆"),
  _Animal("Hippo", "🦛"),
  _Animal("Buffalo", "🐃"),
];

// Standard luminance-based grayscale matrix, used to grey out animals
// that haven't been marked as spotted yet.
const _grayscale = ColorFilter.matrix(<double>[
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
]);

class SpottingScreen extends StatefulWidget {
  const SpottingScreen({super.key});

  @override
  State<SpottingScreen> createState() => _SpottingScreenState();
}

class _SpottingScreenState extends State<SpottingScreen> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final Set<String> _spotted = {};

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _toggleSpotted(String name) {
    setState(() {
      if (!_spotted.add(name)) {
        _spotted.remove(name);
      }
    });
  }

  void _saveSighting() {
    final name = _nameController.text.trim();
    final location = _locationController.text.trim();

    if (name.isEmpty || location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in both the animal name and location."),
        ),
      );
      return;
    }

    setState(() => _spotted.add(name));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sighting saved: $name at $location 🎉")),
    );
    _nameController.clear();
    _locationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log Sighting 📸"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.camera_alt, size: 60, color: Colors.green),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Tap the animals you've spotted 👇",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: _spottableAnimals.map((animal) {
                final isSpotted = _spotted.contains(animal.name);
                final emoji = Text(
                  animal.emoji,
                  style: const TextStyle(fontSize: 32),
                );
                return GestureDetector(
                  onTap: () => _toggleSpotted(animal.name),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSpotted
                              ? Colors.green.shade100
                              : Colors.grey.shade200,
                          border: Border.all(
                            color: isSpotted
                                ? Colors.green
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                        child: isSpotted
                            ? emoji
                            : ColorFiltered(colorFilter: _grayscale, child: emoji),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        animal.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSpotted ? FontWeight.bold : FontWeight.normal,
                          color: isSpotted
                              ? Colors.green.shade800
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Animal Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: "Location Spotted",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSighting,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text("Save Sighting"),
            ),
          ],
        ),
      ),
    );
  }
}

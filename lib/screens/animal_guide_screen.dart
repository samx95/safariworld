import 'package:flutter/material.dart';

class _Animal {
  final String name;
  final String scientificName;
  final String emoji;
  final String image;
  final String diet;
  final String habitat;
  final String lifespan;
  final String funFact;
  final String conservationStatus;

  const _Animal({
    required this.name,
    required this.scientificName,
    required this.emoji,
    required this.image,
    required this.diet,
    required this.habitat,
    required this.lifespan,
    required this.funFact,
    required this.conservationStatus,
  });
}

const _animals = [
  _Animal(
    name: "Lion",
    scientificName: "Panthera leo",
    emoji: "🦁",
    image: "https://images.unsplash.com/photo-1601758123927-1a4e37c2ef9e",
    diet: "Carnivore — hunts zebra, wildebeest and buffalo",
    habitat: "Savannas and grasslands of sub-Saharan Africa",
    lifespan: "10–14 years in the wild",
    funFact:
        "Lions are the only big cats that live in social groups, called prides, of up to 30 individuals.",
    conservationStatus: "Vulnerable",
  ),
  _Animal(
    name: "African Elephant",
    scientificName: "Loxodonta africana",
    emoji: "🐘",
    image: "https://images.unsplash.com/photo-1583337130417-810c8a1556d7",
    diet: "Herbivore — grasses, bark and fruit, up to 150kg a day",
    habitat: "Savannas, forests and deserts across sub-Saharan Africa",
    lifespan: "60–70 years",
    funFact:
        "The world's largest land animal. Its trunk has around 40,000 muscles and can lift over 200kg.",
    conservationStatus: "Endangered",
  ),
  _Animal(
    name: "Giraffe",
    scientificName: "Giraffa camelopardalis",
    emoji: "🦒",
    image: "https://images.unsplash.com/photo-1556228721-d56607f7c0b0",
    diet: "Herbivore — mainly acacia leaves, stripped with an 18-inch tongue",
    habitat: "Savannas and open woodlands",
    lifespan: "20–25 years",
    funFact:
        "The tallest land animal, yet it has the same number of neck vertebrae as a human: seven.",
    conservationStatus: "Vulnerable",
  ),
  _Animal(
    name: "Plains Zebra",
    scientificName: "Equus quagga",
    emoji: "🦓",
    image: "https://images.unsplash.com/photo-1526095179574-86e545346ae6",
    diet: "Herbivore — mostly grasses",
    habitat: "Grasslands and savannas of eastern and southern Africa",
    lifespan: "20–25 years",
    funFact:
        "Every zebra's stripe pattern is unique, just like a human fingerprint.",
    conservationStatus: "Near Threatened",
  ),
  _Animal(
    name: "White Rhinoceros",
    scientificName: "Ceratotherium simum",
    emoji: "🦏",
    image: "https://images.unsplash.com/photo-1584844117766-e7e5e3c3a0e6",
    diet: "Herbivore — grazes almost exclusively on grasses",
    habitat: "Grasslands and savannas of southern Africa",
    lifespan: "40–50 years",
    funFact:
        "The second-largest land mammal. \"White\" likely comes from the Afrikaans \"wyd\" (wide), describing its broad mouth.",
    conservationStatus: "Near Threatened",
  ),
  _Animal(
    name: "Leopard",
    scientificName: "Panthera pardus",
    emoji: "🐆",
    image: "https://images.unsplash.com/photo-1551972873-b7e8754e8e26",
    diet: "Carnivore — an opportunistic hunter of almost any prey it can catch",
    habitat: "Savanna, forest, mountains and even near cities",
    lifespan: "12–17 years",
    funFact:
        "Incredibly strong for its size, a leopard can haul prey twice its own body weight up a tree.",
    conservationStatus: "Vulnerable",
  ),
  _Animal(
    name: "Cheetah",
    scientificName: "Acinonyx jubatus",
    emoji: "🐆",
    image: "https://images.unsplash.com/photo-1541707519942-68f2b91e6dd7",
    diet: "Carnivore — small to medium antelope, such as impala",
    habitat: "Open grasslands and savannas",
    lifespan: "10–12 years",
    funFact:
        "The fastest land animal on Earth, able to accelerate from 0 to 100km/h in about three seconds.",
    conservationStatus: "Vulnerable",
  ),
  _Animal(
    name: "Hippopotamus",
    scientificName: "Hippopotamus amphibius",
    emoji: "🦛",
    image: "https://images.unsplash.com/photo-1580781616526-3862c8c4b6a3",
    diet: "Herbivore — grazes on grasses at night",
    habitat: "Rivers and lakes throughout sub-Saharan Africa",
    lifespan: "40–50 years",
    funFact:
        "Despite living in water, hippos can't actually swim — they walk or bound along the riverbed.",
    conservationStatus: "Vulnerable",
  ),
  _Animal(
    name: "African Buffalo",
    scientificName: "Syncerus caffer",
    emoji: "🐃",
    image: "https://images.unsplash.com/photo-1523805009345-7448845a9e53",
    diet: "Herbivore — grasses, often near water",
    habitat: "Savannas, floodplains and forests",
    lifespan: "15–20 years",
    funFact:
        "One of the \"Big Five\". Buffalo herds are known to work together to defend members from predators.",
    conservationStatus: "Near Threatened",
  ),
];

class AnimalGuideScreen extends StatelessWidget {
  const AnimalGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animal Guide"),
        backgroundColor: Colors.brown,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _animals.length,
        itemBuilder: (context, index) {
          final animal = _animals[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  animal.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Text(
                    animal.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              title: Text(
                "${animal.name} ${animal.emoji}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                animal.scientificName,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FactRow(icon: Icons.restaurant, label: "Diet", value: animal.diet),
                      _FactRow(icon: Icons.map, label: "Habitat", value: animal.habitat),
                      _FactRow(
                        icon: Icons.hourglass_bottom,
                        label: "Lifespan",
                        value: animal.lifespan,
                      ),
                      _FactRow(
                        icon: Icons.shield,
                        label: "Conservation status",
                        value: animal.conservationStatus,
                      ),
                      const SizedBox(height: 8),
                      _FactRow(
                        icon: Icons.lightbulb,
                        label: "Did you know?",
                        value: animal.funFact,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _FactRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.brown),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

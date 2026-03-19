import 'package:flutter/material.dart';
import 'trainer_model.dart';
import 'trainer_detail_page.dart';

class TrainersListPage extends StatelessWidget {
  final String category;

  const TrainersListPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // "All" howe taan sab trainers, otherwise filter by category
    final List<TrainerModel> filtered = category == "All"
        ? dummyTrainers
        : dummyTrainers
            .where((t) => t.category == category)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          category == "All" ? "All Trainers" : "$category Trainers",
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: filtered.isEmpty
          ? const Center(
              child: Text(
                "No trainers found",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                return TrainerCard(trainer: filtered[index]);
              },
            ),
    );
  }
}

class TrainerCard extends StatelessWidget {
  final TrainerModel trainer;

  const TrainerCard({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TrainerDetailPage(trainer: trainer),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5),
          ],
        ),
        child: Row(
          children: [

            // Trainer image
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                trainer.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.orange.shade100,
                  child: const Icon(Icons.person, color: Colors.orange),
                ),
              ),
            ),

            const SizedBox(width: 15),

            // Trainer info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trainer.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    trainer.category,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        trainer.location,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${trainer.price} / Session",
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.orange, size: 14),
                          const SizedBox(width: 3),
                          Text(
                            "${trainer.rating}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios,
                size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
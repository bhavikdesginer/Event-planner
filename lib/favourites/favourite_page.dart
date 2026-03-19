import 'package:flutter/material.dart';
import '../favourites/favourite_service.dart';
import '../trainers/trainer_model.dart';
import '../trainers/trainer_detail_page.dart';
import '../widgets/heart_button_widget.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Header ──────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              "Favourites",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Trainers you've saved",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),

          const SizedBox(height: 16),

          // ── List ────────────────────────────────────────────
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: FavouriteService.favouritesStream(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                }

                final favIds = snapshot.data ?? [];

                // Match IDs with dummyTrainers
                final favTrainers = dummyTrainers
                    .where((t) => favIds.contains(t.id))
                    .toList();

                if (favTrainers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border,
                            size: 72, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text(
                          "No favourites yet",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Tap ❤️ on any trainer to save them here",
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: favTrainers.length,
                  itemBuilder: (context, index) {
                    return _FavouriteTrainerCard(
                        trainer: favTrainers[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Favourite Trainer Card ────────────────────────────────────────
class _FavouriteTrainerCard extends StatelessWidget {
  final TrainerModel trainer;
  const _FavouriteTrainerCard({required this.trainer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => TrainerDetailPage(trainer: trainer)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Row(
          children: [

            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                trainer.imageUrl,
                width: 75,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 75,
                  height: 75,
                  color: Colors.orange.shade100,
                  child: const Icon(Icons.person,
                      color: Colors.orange, size: 36),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trainer.name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      trainer.category,
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on,
                        size: 13, color: Colors.orange),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        trainer.location,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${trainer.price} / Session",
                        style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                      Row(children: [
                        const Icon(Icons.star,
                            color: Colors.orange, size: 13),
                        const SizedBox(width: 2),
                        Text("${trainer.rating}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ]),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Heart button
            HeartButton(trainerId: trainer.id),
          ],
        ),
      ),
    );
  }
}
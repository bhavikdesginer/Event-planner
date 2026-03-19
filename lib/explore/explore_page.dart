import 'package:flutter/material.dart';
import '../trainers/trainer_model.dart';
import '../trainers/trainer_detail_page.dart';
import '../widgets/heart_button_widget.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _selectedCategory = "All";
  String _selectedSort = "Top Rated";

  final List<String> _categories = [
    "All", "Fitness", "Yoga", "Dance", "Martial Arts"
  ];

  final List<String> _sortOptions = [
    "Top Rated", "Price: Low to High", "Price: High to Low", "Most Sessions"
  ];

  List<TrainerModel> get _topRated {
    final sorted = [...dummyTrainers]
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(4).toList();
  }

  List<TrainerModel> get _filteredTrainers {
    List<TrainerModel> list = _selectedCategory == "All"
        ? [...dummyTrainers]
        : dummyTrainers.where((t) => t.category == _selectedCategory).toList();

    switch (_selectedSort) {
      case "Price: Low to High":
        list.sort((a, b) {
          final aPrice = int.tryParse(a.price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
          final bPrice = int.tryParse(b.price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
          return aPrice.compareTo(bPrice);
        });
        break;
      case "Price: High to Low":
        list.sort((a, b) {
          final aPrice = int.tryParse(a.price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
          final bPrice = int.tryParse(b.price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
          return bPrice.compareTo(aPrice);
        });
        break;
      case "Top Rated":
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case "Most Sessions":
        list.sort((a, b) => b.totalSessions.compareTo(a.totalSessions));
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: CustomScrollView(
        slivers: [

          // ── Header ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Explore",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      Text("Find your perfect trainer",
                          style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                  // Sort button
                  GestureDetector(
                    onTap: _showSortSheet,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.sort, color: Colors.orange, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            _selectedSort.split(":").first,
                            style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Category Filter chips ──────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.orange : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.orange
                                : Colors.grey.shade300,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                      color: Colors.orange.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2))
                                ]
                              : [],
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // ── Top Rated section (only when All selected) ─────────
          if (_selectedCategory == "All") ...[
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.orange, size: 20),
                    SizedBox(width: 6),
                    Text("Top Rated",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _topRated.length,
                  itemBuilder: (context, index) {
                    return _TopRatedCard(trainer: _topRated[index]);
                  },
                ),
              ),
            ),
          ],

          // ── All Trainers label ─────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedCategory == "All"
                        ? "All Trainers"
                        : "$_selectedCategory Trainers",
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${_filteredTrainers.length} found",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          // ── Grid ──────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _TrainerGridCard(trainer: _filteredTrainers[index]);
                },
                childCount: _filteredTrainers.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Sort by",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ..._sortOptions.map((option) => GestureDetector(
                  onTap: () {
                    setState(() => _selectedSort = option);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade100)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(option, style: const TextStyle(fontSize: 14)),
                        if (_selectedSort == option)
                          const Icon(Icons.check_circle,
                              color: Colors.orange, size: 20),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Top Rated Horizontal Card ─────────────────────────────────────
class _TopRatedCard extends StatelessWidget {
  final TrainerModel trainer;
  const _TopRatedCard({required this.trainer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TrainerDetailPage(trainer: trainer)),
      ),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    trainer.imageUrl,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 110,
                      color: Colors.orange.shade100,
                      child: const Center(
                          child: Icon(Icons.person,
                              color: Colors.orange, size: 40)),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star,
                            color: Colors.white, size: 11),
                        const SizedBox(width: 2),
                        Text(
                          "${trainer.rating}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trainer.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(trainer.category,
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text("${trainer.price}/session",
                      style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Trainer Grid Card ─────────────────────────────────────────────
class _TrainerGridCard extends StatelessWidget {
  final TrainerModel trainer;
  const _TrainerGridCard({required this.trainer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TrainerDetailPage(trainer: trainer)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    trainer.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 120,
                      color: Colors.orange.shade100,
                      child: const Center(
                          child: Icon(Icons.person,
                              color: Colors.orange, size: 40)),
                    ),
                  ),
                ),
                // Heart button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: HeartButton(trainerId: trainer.id, size: 16),
                  ),
                ),
                // Category badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      trainer.category,
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trainer.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(children: [
                    const Icon(Icons.location_on,
                        size: 11, color: Colors.orange),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        trainer.location.split(",").first,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${trainer.price}",
                        style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                      Row(children: [
                        const Icon(Icons.star,
                            color: Colors.orange, size: 12),
                        const SizedBox(width: 2),
                        Text("${trainer.rating}",
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey)),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
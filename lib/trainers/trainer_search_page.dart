import 'package:flutter/material.dart';
import '../trainers/trainer_model.dart';
import '../trainers/trainer_detail_page.dart';

class TrainerSearchPage extends StatefulWidget {
  const TrainerSearchPage({super.key});

  @override
  State<TrainerSearchPage> createState() => _TrainerSearchPageState();
}

class _TrainerSearchPageState extends State<TrainerSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<TrainerModel> _results = [];
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _results = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _hasSearched = true;
      _results = dummyTrainers.where((trainer) {
        return trainer.name.toLowerCase().contains(query) ||
            trainer.category.toLowerCase().contains(query) ||
            trainer.location.toLowerCase().contains(query) ||
            trainer.badges.any((b) => b.toLowerCase().contains(query));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Search trainers, categories...",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
          ),
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Suggestions / quick filters ──────────────────────
          if (!_hasSearched) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Text(
                "Popular searches",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ["Fitness", "Yoga", "Dance", "Martial Arts", "HIIT", "Meditation"]
                    .map((tag) => GestureDetector(
                          onTap: () {
                            _searchController.text = tag;
                            _searchController.selection =
                                TextSelection.fromPosition(
                              TextPosition(offset: tag.length),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.search,
                                    size: 14, color: Colors.orange),
                                const SizedBox(width: 6),
                                Text(tag,
                                    style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 10),
              child: Text(
                "All trainers",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: dummyTrainers.length,
                itemBuilder: (context, index) {
                  return _TrainerSearchCard(trainer: dummyTrainers[index]);
                },
              ),
            ),
          ],

          // ── Search results ────────────────────────────────────
          if (_hasSearched) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                _results.isEmpty
                    ? "No results found"
                    : "${_results.length} trainer${_results.length == 1 ? '' : 's'} found",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            if (_results.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off,
                          size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        "No trainer found for\n\"${_searchController.text}\"",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    return _TrainerSearchCard(trainer: _results[index]);
                  },
                ),
              ),
          ],
        ],
      ),
    );
  }
}

// ── Trainer Search Card ───────────────────────────────────────────
class _TrainerSearchCard extends StatelessWidget {
  final TrainerModel trainer;
  const _TrainerSearchCard({required this.trainer});

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
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4),
          ],
        ),
        child: Row(
          children: [

            // Trainer image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                trainer.imageUrl,
                width: 62,
                height: 62,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 62,
                  height: 62,
                  color: Colors.orange.shade100,
                  child: const Icon(Icons.person, color: Colors.orange),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trainer.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
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
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
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
                    ],
                  ),
                ],
              ),
            ),

            // Price + rating
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${trainer.price}/session",
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 13),
                    const SizedBox(width: 2),
                    Text(
                      "${trainer.rating}",
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios,
                size: 13, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
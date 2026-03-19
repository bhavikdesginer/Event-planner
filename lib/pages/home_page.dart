import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../trainers/trainer_model.dart';
import '../trainers/trainers_list_page.dart';
import '../trainers/trainer_detail_page.dart';
import '../trainers/trainer_search_page.dart';
import '../location/location_access_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _location = "Detecting...";
  bool _locationLoading = true;

  final TrainerModel _popularTrainer = dummyTrainers.first;
  final List<TrainerModel> _availableTrainers =
      dummyTrainers.skip(1).take(3).toList();

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        setState(() { _location = "Set Location"; _locationLoading = false; });
        return;
      }
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final loc = doc.data()?['location'] as String?;
      setState(() {
        _location = (loc != null && loc.isNotEmpty) ? loc : "Set Location";
        _locationLoading = false;
      });
    } catch (e) {
      setState(() { _location = "Set Location"; _locationLoading = false; });
    }
  }

  void _openLocationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LocationAccessPage()),
    ).then((_) => _fetchLocation());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ── LOCATION + NOTIFICATION ──────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _openLocationPage,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Location",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.orange, size: 18),
                          const SizedBox(width: 4),
                          if (_locationLoading)
                            const SizedBox(
                              width: 14, height: 14,
                              child: CircularProgressIndicator(
                                  color: Colors.orange, strokeWidth: 2),
                            )
                          else
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: Text(
                                _location,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down, size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200, shape: BoxShape.circle),
                  child: const Icon(Icons.notifications),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ── SEARCH BAR ───────────────────────────────────────
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TrainerSearchPage())),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade100),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 10),
                          Text("Search Trainers",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 50, width: 50,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.tune, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ── CATEGORIES ───────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Categories",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const TrainersListPage(category: "All"))),
                  child: const Text("See all", style: TextStyle(color: Colors.orange)),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryItem(icon: Icons.fitness_center, title: "Fitness",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainersListPage(category: "Fitness")))),
                CategoryItem(icon: Icons.self_improvement, title: "Yoga",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainersListPage(category: "Yoga")))),
                CategoryItem(icon: Icons.sports_martial_arts, title: "Martial Arts",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainersListPage(category: "Martial Arts")))),
                CategoryItem(icon: Icons.music_note, title: "Dance",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainersListPage(category: "Dance")))),
              ],
            ),

            const SizedBox(height: 25),

            /// ── POPULAR TRAINERS ─────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Popular Trainers",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const TrainersListPage(category: "All"))),
                  child: const Text("See all", style: TextStyle(color: Colors.orange)),
                ),
              ],
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => TrainerDetailPage(trainer: _popularTrainer))),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.network(
                        _popularTrainer.imageUrl,
                        height: 180, width: double.infinity, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 180, color: Colors.orange.shade100,
                          child: const Center(child: Icon(Icons.person, size: 60, color: Colors.orange)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_popularTrainer.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 6),
                          Row(children: [
                            const Icon(Icons.location_on, size: 16, color: Colors.orange),
                            const SizedBox(width: 5),
                            Text(_popularTrainer.location),
                          ]),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${_popularTrainer.price} / Session",
                                  style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                              Row(children: [
                                const Icon(Icons.star, color: Colors.orange, size: 16),
                                const SizedBox(width: 3),
                                Text("${_popularTrainer.rating} (${_popularTrainer.totalReviews} reviews)",
                                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// ── AVAILABLE TRAINERS ───────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Available Trainers",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const TrainersListPage(category: "All"))),
                  child: const Text("See all", style: TextStyle(color: Colors.orange)),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _availableTrainers.length,
                itemBuilder: (context, index) {
                  final trainer = _availableTrainers[index];
                  return AvailableTrainerCard(
                    trainer: trainer,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => TrainerDetailPage(trainer: trainer))),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const CategoryItem({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60, width: 60,
            decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: Colors.orange),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class AvailableTrainerCard extends StatelessWidget {
  final TrainerModel trainer;
  final VoidCallback onTap;
  const AvailableTrainerCard({super.key, required this.trainer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    trainer.imageUrl,
                    height: 130, width: double.infinity, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 130, color: Colors.orange.shade100,
                      child: const Center(child: Icon(Icons.person, size: 50, color: Colors.orange)),
                    ),
                  ),
                ),
                Positioned(
                  top: 10, left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Text(trainer.category,
                        style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on, size: 13, color: Colors.orange),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(trainer.location.split(",").first,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${trainer.price} / Session",
                          style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13)),
                      Row(children: [
                        const Icon(Icons.star, color: Colors.orange, size: 13),
                        const SizedBox(width: 2),
                        Text("${trainer.rating}",
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
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

// import 'package:flutter/material.dart';
// import '../trainers/trainer_model.dart';
// import '../trainers/trainers_list_page.dart';
// import '../trainers/trainer_detail_page.dart';
// import '../trainers/trainer_search_page.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Popular trainer — first from dummy list
//     final TrainerModel popularTrainer = dummyTrainers.first;

//     // Available trainers — show first 3 (excluding the popular one)
//     final List<TrainerModel> availableTrainers = dummyTrainers.skip(1).take(3).toList();

//     return SafeArea(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             /// ── LOCATION + NOTIFICATION ──────────────────────────
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Location", style: TextStyle(color: Colors.grey)),
//                     SizedBox(height: 4),
//                     Row(
//                       children: [
//                         Icon(Icons.location_on, color: Colors.orange, size: 18),
//                         SizedBox(width: 4),
//                         Text(
//                           "New York, USA",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Icon(Icons.keyboard_arrow_down),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade200,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.notifications),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             /// ── SEARCH BAR ───────────────────────────────────────
//             GestureDetector(
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => const TrainerSearchPage(),
//                 ),
//            ),
//            child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 15),
//                     height: 50,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       color: Colors.grey.shade100,
//                     ),
//                     child: const Row(
//                       children: [
//                         Icon(Icons.search, color: Colors.grey),
//                         SizedBox(width: 10),
//                         Text(
//                           "Search Trainers",
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Container(
//                   height: 50,
//                   width: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.orange,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(Icons.tune, color: Colors.white),
//                 ),
//               ],
//             ),
//         ),

//             const SizedBox(height: 25),

//             /// ── CATEGORIES ───────────────────────────────────────
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Categories",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 GestureDetector(
//                   onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const TrainersListPage(category: "All"),
//                     ),
//                   ),
//                   child: const Text(
//                     "See all",
//                     style: TextStyle(color: Colors.orange),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 15),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CategoryItem(
//                   icon: Icons.fitness_center,
//                   title: "Fitness",
//                   onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) =>
//                           const TrainersListPage(category: "Fitness"),
//                     ),
//                   ),
//                 ),
//                 CategoryItem(
//                   icon: Icons.self_improvement,
//                   title: "Yoga",
//                   onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) =>
//                           const TrainersListPage(category: "Yoga"),
//                     ),
//                   ),
//                 ),
//                 CategoryItem(
//                   icon: Icons.sports_martial_arts,
//                   title: "Martial Arts",
//                   onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) =>
//                           const TrainersListPage(category: "Martial Arts"),
//                     ),
//                   ),
//                 ),
//                 CategoryItem(
//                   icon: Icons.music_note,
//                   title: "Dance",
//                   onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) =>
//                           const TrainersListPage(category: "Dance"),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 25),

//             /// ── POPULAR TRAINERS ─────────────────────────────────
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Popular Trainers",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 GestureDetector(
//                   onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const TrainersListPage(category: "All"),
//                     ),
//                   ),
//                   child: const Text(
//                     "See all",
//                     style: TextStyle(color: Colors.orange),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 15),

//             /// Popular trainer card — dynamic from TrainerModel
//             GestureDetector(
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) =>
//                       TrainerDetailPage(trainer: popularTrainer),
//                 ),
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   color: Colors.white,
//                   boxShadow: const [
//                     BoxShadow(color: Colors.black12, blurRadius: 6),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ClipRRect(
//                       borderRadius: const BorderRadius.vertical(
//                           top: Radius.circular(15)),
//                       child: Image.network(
//                         popularTrainer.imageUrl,
//                         height: 180,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => Container(
//                           height: 180,
//                           color: Colors.orange.shade100,
//                           child: const Center(
//                               child: Icon(Icons.person,
//                                   size: 60, color: Colors.orange)),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             popularTrainer.name,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           Row(
//                             children: [
//                               const Icon(Icons.location_on,
//                                   size: 16, color: Colors.orange),
//                               const SizedBox(width: 5),
//                               Text(popularTrainer.location),
//                             ],
//                           ),
//                           const SizedBox(height: 6),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "${popularTrainer.price} / Session",
//                                 style: const TextStyle(
//                                   color: Colors.orange,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   const Icon(Icons.star,
//                                       color: Colors.orange, size: 16),
//                                   const SizedBox(width: 3),
//                                   Text(
//                                     "${popularTrainer.rating} (${popularTrainer.totalReviews} reviews)",
//                                     style: const TextStyle(
//                                         fontSize: 12, color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 25),

//             /// ── AVAILABLE TRAINERS ───────────────────────────────
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Available Trainers",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 GestureDetector(
//                   onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const TrainersListPage(category: "All"),
//                     ),
//                   ),
//                   child: const Text(
//                     "See all",
//                     style: TextStyle(color: Colors.orange),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 15),

//             SizedBox(
//               height: 230,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: availableTrainers.length,
//                 itemBuilder: (context, index) {
//                   final trainer = availableTrainers[index];
//                   return AvailableTrainerCard(
//                     trainer: trainer,
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) =>
//                             TrainerDetailPage(trainer: trainer),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// ── CATEGORY ITEM ────────────────────────────────────────────────
// class CategoryItem extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final VoidCallback onTap;

//   const CategoryItem({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             height: 60,
//             width: 60,
//             decoration: BoxDecoration(
//               color: Colors.orange.withOpacity(0.15),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: Colors.orange),
//           ),
//           const SizedBox(height: 8),
//           Text(title, style: const TextStyle(fontSize: 13)),
//         ],
//       ),
//     );
//   }
// }

// /// ── AVAILABLE TRAINER CARD ───────────────────────────────────────
// class AvailableTrainerCard extends StatelessWidget {
//   final TrainerModel trainer;
//   final VoidCallback onTap;

//   const AvailableTrainerCard({
//     super.key,
//     required this.trainer,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 200,
//         margin: const EdgeInsets.only(right: 15),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color: Colors.white,
//           boxShadow: const [
//             BoxShadow(color: Colors.black12, blurRadius: 6),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius:
//                       const BorderRadius.vertical(top: Radius.circular(15)),
//                   child: Image.network(
//                     trainer.imageUrl,
//                     height: 130,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       height: 130,
//                       color: Colors.orange.shade100,
//                       child: const Center(
//                           child:
//                               Icon(Icons.person, size: 50, color: Colors.orange)),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 10,
//                   left: 10,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       trainer.category,
//                       style: const TextStyle(
//                         color: Colors.orange,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     trainer.name,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       const Icon(Icons.location_on,
//                           size: 13, color: Colors.orange),
//                       const SizedBox(width: 3),
//                       Expanded(
//                         child: Text(
//                           trainer.location.split(",").first,
//                           style: const TextStyle(
//                               fontSize: 12, color: Colors.grey),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "${trainer.price} / Session",
//                         style: const TextStyle(
//                           color: Colors.orange,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 13,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           const Icon(Icons.star,
//                               color: Colors.orange, size: 13),
//                           const SizedBox(width: 2),
//                           Text(
//                             "${trainer.rating}",
//                             style: const TextStyle(
//                                 fontSize: 12, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


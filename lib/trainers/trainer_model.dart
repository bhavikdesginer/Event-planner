class TrainerModel {
  final String id;
  final String name;
  final String category;
  final String location;
  final String price;
  final String imageUrl;
  final double rating;
  final int totalReviews;
  final int totalSessions;
  final int experience;
  final String bio;
  final List<String> badges;
  final List<TrainerReview> reviews;

  const TrainerModel({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.totalReviews,
    required this.totalSessions,
    required this.experience,
    required this.bio,
    required this.badges,
    required this.reviews,
  });
}

class TrainerReview {
  final String reviewerName;
  final String date;
  final int stars;
  final String text;

  const TrainerReview({
    required this.reviewerName,
    required this.date,
    required this.stars,
    required this.text,
  });
}

/// ─── DUMMY DATA ───────────────────────────────────────────────
final List<TrainerModel> dummyTrainers = [
  TrainerModel(
    id: "1",
    name: "John Carter",
    category: "Fitness",
    location: "New York, USA",
    price: "\$30",
    imageUrl:
        "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=600",
    rating: 4.8,
    totalReviews: 30,
    totalSessions: 240,
    experience: 6,
    bio:
        "Certified personal trainer specializing in strength training and HIIT. John has helped 200+ clients achieve their fitness goals with tailored workout plans.",
    badges: ["HIIT", "Strength", "Weight Loss"],
    reviews: [
      TrainerReview(
        reviewerName: "Riya S",
        date: "Feb 2025",
        stars: 5,
        text: "John is incredibly motivating! Lost 8kg in 2 months with his program.",
      ),
      TrainerReview(
        reviewerName: "Mike T",
        date: "Jan 2025",
        stars: 5,
        text: "Best trainer I've had. Very professional and punctual every session.",
      ),
    ],
  ),
  TrainerModel(
    id: "2",
    name: "Sophia Lee",
    category: "Dance",
    location: "Los Angeles, USA",
    price: "\$35",
    imageUrl:
        "https://images.unsplash.com/photo-1504609813442-a8924e83f76e?w=600",
    rating: 4.9,
    totalReviews: 22,
    totalSessions: 180,
    experience: 8,
    bio:
        "Professional dancer and choreographer with 8 years of teaching experience. Sophia teaches Bollywood, Hip-Hop, and Contemporary dance styles.",
    badges: ["Bollywood", "Hip-Hop", "Contemporary"],
    reviews: [
      TrainerReview(
        reviewerName: "Priya M",
        date: "Mar 2025",
        stars: 5,
        text: "Sophia makes every class so fun and energetic. Absolutely love her!",
      ),
      TrainerReview(
        reviewerName: "Aman R",
        date: "Feb 2025",
        stars: 5,
        text: "Learned so much in just 4 classes. Amazing teacher!",
      ),
    ],
  ),
  TrainerModel(
    id: "3",
    name: "Alex Chen",
    category: "Yoga",
    location: "Chicago, USA",
    price: "\$20",
    imageUrl:
        "https://images.unsplash.com/photo-1588286840104-8957b019727f?w=600",
    rating: 4.7,
    totalReviews: 38,
    totalSessions: 310,
    experience: 10,
    bio:
        "Yoga guru with a decade of experience. Alex specializes in Hatha, Vinyasa, and meditation techniques for stress relief and flexibility.",
    badges: ["Hatha", "Vinyasa", "Meditation"],
    reviews: [
      TrainerReview(
        reviewerName: "Lisa D",
        date: "Mar 2025",
        stars: 5,
        text: "Alex's sessions are so calming and restorative. Highly recommended.",
      ),
      TrainerReview(
        reviewerName: "Tom W",
        date: "Jan 2025",
        stars: 4,
        text: "Very patient and explains poses clearly. Great for beginners.",
      ),
    ],
  ),
  TrainerModel(
    id: "4",
    name: "Marco Silva",
    category: "Martial Arts",
    location: "Miami, USA",
    price: "\$45",
    imageUrl:
        "https://images.unsplash.com/photo-1555597673-b21d5c935865?w=600",
    rating: 4.6,
    totalReviews: 15,
    totalSessions: 120,
    experience: 12,
    bio:
        "Black belt martial artist trained in MMA, Kickboxing, and Jiu-Jitsu. Marco trains all levels from beginners to competitive fighters.",
    badges: ["MMA", "Kickboxing", "Jiu-Jitsu"],
    reviews: [
      TrainerReview(
        reviewerName: "Jake L",
        date: "Feb 2025",
        stars: 5,
        text: "Marco is intense but results speak for themselves. Great instructor.",
      ),
      TrainerReview(
        reviewerName: "Nina P",
        date: "Jan 2025",
        stars: 4,
        text: "Learned self-defense basics quickly. Very professional.",
      ),
    ],
  ),
  TrainerModel(
    id: "5",
    name: "Priya Sharma",
    category: "Yoga",
    location: "New York, USA",
    price: "\$25",
    imageUrl:
        "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=600",
    rating: 4.9,
    totalReviews: 35,
    totalSessions: 280,
    experience: 7,
    bio:
        "Certified yoga therapist focusing on prenatal yoga, stress management, and mindfulness. Priya blends ancient techniques with modern wellness science.",
    badges: ["Prenatal", "Mindfulness", "Yin Yoga"],
    reviews: [
      TrainerReview(
        reviewerName: "Ananya B",
        date: "Mar 2025",
        stars: 5,
        text: "Priya truly understands what her students need. So calming!",
      ),
      TrainerReview(
        reviewerName: "Rachel G",
        date: "Feb 2025",
        stars: 5,
        text: "Amazing prenatal yoga sessions. Felt so much better each week.",
      ),
    ],
  ),
  TrainerModel(
    id: "6",
    name: "Tyler Brooks",
    category: "Fitness",
    location: "Houston, USA",
    price: "\$40",
    imageUrl:
        "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600",
    rating: 4.5,
    totalReviews: 24,
    totalSessions: 195,
    experience: 5,
    bio:
        "Sports performance coach specializing in endurance training, marathon prep, and athletic conditioning. Tyler has coached 50+ marathon finishers.",
    badges: ["Marathon", "Endurance", "Athletic"],
    reviews: [
      TrainerReview(
        reviewerName: "Chris M",
        date: "Mar 2025",
        stars: 5,
        text: "Ran my first marathon thanks to Tyler's amazing 16-week plan!",
      ),
      TrainerReview(
        reviewerName: "Dana F",
        date: "Feb 2025",
        stars: 4,
        text: "Very structured training approach. Really knows his stuff.",
      ),
    ],
  ),
];
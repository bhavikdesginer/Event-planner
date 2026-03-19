import 'package:eventhub/bookings/booking_page.dart';
import 'package:eventhub/explore/explore_page.dart';
import 'package:eventhub/favourites/favourite_page.dart';
import 'package:eventhub/pages/home_page.dart';
import 'package:eventhub/pages/profile_page.dart';
import 'package:eventhub/theme/app_theme.dart';
import 'package:flutter/material.dart';

class NavPage extends StatefulWidget {
  final int index;

  const NavPage({super.key, required this.index});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index.clamp(0, 4).toInt();
  }

  void onItemTapped(int index) {
    if (index < 0 || index > 4) return;
    setState(() => _currentIndex = index);
  }

  // ── Build current page ───────────────────────────────────────
  // ProfilePage — UniqueKey() so it ALWAYS rebuilds when tab is tapped
  // Other pages — const so they stay alive (performance)
  Widget get _currentPage {
    switch (_currentIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const ExplorePage();
      case 2:
        return const BookingPage();
      case 3:
        return const FavouritePage();
      case 4:
        // UniqueKey forces ProfilePage to rebuild fresh every time
        return ProfilePage(key: UniqueKey());
      default:
        return const HomePage();
    }
  }

  Widget _navItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
  }) {
    final selected = _currentIndex == index;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: selected ? AppTheme.colorPrimary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: InkWell(
          onTap: () => onItemTapped(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? AppTheme.colorPrimary : Colors.grey,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: selected ? AppTheme.colorPrimary : Colors.grey,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPage,
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _navItem(
                context: context,
                index: 0,
                icon: Icons.home_rounded,
                label: 'Home',
              ),
              _navItem(
                context: context,
                index: 1,
                icon: Icons.travel_explore_rounded,
                label: 'Explore',
              ),
              _navItem(
                context: context,
                index: 2,
                icon: Icons.calendar_month_rounded,
                label: 'Booking',
              ),
              _navItem(
                context: context,
                index: 3,
                icon: Icons.favorite,
                label: 'Favourite',
              ),
              _navItem(
                context: context,
                index: 4,
                icon: Icons.person,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
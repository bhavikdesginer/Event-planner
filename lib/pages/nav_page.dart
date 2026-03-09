import 'package:eventhub/pages/explore_page.dart';
import 'package:eventhub/pages/favourite_page.dart';
import 'package:eventhub/pages/home_page.dart';
import 'package:eventhub/pages/profile_page.dart';
import 'package:eventhub/pages/tickets_page.dart';
import 'package:eventhub/theme/app_theme.dart';
import 'package:flutter/material.dart';

class NavPage extends StatefulWidget {
  int index;

  NavPage({super.key, required this.index});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {

  final List<Widget> pages = [
    const HomePage(),
    const ExplorePage(),
    const FavouritePage(),
    const TicketsPage(),
    const ProfilePage(),
  ];

  void onItemTapped(int index) {
    setState(() {
      widget.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[widget.index],
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        child: Row(
          children: [
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: widget.index == 0
                              ? AppTheme.colorPrimary
                              : Colors.transparent,
                          width: 2)),
                ),
                child: InkWell(
                  onTap: () => onItemTapped(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_rounded,
                        color: widget.index == 0
                            ? AppTheme.colorPrimary
                            : Colors.grey,
                      ),
                      Text(
                        'Home',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: widget.index == 0
                                ? AppTheme.colorPrimary
                                : Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: widget.index == 1
                              ? AppTheme.colorPrimary
                              : Colors.transparent,
                          width: 2)),
                ),
                child: InkWell(
                  onTap: () => onItemTapped(1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: widget.index == 1
                            ? AppTheme.colorPrimary
                            : Colors.grey,
                      ),
                      Text(
                        'Explore',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: widget.index == 1
                                ? AppTheme.colorPrimary
                                : Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: double.infinity,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: widget.index == 2
                                ? AppTheme.colorPrimary
                                : Colors.transparent,
                            width: 2))),
                child: InkWell(
                  onTap: () => onItemTapped(2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: widget.index == 2
                            ? AppTheme.colorPrimary
                            : Colors.grey,
                      ),
                      Text(
                        'Favourite',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: widget.index == 2
                                ? AppTheme.colorPrimary
                                : Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: double.infinity,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: widget.index == 3
                                ? AppTheme.colorPrimary
                                : Colors.transparent,
                            width: 2))),
                child: InkWell(
                  onTap: () => onItemTapped(3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_activity,
                        color: widget.index == 3
                            ? AppTheme.colorPrimary
                            : Colors.grey,
                      ),
                      Text(
                        'Ticket',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: widget.index == 3
                                ? AppTheme.colorPrimary
                                : Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: double.infinity,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: widget.index == 4
                                ? AppTheme.colorPrimary
                                : Colors.transparent,
                            width: 2))),
                child: InkWell(
                  onTap: () => onItemTapped(4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: widget.index == 4
                            ? AppTheme.colorPrimary
                            : Colors.grey,
                      ),
                      Text(
                        'Profile',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: widget.index == 3
                                ? AppTheme.colorPrimary
                                : Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

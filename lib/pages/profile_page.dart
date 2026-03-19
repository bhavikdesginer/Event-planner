import 'package:eventhub/pages/nav_page.dart';
import 'package:flutter/material.dart';
import 'package:eventhub/services/auth_service.dart';
import 'package:eventhub/services/user_service.dart';
import 'package:eventhub/helper/CommonFuctions.dart';
import 'package:eventhub/pages/login_flow/login_page.dart';
import '../../models/user_model.dart';
import 'your_profile_page.dart';
import '../bookings/booking_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();
  final UserService _userService = UserService();
  UserModel? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

Future<void> _loadUserData() async {
  setState(() => _loading = true);
  try {
    // ✅ currentUser di jagah authStateChanges wait karo
    final user = await FirebaseAuth.instance.authStateChanges().first;
    final uid = user?.uid;

    if (uid != null) {
      final userData = await _userService.getUser(uid);
      if (mounted) {
        setState(() {
          _user = userData;
          _loading = false;
        });
      }
    } else {
      if (mounted) setState(() => _loading = false);
    }
  } catch (e) {
    if (mounted) setState(() => _loading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SafeArea(
        child: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            /// ── HEADER ──────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text("Profile",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ── AVATAR + INFO ────────────────────────────────────
            Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: Colors.orange.shade100,
                      child: Text(
                        (_user?.name.isNotEmpty == true ? _user!.name : "U")
                            .substring(0, 1)
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final changed = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                              builder: (_) => YourProfilePage(user: _user)),
                        );
                        if (changed == true) _loadUserData();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.orange),
                        child: const Icon(Icons.edit, size: 15, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  _user?.name.isNotEmpty == true ? _user!.name : "User",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Text(
                  _user?.email ?? "",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),

                const SizedBox(height: 12),

                // Age | Gender | Interests strip
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.orange.shade100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatChip(
                        // age is non-nullable int — 0 means not set
                        value: (_user?.age ?? 0) > 0 ? "${_user!.age}" : "—",
                        label: "Age",
                      ),
                      Container(width: 1, height: 30, color: Colors.orange.shade200),
                      _StatChip(
                        // gender is non-nullable String — empty means not set
                        value: (_user?.gender ?? "").isNotEmpty ? _user!.gender : "—",
                        label: "Gender",
                      ),
                      Container(width: 1, height: 30, color: Colors.orange.shade200),
                      _StatChip(
                        value: "${_user?.interests.length ?? 0}",
                        label: "Interests",
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            /// ── ACCOUNT MENU ─────────────────────────────────────
            _MenuCard(children: [
              _MenuItem(
                icon: Icons.person_outline,
                title: "Your Profile",
                onTap: () async {
                  final changed = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                        builder: (_) => YourProfilePage(user: _user)),
                  );
                  if (changed == true) _loadUserData();
                },
              ),
              _divider(),
              _MenuItem(
                icon: Icons.calendar_today_outlined,
                title: "My Bookings",
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const NavPage(index: 2)),(route)=> false,
                  );
                },
              ),
              _divider(),
              _MenuItem(icon: Icons.credit_card, title: "Payment Methods"),
              _divider(),
              _MenuItem(icon: Icons.people_outline, title: "Following"),
              _divider(),
              _MenuItem(icon: Icons.settings_outlined, title: "Settings"),
            ]),

            const SizedBox(height: 16),

            /// ── SUPPORT MENU ─────────────────────────────────────
            _MenuCard(children: [
              _MenuItem(icon: Icons.help_outline, title: "Help Center"),
              _divider(),
              _MenuItem(icon: Icons.lock_outline, title: "Privacy Policy"),
              _divider(),
              _MenuItem(icon: Icons.person_add_alt, title: "Invite Friends"),
            ]),

            const SizedBox(height: 16),

            /// ── LOGOUT ───────────────────────────────────────────
            _MenuCard(children: [
              _MenuItem(
                icon: Icons.logout,
                title: "Log out",
                titleColor: Colors.red.shade400,
                iconColor: Colors.red.shade400,
                showArrow: false,
                onTap: () => showLogoutBottomSheet(context),
              ),
            ]),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _divider() =>
      Divider(height: 1, indent: 54, color: Colors.grey.shade100);
}

// ── Menu Card ─────────────────────────────────────────────────────
class _MenuCard extends StatelessWidget {
  final List<Widget> children;
  const _MenuCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(children: children),
    );
  }
}

// ── Stat Chip ─────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade700)),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      ],
    );
  }
}

// ── Menu Item ─────────────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color? titleColor;
  final Color? iconColor;
  final bool showArrow;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.titleColor,
    this.iconColor,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: (iconColor ?? Colors.orange).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? Colors.orange, size: 20),
      ),
      title: Text(title,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: titleColor ?? Colors.black87)),
      trailing: showArrow
          ? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
          : null,
    );
  }
}

// ── Logout Bottom Sheet ───────────────────────────────────────────
void showLogoutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                  color: Colors.red.shade50, shape: BoxShape.circle),
              child: Icon(Icons.logout, color: Colors.red.shade400, size: 28),
            ),
            const SizedBox(height: 12),
            const Text("Log out",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Are you sure you want to log out?",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await AuthService().signOut();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          CommonFunctionClass.pageRouteBuilder(const LoginPage()),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("Yes, Log out",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
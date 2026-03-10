import 'package:flutter/material.dart';
import 'package:eventhub/services/auth_service.dart';
import 'package:eventhub/services/user_service.dart';
import 'package:eventhub/helper/CommonFuctions.dart';
import 'package:eventhub/pages/login_flow/login_page.dart';
import '../../models/user_model.dart';
import 'your_profile_page.dart';

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
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final user = await _userService.getUser(uid);
        setState(() {
          _user = user;
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 10),

            /// HEADER
            Row(
              children: [
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48)
              ],
            ),

            const SizedBox(height: 20),

            /// PROFILE IMAGE
            Stack(
              alignment: Alignment.bottomRight,
              children: [

                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1502767089025-6572583495b0",
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.white,
                  ),
                )
              ],
            ),

            const SizedBox(height: 15),

            /// NAME - Load from Firebase
            Text(
              _loading ? "Loading..." : (_user?.name ?? "User"),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            /// MENU LIST
            ProfileMenuItem(
              icon: Icons.person_outline,
              title: "Your profile",
              onTap: () async {
                final changed = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YourProfilePage(user: _user),
                  ),
                );

                if (changed == true) {
                  _loadUserData();
                }
              },
            ),
            // const Divider(height: 1),

            ProfileMenuItem(
              icon: Icons.credit_card,
              title: "Payment Methods",
            ),
            // const Divider(height: 1),

            ProfileMenuItem(
              icon: Icons.people_outline,
              title: "Following",
            ),
            // const Divider(height: 1),

            ProfileMenuItem(
              icon: Icons.settings_outlined,
              title: "Settings",
            ),
            // const Divider(height: 1),

            ProfileMenuItem(
              icon: Icons.help_outline,
              title: "Help Center",
            ),
            // const Divider(height: 1),

            ProfileMenuItem(
              icon: Icons.lock_outline,
              title: "Privacy Policy",
            ),
            // const Divider(height: 1),

            ProfileMenuItem(
              icon: Icons.person_add_alt,
              title: "Invites Friends",
            ),
            // const Divider(height: 1),

            ProfileMenuItem(
              icon: Icons.logout,
              title: "Log out",
              onTap: () {
                showLogoutBottomSheet(context);
              },
            ),

            // const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

void showLogoutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Text(
              "Logout",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Are you sure you want to log out?",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

            Row(
              children: [

                /// CANCEL BUTTON
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.orange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),

                const SizedBox(width: 15),

                /// LOGOUT BUTTON
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      
                      // Sign out from Firebase
                      final authService = AuthService();
                      await authService.signOut();
                      
                      // Navigate to login page and clear back stack
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          CommonFunctionClass.pageRouteBuilder(const LoginPage()),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Yes, Logout",
                      style: TextStyle(color: Colors.white),
                    ),
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

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.orange,
      ),
      title: Text(title),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.orange,
      ),
      onTap: onTap,
    );
  }
}
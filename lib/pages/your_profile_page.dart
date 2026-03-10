import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eventhub/models/user_model.dart';
import 'package:eventhub/services/auth_service.dart';
import 'package:eventhub/services/user_service.dart';

class YourProfilePage extends StatefulWidget {
  final UserModel? user;

  const YourProfilePage({super.key, this.user});

  @override
  State<YourProfilePage> createState() => _YourProfilePageState();
}

class _YourProfilePageState extends State<YourProfilePage> {
  final AuthService _auth = AuthService();
  final UserService _userService = UserService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String gender = 'Not selected';
  bool _loading = true;

  String _normalizeGender(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'male') return 'Male';
    if (normalized == 'female') return 'Female';
    if (normalized == 'other') return 'Other';
    return 'Not selected';
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final uid = _auth.currentUser?.uid;
      UserModel? user = widget.user;

      if (user == null && uid != null) {
        user = await _userService.getUser(uid);
      }

      if (!mounted) return;
      setState(() {
        nameController.text = user?.name ?? '';
        phoneController.text = user?.phone ?? '';
        emailController.text = user?.email ?? '';
        gender = _normalizeGender(user?.gender ?? '');
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _editTextField({
    required String title,
    required String fieldKey,
    required String initialValue,
    TextInputType keyboardType = TextInputType.text,
  }) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => _EditTextValuePage(
          title: title,
          initialValue: initialValue,
          keyboardType: keyboardType,
        ),
      ),
    );

    if (result == null) return;

    if (fieldKey == 'phone' && result.length != 10) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone number must be exactly 10 digits'),
        ),
      );
      return;
    }

    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _userService.updateUser(uid, {fieldKey: result});

    if (!mounted) return;
    setState(() {
      if (fieldKey == 'name') nameController.text = result;
      if (fieldKey == 'phone') phoneController.text = result;
      if (fieldKey == 'email') emailController.text = result;
    });
  }

  Future<void> _editGender() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => _EditGenderPage(initialValue: gender),
      ),
    );

    if (result == null) return;

    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _userService.updateUser(uid, {'gender': result});

    if (!mounted) return;
    setState(() {
      gender = result;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Your Profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 25),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 55,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1502767089025-6572583495b0',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              _ProfileEditTile(
                label: 'Name',
                value: nameController.text,
                onTap: () => _editTextField(
                  title: 'Edit Name',
                  fieldKey: 'name',
                  initialValue: nameController.text,
                ),
              ),
              _ProfileEditTile(
                label: 'Phone Number',
                value: phoneController.text,
                onTap: () => _editTextField(
                  title: 'Edit Phone Number',
                  fieldKey: 'phone',
                  initialValue: phoneController.text,
                  keyboardType: TextInputType.phone,
                ),
              ),
              _ProfileEditTile(
                label: 'Email',
                value: emailController.text,
                onTap: () => _editTextField(
                  title: 'Edit Email',
                  fieldKey: 'email',
                  initialValue: emailController.text,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              _ProfileEditTile(
                label: 'Gender',
                value: gender,
                onTap: _editGender,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileEditTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ProfileEditTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 6),
          InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value.isEmpty ? 'Not set' : value,
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.orange),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditTextValuePage extends StatefulWidget {
  final String title;
  final String initialValue;
  final TextInputType keyboardType;

  const _EditTextValuePage({
    required this.title,
    required this.initialValue,
    required this.keyboardType,
  });

  @override
  State<_EditTextValuePage> createState() => _EditTextValuePageState();
}

class _EditTextValuePageState extends State<_EditTextValuePage> {
  late final TextEditingController _controller;

  bool get _isPhoneField => widget.keyboardType == TextInputType.phone;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: widget.keyboardType,
              inputFormatters: _isPhoneField
                  ? [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ]
                  : null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final value = _controller.text.trim();
                  if (_isPhoneField && value.length != 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Phone number must be exactly 10 digits'),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context, value);
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditGenderPage extends StatefulWidget {
  final String initialValue;

  const _EditGenderPage({required this.initialValue});

  @override
  State<_EditGenderPage> createState() => _EditGenderPageState();
}

class _EditGenderPageState extends State<_EditGenderPage> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    const options = ['Male', 'Female', 'Other'];
    final normalized = widget.initialValue.trim().toLowerCase();
    if (normalized == 'male') {
      _selected = 'Male';
    } else if (normalized == 'female') {
      _selected = 'Female';
    } else if (normalized == 'other') {
      _selected = 'Other';
    } else {
      _selected = options.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    const options = ['Male', 'Female', 'Other'];

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Gender')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ...options.map(
              (option) => RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: _selected,
                activeColor: Colors.orange,
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.orange;
                  }
                  return Colors.grey;
                }),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selected = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _selected);
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

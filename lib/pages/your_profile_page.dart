import 'package:flutter/material.dart';

class YourProfilePage extends StatefulWidget {
  const YourProfilePage({super.key});

  @override
  State<YourProfilePage> createState() => _YourProfilePageState();
}

class _YourProfilePageState extends State<YourProfilePage> {

  final TextEditingController nameController =
  TextEditingController(text: "Esther Howard");

  final TextEditingController phoneController =
  TextEditingController(text: "603.555.0123");

  final TextEditingController emailController =
  TextEditingController(text: "example@gmail.com");

  String gender = "Select";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              /// HEADER
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        "Your Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 40)
                ],
              ),

              const SizedBox(height: 25),

              /// PROFILE IMAGE
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [

                    const CircleAvatar(
                      radius: 55,
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1502767089025-6572583495b0",
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
                    )
                  ],
                ),
              ),

              const SizedBox(height: 35),

              /// NAME
              const Text(
                "Name",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 6),

              TextField(
                controller: nameController,
                decoration: inputDecoration(),
              ),

              const SizedBox(height: 20),

              /// PHONE
              const Text(
                "Phone Number",
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 6),

              TextField(
                controller: phoneController,
                decoration: inputDecoration(
                  suffix: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Change",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// EMAIL
              const Text(
                "Email",
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 6),

              TextField(
                controller: emailController,
                decoration: inputDecoration(),
              ),

              const SizedBox(height: 20),

              /// GENDER
              const Text(
                "Gender",
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: gender,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: const [
                      DropdownMenuItem(
                        value: "Select",
                        child: Text("Select"),
                      ),
                      DropdownMenuItem(
                        value: "Male",
                        child: Text("Male"),
                      ),
                      DropdownMenuItem(
                        value: "Female",
                        child: Text("Female"),
                      ),
                      DropdownMenuItem(
                        value: "Other",
                        child: Text("Other"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 60),

              /// UPDATE BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Update",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration({Widget? suffix}) {
    return InputDecoration(
      suffixIcon: suffix,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
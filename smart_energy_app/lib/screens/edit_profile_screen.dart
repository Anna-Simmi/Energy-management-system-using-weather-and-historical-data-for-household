import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();

  bool loading = false;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    nameController.text = user?.displayName ?? "";
  }

  /// REAUTHENTICATE
  Future<void> reAuth() async {
    final credential = EmailAuthProvider.credential(
      email: user!.email!,
      password: currentPasswordController.text.trim(),
    );

    await user!.reauthenticateWithCredential(credential);
  }

  /// UPDATE PROFILE (name, email, password)
  Future<void> updateProfile() async {
    if (currentPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter current password")));
      return;
    }

    setState(() => loading = true);

    try {
      await reAuth();

      // Update Name
      if (nameController.text.trim().isNotEmpty) {
        await user?.updateDisplayName(nameController.text.trim());
      }

      // Update Email
      if (newEmailController.text.trim().isNotEmpty) {
        await user?.verifyBeforeUpdateEmail(newEmailController.text.trim());
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Verify your new email to complete update")),
        );
      }

      // Update Password
      if (newPasswordController.text.trim().isNotEmpty) {
        await user?.updatePassword(newPasswordController.text.trim());
      }

      await user?.reload();

if (!mounted) return;
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text("Profile updated successfully")),
);

// Force AccountScreen to refresh by reloading currentUser:
Navigator.pop(context, true);


    } on FirebaseAuthException catch (e) {
      String msg = "Update failed";
      if (e.code == "wrong-password") msg = "Wrong current password";
      if (e.code == "weak-password") msg = "Password too weak";
      if (e.code == "email-already-in-use") msg = "Email already used";
      if (e.code == "invalid-email") msg = "Invalid email";
      if (e.code == "requires-recent-login") msg = "Login again to continue";

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // FULL NAME
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // CURRENT PASSWORD
            TextField(
              controller: currentPasswordController,
              obscureText: !showPassword,
              decoration: InputDecoration(
                labelText: "Current Password",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(showPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () =>
                      setState(() => showPassword = !showPassword),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // NEW EMAIL
            TextField(
              controller: newEmailController,
              decoration: const InputDecoration(
                labelText: "New Email (optional)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // NEW PASSWORD
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "New Password (optional)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : updateProfile,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

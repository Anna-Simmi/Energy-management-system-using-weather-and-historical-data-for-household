import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile_screen.dart';

class AccountActionItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;
  final Color? iconBackgroundColor;

  const AccountActionItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
    this.textColor,
    this.iconBackgroundColor,
  });
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  List<AccountActionItem> _actionItems(BuildContext context) {
    return [
      AccountActionItem(
        icon: Icons.person_outline,
        title: 'Edit Profile',
        subtitle: 'Edit your profile information',
        onTap: () {
         Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
).then((updated) async {
  if (updated == true) {
    await FirebaseAuth.instance.currentUser?.reload();
  }
});

        },
        iconBackgroundColor: const Color(0xFFE0EFFF),
        iconColor: Colors.blue,
      ),
    
      AccountActionItem(
        icon: Icons.logout,
        title: 'Logout',
        onTap: () async {
          final navigator = Navigator.of(context);
          await FirebaseAuth.instance.signOut();
          navigator.pushReplacementNamed('/login');
        },
        iconColor: Colors.red,
        textColor: Colors.red,
        iconBackgroundColor: const Color(0xFFFFE0E0),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        final user = FirebaseAuth.instance.currentUser;

        final name = user?.displayName ?? "User";
        final email = user?.email ?? "No Email";

        return Scaffold(
          appBar: AppBar(
            title: const Text("Account", style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                // NO PROFILE PICTURE — ONLY NAME & EMAIL
                Column(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // ACTION ITEMS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: _actionItems(context)
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: AccountListItem(item: item),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AccountListItem extends StatelessWidget {
  final AccountActionItem item;

  const AccountListItem({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: item.iconBackgroundColor ?? const Color(0xFFE0EFFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.icon,
                  color: item.iconColor ?? Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: item.textColor ?? Colors.black87,
                      ),
                    ),
                    if (item.subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          item.subtitle!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              if (item.title != "Logout")
                Icon(Icons.arrow_forward_ios,
                    color: Colors.grey[400], size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/app_constants.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Environment',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Profile Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.background,
                      border: Border.all(
                        color: const Color(0xFFE8ECF0),
                        width: 2,
                      ),
                    ),
                    child: const ClipOval(
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Name & Phone
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nikunjj',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '+91 1234567890',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Edit Icon
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.black,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Menu Items
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _MenuItem(
                      icon: Icons.move_to_inbox_outlined,
                      title: 'Inbox',
                      subtitle: 'orders conversation',
                      onTap: () {},
                    ),
                    _Divider(),
                    _MenuItem(
                      icon: Icons.language_outlined,
                      title: 'App Language',
                      subtitle: 'English',
                      onTap: () {},
                    ),
                    _Divider(),
                    _MenuItem(
                      icon: Icons.link_outlined,
                      title: 'Invite a friend',
                      subtitle: 'Invite via SMS, WhatsApp, etc..',
                      onTap: () {},
                    ),
                    _Divider(),
                    _MenuItem(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: 'Customer Help',
                      subtitle: 'FAQ, Feedback, Chat/Call',
                      onTap: () {},
                    ),
                    _Divider(),
                    _MenuItem(
                      icon: Icons.description_outlined,
                      title: 'Terms, Content and Privacy',
                      subtitle: 'Your data and user rights',
                      onTap: () {},
                    ),
                    _Divider(),
                    _MenuItem(
                      icon: Icons.info_outline_rounded,
                      title: 'About Us',
                      subtitle: 'Who we are',
                      onTap: () {},
                    ),
                    _Divider(),

                    // Logout
                    _MenuItem(
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      subtitle: '',
                      titleColor: AppColors.primary,
                      iconColor: AppColors.primary,
                      onTap: () => _showLogoutDialog(context),
                      showArrow: false,
                    ),
                  ],
                ),
              ),
            ),

            // App Version
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'App Version : 1.0.0',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.lightGrey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Logout',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontFamily: 'Poppins', color: AppColors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Call logout API and navigate to login
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
      color: Color(0xFFF0F0F0),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color titleColor;
  final Color iconColor;
  final bool showArrow;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.titleColor = AppColors.black,
    this.iconColor = AppColors.grey,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),

            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            if (showArrow)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.lightGrey,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
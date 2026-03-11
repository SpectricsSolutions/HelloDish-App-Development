import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_constants.dart';

import '../../auth/login/view/login_screen.dart';
import '../viewmodel/MenuViewModel.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    // Load user info as soon as screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuViewModel>().loadUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuViewModel>(
      builder: (context, vm, _) {
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
                    'Settings',
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vm.userName.isNotEmpty ? vm.userName : '—',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              vm.userPhone.isNotEmpty
                                  ? '${vm.userCountryCode} ${vm.userPhone}'
                                  : '—',
                              style: const TextStyle(
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
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // --- Account Section ---
                          const _SectionHeader(title: 'Account'),
                          _MenuItem(
                            icon: Icons.person_outline_rounded,
                            title: 'Profile',
                            subtitle: 'Manage your personal details',
                            onTap: () {},
                          ),
                          const _Divider(),
                          _MenuItem(
                            icon: Icons.location_on_outlined,
                            title: 'Saved Address',
                            subtitle: 'Home, Work & other addresses',
                            onTap: () {},
                          ),
                          const _Divider(),
                          _MenuItem(
                            icon: Icons.confirmation_num_outlined,
                            title: 'Coupon',
                            subtitle: 'View & apply discount coupons',
                            onTap: () {},
                          ),
                          const _Divider(),
                          _MenuItem(
                            icon: Icons.account_balance_wallet_outlined,
                            title: 'Wallet',
                            subtitle: 'Balance & transactions',
                            onTap: () {},
                          ),

                          // --- Legal Section ---
                          const _SectionHeader(title: 'Legal'),
                          _MenuItem(
                            icon: Icons.policy_outlined,
                            title: 'All Policy',
                            subtitle: 'Terms, privacy & refund policy',
                            onTap: () {},
                          ),

                          // --- Support Section ---
                          const _SectionHeader(title: 'Support'),
                          _MenuItem(
                            icon: Icons.help_outline_rounded,
                            title: 'Help and Support',
                            subtitle: 'FAQ, feedback & more',
                            onTap: () {},
                          ),
                          const _Divider(),
                          _MenuItem(
                            icon: Icons.chat_bubble_outline_rounded,
                            title: 'Live Chat',
                            subtitle: 'Chat with our support team',
                            onTap: () {},
                          ),

                          // --- More Section ---
                          const _SectionHeader(title: 'More'),
                          _MenuItem(
                            icon: Icons.move_to_inbox_outlined,
                            title: 'Inbox',
                            subtitle: 'Orders conversation',
                            onTap: () {},
                          ),
                          const _Divider(),
                          _MenuItem(
                            icon: Icons.link_outlined,
                            title: 'Invite a Friend',
                            subtitle: 'Invite via SMS, WhatsApp, etc..',
                            onTap: () {},
                          ),
                          const _Divider(),
                          _MenuItem(
                            icon: Icons.info_outline_rounded,
                            title: 'About Us',
                            subtitle: 'Who we are',
                            onTap: () {},
                          ),
                          const _Divider(),

                          // Logout
                          _MenuItem(
                            icon: Icons.logout_rounded,
                            title: vm.state == MenuState.loading
                                ? 'Logging out...'
                                : 'Logout',
                            subtitle: '',
                            titleColor: AppColors.primary,
                            iconColor: AppColors.primary,
                            onTap: vm.state == MenuState.loading
                                ? () {}
                                : () => _showLogoutDialog(context, vm),
                            showArrow: false,
                          ),
                        ],
                      ),
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
      },
    );
  }

  void _showLogoutDialog(BuildContext context, MenuViewModel vm) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Poppins', color: AppColors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext); // close dialog first
              final success = await vm.logout();
              if (!context.mounted) return;
              if (success) {
                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const LoginScreen(),
                    transitionDuration: const Duration(milliseconds: 500),
                    transitionsBuilder: (_, animation, __, child) =>
                        FadeTransition(opacity: animation, child: child),
                  ),
                      (route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      vm.errorMessage,
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
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

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.lightGrey,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ─── Divider ──────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  const _Divider();

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

// ─── Menu Item ────────────────────────────────────────────────────────────────

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
// ignore_for_file: prefer_const_constructors

import 'package:agrirent/screens/LanguageSelection.dart';
import 'package:agrirent/screens/profileSettings.dart';
import 'package:flutter/material.dart';
import 'package:agrirent/pages/profile/RentingHistory/RentalHistory.dart';
import 'package:agrirent/pages/profile/PostingHistory/PostingHistory.dart';
import 'package:agrirent/providers/auth_provider.dart';
import 'package:agrirent/screens/auth.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authProvider);
    final user = authNotifier.user;
    String dp = user?.userMetadata?['avatar_url'] ?? '';
    final appLoc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Palette.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Palette.white,
              Palette.grey.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  _buildAppBar(appLoc),
                  const SizedBox(height: 40.0),
                  _buildProfileSection(user, dp),
                  const SizedBox(height: 40.0),
                  _buildMenuSection(context, appLoc),
                  const SizedBox(height: 24.0),
                  _buildSignOutButton(context, appLoc),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(AppLocalizations appLoc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          appLoc.yourProfile,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Palette.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.notifications_outlined, size: 24),
        ),
      ],
    );
  }

  Widget _buildProfileSection(dynamic user, String dp) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 65.0,
                backgroundColor: Palette.white,
                child: dp.isEmpty
                    ? const Icon(Icons.person, size: 65, color: Colors.grey)
                    : ClipOval(
                        child: Image.network(
                          dp,
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, size: 65, color: Colors.grey);
                          },
                        ),
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Palette.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Palette.white, width: 2),
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Palette.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24.0),
        Text(
          user?.email?.split('@')[0] ?? 'User',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          user?.email ?? '',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context, AppLocalizations appLoc) {
    return Column(
      children: [
        _buildOption(context, appLoc.profileSettings, Icons.settings_outlined),
        _buildOption(context, appLoc.rentingHistory, Icons.history_outlined),
        _buildOption(context, appLoc.postingHistory, Icons.post_add_outlined),
        _buildOption(context, appLoc.chooseYourLanguages, Icons.language_outlined),
      ],
    );
  }

  Widget _buildOption(BuildContext context, String optionText, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            if (optionText == AppLocalizations.of(context)!.rentingHistory) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RentalHistoryPage()),
              );
            } else if (optionText == AppLocalizations.of(context)!.postingHistory) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PostingHistoryPage()),
              );
            } else if (optionText == AppLocalizations.of(context)!.chooseYourLanguages) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageSelectionScreen()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileSettingsScreen()),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Palette.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Palette.red, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    optionText,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context, AppLocalizations appLoc) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () async {
            final authNotifier = ref.read(authProvider);
            await authNotifier.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Palette.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.logout, color: Palette.red, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  appLoc.signOut,
                  style: TextStyle(
                    color: Palette.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

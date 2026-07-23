import 'package:flutter/material.dart';
import 'package:saathi/components/horizontal_cards.dart';
import 'package:saathi/pages/blog.dart';
import 'package:saathi/pages/breathe.dart';
import 'package:saathi/pages/cards.dart';
import 'package:saathi/pages/cbt/disclaimer.dart';
import 'package:saathi/pages/chat_screen.dart';
import 'package:saathi/pages/community.dart';
import 'package:saathi/pages/contact_professionals.dart';
import 'package:saathi/pages/journal.dart';
import 'package:saathi/pages/meditation.dart';
import 'package:saathi/pages/mood.dart';
import 'package:saathi/pages/music_player.dart';
import 'package:saathi/pages/sos.dart';
import '../util/exercise_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saathi/themes/app_theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardContent(),
    const CommunityPage(),
    FlashCard(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: SafeArea(
            bottom: false,
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: CustomBottomNavBar(
                selectedIndex: _selectedIndex,
                onItemSelected: _onItemTapped,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreetingName(),
                              style: AppTheme.heading1.copyWith(
                                color: AppTheme.primaryDark,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(
                              height: 8,
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SosScreen()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.accent,
                                borderRadius: BorderRadius.circular(AppTheme.radiusButton),
                              ),
                              padding: const EdgeInsets.all(12.0),
                              child: const Icon(
                                Icons.sos,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.error,
                                borderRadius: BorderRadius.circular(AppTheme.radiusButton),
                              ),
                              padding: const EdgeInsets.all(12.0),
                              child: const Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                          border: Border.all(
                            color: AppTheme.primaryLight,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Journal()));
                          },
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.menu_book,
                                  color: AppTheme.primary,
                                ),
                                const SizedBox(
                                  width: AppTheme.spaceSm,
                                ),
                                Text(
                                  'Journal',
                                  style: AppTheme.heading2.copyWith(color: AppTheme.primary),
                                )
                              ]),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                          border: Border.all(
                            color: AppTheme.primaryLight,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MoodScreen()),
                            );
                          },
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.emoji_emotions,
                                  color: AppTheme.primary,
                                ),
                                const SizedBox(
                                  width: AppTheme.spaceSm,
                                ),
                                Text(
                                  'Mood',
                                  style: AppTheme.heading2.copyWith(color: AppTheme.primary),
                                )
                              ]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset("assets/images/otter.gif",
                            height: 90, width: 80, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18.0, 0, 0, 0),
                              child: Text(
                                'Panda loves to talk!',
                                style: AppTheme.heading2.copyWith(
                                  color: AppTheme.primaryDark,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const ChatScreen()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.primary,
                                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                                  boxShadow: AppTheme.cardShadow,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: AppTheme.spaceXl),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Chat with Panda',
                                      style: AppTheme.button.copyWith(fontSize: 18),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: AppTheme.textOnPrimary,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Looking for something?',
                        style: AppTheme.heading2,
                      ),
                      const Icon(Icons.more_horiz),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  HorizontalCards(items: [
                    CardItem(
                        icon: Icons.self_improvement_sharp,
                        label: 'Meditate',
                        path: const MeditationScreen()),
                    CardItem(
                        icon: Icons.music_note,
                        label: 'Music',
                        path: MusicPlayerPage()),
                    CardItem(
                        icon: Icons.air,
                        label: 'Breathe',
                        path: const BreathingScreen()),
                    CardItem(
                        icon: Icons.menu_book, label: 'CBT', path: Disclaimer()),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Explore',
                      style: AppTheme.heading2,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      ExerciseTile(
                          icon: Icons.favorite,
                          exerciseName: 'Blogs',
                          numberOfExercise: 16,
                          color: Colors.orange,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlogScreen()));
                          }),
                      ExerciseTile(
                          icon: Icons.person,
                          exerciseName: 'Contact Professionals',
                          numberOfExercise: 8,
                          color: Colors.green,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ContactProfessionals()));
                          }),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getGreetingName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        return 'Hello ${user.displayName}!';
      }
      if (user.email != null && user.email!.isNotEmpty) {
        return 'Hello ${user.email!.split('@')[0]}!';
      }
    }
    return 'Hello there!';
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryDark.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.primaryLight,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_rounded, 'Home', 0),
          _buildNavItem(Icons.groups_rounded, 'Community', 1),
          _buildNavItem(Icons.style_rounded, 'Cards', 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => onItemSelected(index),
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? AppTheme.primaryDark : AppTheme.textSecondary.withOpacity(0.6),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.primaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
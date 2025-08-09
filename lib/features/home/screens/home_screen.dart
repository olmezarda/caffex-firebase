import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:caffex_firebase/data/mock/caffes.dart';
import 'package:caffex_firebase/features/home/widgets/caffe_card.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';
import 'package:caffex_firebase/features/home/widgets/caffe_choice_chip.dart';
import 'package:caffex_firebase/features/home/widgets/caffe_list_tile.dart';
import 'package:caffex_firebase/widgets/app_bar.dart';
import 'package:caffex_firebase/data/services/firestore_service.dart';
import 'package:caffex_firebase/widgets/loading_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _profileData;
  bool _loading = true;
  String? _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final data = await FirestoreService().getUserProfile(uid);
    if (mounted) {
      setState(() {
        _profileData = data;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topSellers = caffes.where((c) => c.isTopSeller).take(3).toList();
    final hotCaffes = caffes.where((c) => int.parse(c.id) >= 6).toList();
    final coldCaffes = caffes.where((c) => int.parse(c.id) <= 5).toList();

    final displayedCaffes = _selectedCategory == 'hot'
        ? hotCaffes
        : _selectedCategory == 'cold'
        ? coldCaffes
        : caffes;

    if (_loading || _profileData == null) {
      return const Scaffold(body: Center(child: LoadingIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              name: _profileData!['name'],
              surname: _profileData!['surname'],
              gender: _profileData!['gender'],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingM,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Caffes', style: AppTextStyles.heading1),
              ),
            ),
            const SizedBox(height: AppSizes.spacingS),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingM,
              ),
              child: Row(
                children: [
                  CaffeChoiceChip(
                    label: 'All',
                    imagePath: 'assets/icons/all_caffe.png',
                    isSelected: _selectedCategory == 'all',
                    onTap: () {
                      setState(() => _selectedCategory = 'all');
                    },
                  ),
                  const SizedBox(width: AppSizes.spacingM),
                  CaffeChoiceChip(
                    label: 'Hot Caffe',
                    imagePath: 'assets/icons/hot_caffe.png',
                    isSelected: _selectedCategory == 'hot',
                    onTap: () {
                      setState(() => _selectedCategory = 'hot');
                    },
                  ),
                  const SizedBox(width: AppSizes.spacingM),
                  CaffeChoiceChip(
                    label: 'Cold Caffe',
                    imagePath: 'assets/icons/cold_caffe.png',
                    isSelected: _selectedCategory == 'cold',
                    onTap: () {
                      setState(() => _selectedCategory = 'cold');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spacingS),
            CaffeCardBuilder(caffes: displayedCaffes),
            const SizedBox(height: AppSizes.spacingXL),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingM,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Top Seller Caffes', style: AppTextStyles.heading1),
              ),
            ),
            const SizedBox(height: AppSizes.spacingS),
            CaffeListTile(topSellers: topSellers),
          ],
        ),
      ),
    );
  }
}

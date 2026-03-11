import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_constants.dart';
import '../../location/AddressViewModel.dart';
import '../../location/location_screen.dart';
import '../HomeModel.dart';
import '../HomeViewModel.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _bannerController = PageController();
  int _currentBannerPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressViewModel>().fetchAddresses();
      context.read<HomeViewModel>().fetchHomeData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AddressViewModel, HomeViewModel>(
      builder: (context, addressVm, homeVm, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // ── Top Bar ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LocationScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                addressVm.displayEmoji,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            addressVm.displayType,
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          size: 18,
                                          color: AppColors.black,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      addressVm.displayAddress,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: AppColors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          size: 22,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ── Search Bar ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: AppColors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search restaurant or dish...',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: AppColors.grey.withOpacity(0.8),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: AppColors.grey,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 4,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ── Scrollable Body ──────────────────────────────
                Expanded(
                  child: homeVm.state == HomeState.loading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : homeVm.state == HomeState.error
                      ? _buildErrorState(homeVm)
                      : _buildContent(homeVm),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(HomeViewModel vm) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 56, color: AppColors.grey),
          const SizedBox(height: 12),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            vm.errorMessage,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: vm.fetchHomeData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(HomeViewModel vm) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Banners ─────────────────────────────────────
          if (vm.banners.isNotEmpty) _buildBanners(vm.banners),

          const SizedBox(height: 20),

          // ── Categories ──────────────────────────────────
          if (vm.categories.isNotEmpty) ...[
            _buildSectionHeader('What u have craving for ?', null),
            const SizedBox(height: 12),
            _buildCategories(vm.categories),
            const SizedBox(height: 20),
          ],

          // ── Popular Restaurants ─────────────────────────
          if (vm.popularRestaurants.isNotEmpty) ...[
            _buildSectionHeader('Popular', 'Find More', onTap: () {}),
            const SizedBox(height: 12),
            _buildPopularRestaurants(vm.popularRestaurants),
            const SizedBox(height: 20),
          ],

          // ── All Restaurants ─────────────────────────────
          if (vm.allRestaurants.isNotEmpty) ...[
            _buildSectionHeader('All Restaurants', 'See All', onTap: () {}),
            const SizedBox(height: 12),
            _buildAllRestaurants(vm.allRestaurants),
            const SizedBox(height: 20),
          ],

          // ── Fallback if no data ─────────────────────────
          if (vm.banners.isEmpty &&
              vm.categories.isEmpty &&
              vm.popularRestaurants.isEmpty)
            const SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'No content available',
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Banners (full width) ────────────────────────────────────────────────────
  Widget _buildBanners(List<BannerModel> banners) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: banners.length,
            onPageChanged: (i) => setState(() => _currentBannerPage = i),
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _networkImage(
                    banner.image,
                    height: 160,
                    fit: BoxFit.cover,
                    placeholder: _bannerPlaceholder(banner),
                  ),
                ),
              );
            },
          ),
        ),
        if (banners.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
                  (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentBannerPage == i ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentBannerPage == i
                      ? AppColors.primary
                      : AppColors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _bannerPlaceholder(BannerModel banner) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (banner.title != null)
              Text(
                banner.title!,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            if (banner.subtitle != null)
              Text(
                banner.subtitle!,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Categories ──────────────────────────────────────────────────────────────
  Widget _buildCategories(List<CategoryModel> categories) {
    // Build a grid: up to 2 rows of horizontally scrollable items
    return SizedBox(
      height: categories.length > 4 ? 250 : 120,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: categories.length > 4 ? 2 : 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return _buildCategoryItem(cat);
        },
      ),
    );
  }

  Widget _buildCategoryItem(CategoryModel cat) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF1FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: cat.image.isNotEmpty
                  ? _networkImage(
                cat.image,
                height: 72,
                fit: BoxFit.cover,
                placeholder: Center(
                  child: Text(
                    cat.emoji ?? '🍽️',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              )
                  : Center(
                child: Text(
                  cat.emoji ?? '🍽️',
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            cat.name,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ── Section Header ──────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, String? actionLabel,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.contains('\n') ? title.split('\n')[0] : '',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: AppColors.grey,
                ),
              ),
              Text(
                title.contains('\n') ? title.split('\n')[1] : title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          if (actionLabel != null)
            GestureDetector(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Find',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                  Text(
                    actionLabel,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ── Popular Restaurants (horizontal scroll) ─────────────────────────────────
  Widget _buildPopularRestaurants(List<RestaurantModel> restaurants) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          return _buildPopularCard(restaurants[index]);
        },
      ),
    );
  }

  Widget _buildPopularCard(RestaurantModel r) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(14)),
                child: _networkImage(
                  r.image,
                  height: 110,
                  fit: BoxFit.cover,
                  width: 160,
                  placeholder: Container(
                    height: 110,
                    width: 160,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.restaurant,
                        size: 40, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.favorite_border_rounded,
                      size: 16, color: AppColors.primary),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (r.cuisine != null)
                  Text(
                    r.cuisine!,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: AppColors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star_rounded,
                        size: 13, color: Colors.amber.shade600),
                    const SizedBox(width: 2),
                    Text(
                      r.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.access_time_rounded,
                        size: 12, color: AppColors.grey),
                    const SizedBox(width: 2),
                    Text(
                      '${r.deliveryTime} min',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── All Restaurants (vertical list) ────────────────────────────────────────
  Widget _buildAllRestaurants(List<RestaurantModel> restaurants) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: restaurants.length,
      itemBuilder: (context, index) => _buildRestaurantListItem(restaurants[index]),
    );
  }

  Widget _buildRestaurantListItem(RestaurantModel r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
            child: _networkImage(
              r.image,
              height: 90,
              width: 90,
              fit: BoxFit.cover,
              placeholder: Container(
                height: 90,
                width: 90,
                color: Colors.grey.shade200,
                child: const Icon(Icons.restaurant, size: 32, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.name,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (r.cuisine != null)
                    Text(
                      r.cuisine!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star_rounded,
                          size: 14, color: Colors.amber.shade600),
                      const SizedBox(width: 2),
                      Text(
                        r.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.access_time_rounded,
                          size: 13, color: AppColors.grey),
                      const SizedBox(width: 2),
                      Text(
                        '${r.deliveryTime} min',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                      if (r.deliveryFee != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          r.deliveryFee!,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (!r.isOpen)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Closed',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Network Image Helper ────────────────────────────────────────────────────
  Widget _networkImage(
      String url, {
        required double height,
        double? width,
        BoxFit fit = BoxFit.cover,
        required Widget placeholder,
      }) {
    if (url.isEmpty) return placeholder;
    return Image.network(
      url,
      height: height,
      width: width,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: height,
          width: width,
          color: Colors.grey.shade100,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => placeholder,
    );
  }
}
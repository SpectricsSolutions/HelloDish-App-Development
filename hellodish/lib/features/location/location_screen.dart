import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_constants.dart';
import 'AddressModel.dart';
import 'AddressViewModel.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query, AddressViewModel vm) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      vm.searchPlaces(query);
    });
  }

  void _onSearchResultTap(
      BuildContext context, Map<String, dynamic> place, AddressViewModel vm) {
    // Create a temporary AddressModel from the search result
    final selected = AddressModel(
      id: '',
      addressType: 'other',
      address: place['display_name'] ?? '',
      latitude: place['lat'] ?? '',
      longitude: place['lon'] ?? '',
      userId: '',
      contactPersonName: '',
      contactPersonNumber: '',
      countryCode: '+91',
    );
    vm.selectAddress(selected);
    vm.clearSearch();
    _searchController.clear();
    Navigator.pop(context);
  }

  void _onSavedAddressTap(
      BuildContext context, AddressModel address, AddressViewModel vm) {
    vm.selectAddress(address);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressViewModel>(
      builder: (context, vm, _) {
        final bool showSearchResults =
            _searchController.text.isNotEmpty;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new,
                            size: 18, color: AppColors.black),
                      ),
                      const Text(
                        'Search your area',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ── Search Box ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: false,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: AppColors.black,
                      ),
                      onChanged: (v) => _onSearchChanged(v, vm),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: AppColors.lightGrey,
                        ),
                        prefixIcon: const Icon(Icons.search,
                            color: AppColors.grey, size: 20),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.close,
                              size: 18, color: AppColors.grey),
                          onPressed: () {
                            _searchController.clear();
                            vm.clearSearch();
                            setState(() {});
                          },
                        )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      onSubmitted: (_) => setState(() {}),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ── Body ─────────────────────────────────────────
                Expanded(
                  child: showSearchResults
                      ? _buildSearchResults(vm)
                      : _buildDefaultContent(vm, context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Search results list ───────────────────────────────────────
  Widget _buildSearchResults(AddressViewModel vm) {
    if (vm.isSearching) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (vm.searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 52, color: AppColors.lightGrey.withOpacity(0.6)),
            const SizedBox(height: 12),
            Text(
              'No results found',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: AppColors.grey.withOpacity(0.8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: vm.searchResults.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        color: Color(0xFFF0F0F0),
        indent: 44,
      ),
      itemBuilder: (context, index) {
        final place = vm.searchResults[index] as Map<String, dynamic>;
        final displayName = place['display_name'] as String? ?? '';
        final parts = displayName.split(',');
        final title = parts.isNotEmpty ? parts[0].trim() : displayName;
        final subtitle =
        parts.length > 1 ? parts.sublist(1).join(',').trim() : '';

        return ListTile(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.location_on_outlined,
                size: 18, color: AppColors.primary),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: subtitle.isNotEmpty
              ? Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: AppColors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
              : null,
          onTap: () => _onSearchResultTap(
              context, place, vm),
        );
      },
    );
  }

  // ── Default content: use current location + saved addresses ───
  Widget _buildDefaultContent(AddressViewModel vm, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use current location
          InkWell(
            onTap: () {
              // TODO: Implement GPS current location
            },
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.my_location_rounded,
                        size: 18, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Use current location',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Saved addresses header
          if (vm.hasAddress) ...[
            Padding(
              padding:
              const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Saved address',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey,
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFDDDDDD)),
                    ),
                    child: const Icon(Icons.add,
                        size: 16, color: AppColors.black),
                  ),
                ],
              ),
            ),

            // Address cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: vm.addresses.length,
              itemBuilder: (context, index) {
                final address = vm.addresses[index];
                final isSelected = vm.selectedAddress?.id == address.id;
                return _AddressCard(
                  address: address,
                  isSelected: isSelected,
                  onTap: () =>
                      _onSavedAddressTap(context, address, vm),
                );
              },
            ),

            const SizedBox(height: 16),
          ],

          // Empty state
          if (!vm.hasAddress &&
              vm.state == AddressState.success) ...[
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Icon(Icons.location_off_outlined,
                      size: 52,
                      color: AppColors.lightGrey.withOpacity(0.6)),
                  const SizedBox(height: 12),
                  const Text(
                    'No saved addresses yet',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Loading
          if (vm.state == AddressState.loading)
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Address Card ──────────────────────────────────────────────────────────────

class _AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddressCard({
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE8ECF0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 2),
            )
          ]
              : null,
        ),
        child: Row(
          children: [
            Text(address.typeEmoji,
                style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringExt(address.addressType).capitalize(),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  if (address.address.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      address.shortAddress,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz,
                  color: AppColors.grey, size: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                // TODO: handle edit / remove
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Text('Remove',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension _StringExt on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
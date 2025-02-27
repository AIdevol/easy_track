import 'dart:io';
import 'package:app_task/app/presentation/profile/bloc/profile_view_screen_bloc.dart';
import 'package:app_task/app/presentation/profile/bloc/profile_view_screen_event.dart';
import 'package:app_task/app/presentation/profile/bloc/profile_view_screen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../utilities/neomorphic_monthly_date.dart';

class ProfileScreenView extends StatelessWidget {
  const ProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileViewScreenBloc(),
      child: BlocConsumer<ProfileViewScreenBloc, ProfileViewScreenState>(
        listener: (context, state) {
          if (state is ImageErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: appColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _mainScreen(context, state),
                  _buildNeumorphicGrid(),
                  // MonthsCalendarView(),
                  _buildSettingsSection(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _mainScreen(BuildContext context, ProfileViewScreenState state) {
    String? imagePath;
    if (state is ImageCroppedState) {
      imagePath = state.croppedImagePath;
    }

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          _buildTopBar(context),
          const Gap(20),
          _buildProfileHeader(context, state, imagePath),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_back),
        ),
        const Gap(10),
        const Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    ProfileViewScreenState state,
    String? imagePath,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "John Doe",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "john.doe@example.com",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
        _buildProfileImage(context, state, imagePath),
      ],
    );
  }

  Widget _buildProfileImage(
    BuildContext context,
    ProfileViewScreenState state,
    String? imagePath,
  ) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            backgroundImage: imagePath != null
                ? FileImage(File(imagePath))
                : const AssetImage(appIcon) as ImageProvider,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _showImagePickerModal(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: state is ImageProcessingState
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: Colors.white,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNeumorphicGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: _buildNeumorphicDecoration(),
        child: SizedBox(
          height: 170,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 40,
            itemBuilder: (_, __) => Container(
              height: 20,
              width: 20,
              decoration: _buildNeumorphicDecoration(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      children: [
        _buildSettingsTile(
          icon: Icons.person,
          title: "Profile Settings",
          onTap: () {},
        ),
        _buildSettingsTile(
          icon: Icons.settings,
          title: "Settings",
          onTap: () {
            context.go('/settings');
          },
        ),
        _buildSettingsTile(
          icon: Icons.price_change_rounded,
          title: "Pricing",
          onTap: () {},
        ),
        _buildSettingsTile(
          icon: Icons.help,
          title: "Terms & Conditions",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: _buildNeumorphicDecoration(),
          child: Row(
            children: [
              Icon(icon, size: 24),
              const Gap(16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePickerModal(BuildContext context) {
    final bloc = context.read<ProfileViewScreenBloc>();

    showModalBottomSheet(
      context: context,
      backgroundColor: appColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => BlocProvider.value(
        value: bloc,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Change Profile Picture',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(bottomSheetContext),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImagePickerOption(
                    context: bottomSheetContext,
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () {
                      bloc.add(CaptureImageEvent());
                      Navigator.pop(bottomSheetContext);
                    },
                  ),
                  _buildImagePickerOption(
                    context: bottomSheetContext,
                    icon: Icons.folder,
                    label: 'Gallery',
                    onTap: () {
                      bloc.add(SelectImageEvent());
                      Navigator.pop(bottomSheetContext);
                    },
                  ),
                ],
              ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 60,
              color: Colors.grey,
            ),
          ),
          const Gap(8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildNeumorphicDecoration() {
    return BoxDecoration(
      color: appColor,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          offset: const Offset(-3, -3),
          blurRadius: 5,
        ),
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          offset: const Offset(3, 3),
          blurRadius: 5,
        ),
      ],
    );
  }
}

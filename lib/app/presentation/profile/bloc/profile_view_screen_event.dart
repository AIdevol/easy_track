// profile_view_screen_event.dart
import 'package:flutter/material.dart';

@immutable
sealed class ProfileViewScreenEvent {}

class CaptureImageEvent extends ProfileViewScreenEvent {}
class SelectImageEvent extends ProfileViewScreenEvent {}
class CropImageEvent extends ProfileViewScreenEvent {
  final String imagePath;
  CropImageEvent(this.imagePath);
}
class SaveProfileImageEvent extends ProfileViewScreenEvent {
  final String croppedImagePath;
  SaveProfileImageEvent(this.croppedImagePath);
}

import 'package:flutter/cupertino.dart';

@immutable
sealed class ProfileViewScreenState {}

class ProfileViewScreenInitial extends ProfileViewScreenState {}
class ImageProcessingState extends ProfileViewScreenState {}
class ImageSelectedState extends ProfileViewScreenState {
  final String imagePath;
  ImageSelectedState(this.imagePath);
}
class ImageCroppedState extends ProfileViewScreenState {
  final String croppedImagePath;
  ImageCroppedState(this.croppedImagePath);
}
class ImageErrorState extends ProfileViewScreenState {
  final String error;
  ImageErrorState(this.error);
}
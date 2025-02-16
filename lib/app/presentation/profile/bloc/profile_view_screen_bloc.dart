import 'package:app_task/app/presentation/profile/bloc/profile_view_screen_event.dart';
import 'package:app_task/app/presentation/profile/bloc/profile_view_screen_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../../../constants/colors.dart';

class ProfileViewScreenBloc
    extends Bloc<ProfileViewScreenEvent, ProfileViewScreenState> {
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();

  ProfileViewScreenBloc() : super(ProfileViewScreenInitial()) {
    on<CaptureImageEvent>(_handleCaptureImage);
    on<SelectImageEvent>(_handleSelectImage);
    on<CropImageEvent>(_handleCropImage);
    on<SaveProfileImageEvent>(_handleSaveProfileImage);
  }

  Future<void> _handleCaptureImage(
    CaptureImageEvent event,
    Emitter<ProfileViewScreenState> emit,
  ) async {
    try {
      emit(ImageProcessingState());
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        add(CropImageEvent(image.path));
      } else {
        emit(ProfileViewScreenInitial());
      }
    } catch (e) {
      emit(ImageErrorState('Failed to capture image: $e'));
      print("failed");
    }
  }

  Future<void> _handleSelectImage(
    SelectImageEvent event,
    Emitter<ProfileViewScreenState> emit,
  ) async {
    try {
      emit(ImageProcessingState());
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        add(CropImageEvent(image.path));
      } else {
        emit(ProfileViewScreenInitial());
      }
    } catch (e) {
      emit(ImageErrorState('Failed to select image: $e'));
    }
  }

  Future<void> _handleCropImage(
    CropImageEvent event,
    Emitter<ProfileViewScreenState> emit,
  ) async {
    try {
      final croppedFile = await _cropper.cropImage(
        sourcePath: event.imagePath,
        // aspectRatioPresets: [
        //   CropAspectRatioPreset.square,
        // ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: appColor,
            toolbarWidgetColor: Colors.black,
            backgroundColor: appColor,
            initAspectRatio: CropAspectRatioPreset.square,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            cancelButtonTitle: 'Cancel',
            doneButtonTitle: 'Done',
            aspectRatioLockEnabled: true,
            aspectRatioPickerButtonHidden: true,
          ),
        ],
      );

      if (croppedFile != null) {
        emit(ImageCroppedState(croppedFile.path));
        add(SaveProfileImageEvent(croppedFile.path));
      } else {
        emit(ProfileViewScreenInitial());
      }
    } catch (e) {
      emit(ImageErrorState('Failed to crop image: $e'));
    }
  }

  Future<void> _handleSaveProfileImage(
    SaveProfileImageEvent event,
    Emitter<ProfileViewScreenState> emit,
  ) async {
    try {
      // TODO: Implement save logic (e.g., to local storage or backend)
      // For now, we'll just keep showing the cropped image
      emit(ImageCroppedState(event.croppedImagePath));
    } catch (e) {
      emit(ImageErrorState('Failed to save image: $e'));
    }
  }
}

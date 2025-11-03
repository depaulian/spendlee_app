import 'dart:async';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';
import 'package:expense_tracker/src/repository/authentication_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileUpdateController extends GetxController {
  static ProfileUpdateController get instance => Get.find();

  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final authenticationRepo = AuthenticationRepository.instance;
  final authRepo = AuthRepository.instance;

  final isLoading = false.obs;
  final isCheckingUsername = false.obs;
  final usernameAvailable = true.obs;
  final usernameError = ''.obs;
  final isUsernameValid = false.obs;
  final usernameSuggestions = <String>[].obs;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserData();
  }

  @override
  void onClose() {
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  void _loadCurrentUserData() {
    final user = authenticationRepo.appUser;
    if (user != null) {
      usernameController.text = user.username ?? '';
      firstNameController.text = user.firstName ?? '';
      lastNameController.text = user.lastName ?? '';
      
      // Set initial username as valid if it's the current username
      if ((user.username ?? '').isNotEmpty) {
        isUsernameValid.value = true;
        usernameAvailable.value = true;
      }
    }
  }

  void checkUsernameAvailability(String username) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (username.isEmpty) {
      usernameError.value = 'Username is required';
      isUsernameValid.value = false;
      usernameAvailable.value = false;
      usernameSuggestions.clear();
      return;
    }

    if (username.length < 3) {
      usernameError.value = 'Username must be at least 3 characters';
      isUsernameValid.value = false;
      usernameAvailable.value = false;
      usernameSuggestions.clear();
      return;
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      usernameError.value = 'Username can only contain letters, numbers, and underscores';
      isUsernameValid.value = false;
      usernameAvailable.value = false;
      usernameSuggestions.clear();
      return;
    }

    // Check if it's the same as current username
    if (username.toLowerCase() == (authenticationRepo.getUsername ?? '').toLowerCase()) {
      usernameError.value = '';
      isUsernameValid.value = true;
      usernameAvailable.value = true;
      usernameSuggestions.clear();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 800), () async {
      isCheckingUsername.value = true;
      usernameError.value = '';
      usernameSuggestions.clear();

      try {
        final result = await authRepo.checkEmailAvailability(username: username);

        if (result['status']) {
          final usernameData = result['data']['username'];
          
          if (usernameData['available']) {
            usernameAvailable.value = true;
            usernameError.value = '';
            isUsernameValid.value = true;
          } else {
            usernameAvailable.value = false;
            usernameError.value = 'Username is already taken';
            isUsernameValid.value = false;
            
            // Get suggestions
            if (usernameData['suggestions'] != null) {
              usernameSuggestions.value = List<String>.from(usernameData['suggestions']);
            }
          }
        } else {
          usernameError.value = 'Could not verify username';
          isUsernameValid.value = false;
        }
      } catch (e) {
        usernameError.value = 'Network error';
        isUsernameValid.value = false;
      } finally {
        isCheckingUsername.value = false;
      }
    });
  }

  void selectSuggestion(String suggestion) {
    usernameController.text = suggestion;
    checkUsernameAvailability(suggestion);
  }

  bool get hasChanges {
    final user = authenticationRepo.appUser;
    if (user == null) return false;

    return usernameController.text != (user.username ?? '') ||
           firstNameController.text != (user.firstName ?? '') ||
           lastNameController.text != (user.lastName ?? '');
  }

  Future<void> updateProfile() async {
    if (!isUsernameValid.value) {
      Get.snackbar(
        'Error',
        'Please enter a valid username',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (firstNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'First name is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (lastNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Last name is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!hasChanges) {
      Get.snackbar(
        'Info',
        'No changes to save',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final result = await authRepo.updateUserProfile(
        username: usernameController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
      );

      if (result['status']) {
        // Update the user data in AuthenticationRepository
        await authenticationRepo.initializeApp();
        
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate back to settings
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
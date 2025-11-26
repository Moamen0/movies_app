// lib/bloc/profile/profile_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/api/auth_api.dart';
import 'package:movies_app/bloc/profile/profile_event.dart';
import 'package:movies_app/bloc/profile/profile_state.dart';
import 'package:movies_app/utils/app_assets.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<UpdateAvatarEvent>(_onUpdateAvatar);
    on<DeleteProfileEvent>(_onDeleteProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      print("🔹 ProfileBloc: Loading profile...");
      
      // First check if user has a token
      final token = await AuthMangerApi.getToken();
      print("🔹 ProfileBloc: Token exists: ${token != null}");
      
      if (token == null || token.isEmpty) {
        print("❌ ProfileBloc: No token found - user not logged in");
        
        // Try to load from local storage as fallback
        final localUser = await AuthMangerApi.getUserData();
        if (localUser != null) {
          final avatarPath = localUser.avaterId != null
              ? 'assets/images/avatar${localUser.avaterId}.png'
              : AppAssets.avatar1;
          print("✅ ProfileBloc: Loaded from local storage (no token)");
          emit(ProfileLoaded(user: localUser, avatarPath: avatarPath));
        } else {
          emit(ProfileError(message: "Please login to view your profile"));
        }
        return;
      }
      
      print("🔹 ProfileBloc: Calling getProfile API...");
      final response = await AuthMangerApi.getProfile();
      
      print("🔹 ProfileBloc: Response success: ${response.success}");
      print("🔹 ProfileBloc: Response message: ${response.message}");
      print("🔹 ProfileBloc: Response data type: ${response.data?.runtimeType}");
      
      if (response.success && response.data != null) {
        // API returned user data successfully
        final user = response.data!;
        
        // Save to local storage for offline access
        await AuthMangerApi.saveUserData(user);
        
        final avatarPath = user.avaterId != null
            ? 'assets/images/avatar${user.avaterId}.png'
            : AppAssets.avatar1;
        
        print("✅ ProfileBloc: Profile loaded from API");
        print("   - Name: ${user.name}");
        print("   - Email: ${user.email}");
        print("   - Phone: ${user.phone}");
        print("   - Avatar ID: ${user.avaterId}");
        print("   - Avatar Path: $avatarPath");
        
        emit(ProfileLoaded(user: user, avatarPath: avatarPath));
      } else {
        // API failed, try local storage
        print("⚠️ ProfileBloc: API failed, trying local storage...");
        print("   - API Message: ${response.message}");
        
        final localUser = await AuthMangerApi.getUserData();
        if (localUser != null) {
          final avatarPath = localUser.avaterId != null
              ? 'assets/images/avatar${localUser.avaterId}.png'
              : AppAssets.avatar1;
          
          print("✅ ProfileBloc: Loaded from local storage");
          print("   - Name: ${localUser.name}");
          
          emit(ProfileLoaded(user: localUser, avatarPath: avatarPath));
        } else {
          print("❌ ProfileBloc: No local data available");
          
          // Show appropriate error message
          String errorMessage = response.message ?? "Failed to load profile";
          if (errorMessage.contains("session ended") || errorMessage.contains("401")) {
            errorMessage = "Session expired. Please login again.";
          }
          
          emit(ProfileError(message: errorMessage));
        }
      }
    } catch (e) {
      print("❌ ProfileBloc: Exception occurred: $e");
      print("   - Exception type: ${e.runtimeType}");
      
      // Try to recover from local storage
      final localUser = await AuthMangerApi.getUserData();
      if (localUser != null) {
        final avatarPath = localUser.avaterId != null
            ? 'assets/images/avatar${localUser.avaterId}.png'
            : AppAssets.avatar1;
        
        print("✅ ProfileBloc: Recovered from local storage after error");
        emit(ProfileLoaded(user: localUser, avatarPath: avatarPath));
      } else {
        print("❌ ProfileBloc: Complete failure - no data anywhere");
        emit(ProfileError(message: "Error loading profile. Please try again."));
      }
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is ProfileLoaded) {
      emit(ProfileUpdating(
        currentUser: currentState.user,
        currentAvatarPath: currentState.avatarPath,
      ));

      try {
        final response = await AuthMangerApi.updateProfile(
          name: event.name,
          phone: event.phone,
          avatar: event.avatar,
        );

        if (response.success) {
          final avaterId = event.avatar != null ? int.parse(event.avatar!) : null;
          
          final updatedUser = currentState.user.copyWith(
            name: event.name,
            phone: event.phone,
            avaterId: avaterId,
          );

          await AuthMangerApi.saveUserData(updatedUser);

          final avatarPath = avaterId != null
              ? 'assets/images/avatar$avaterId.png'
              : currentState.avatarPath;

          emit(ProfileUpdateSuccess(
            user: updatedUser,
            avatarPath: avatarPath,
            message: response.message ?? "Profile updated successfully",
          ));

          // Return to loaded state
          emit(ProfileLoaded(user: updatedUser, avatarPath: avatarPath));
        } else {
          emit(ProfileError(
            message: response.message ?? "Failed to update profile",
            user: currentState.user,
            avatarPath: currentState.avatarPath,
          ));
          emit(ProfileLoaded(
            user: currentState.user,
            avatarPath: currentState.avatarPath,
          ));
        }
      } catch (e) {
        emit(ProfileError(
          message: "Error occurred: ${e.toString()}",
          user: currentState.user,
          avatarPath: currentState.avatarPath,
        ));
        emit(ProfileLoaded(
          user: currentState.user,
          avatarPath: currentState.avatarPath,
        ));
      }
    }
  }

  Future<void> _onUpdateAvatar(
    UpdateAvatarEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is ProfileLoaded) {
      // Update avatar immediately in UI
      emit(currentState.copyWith(avatarPath: event.avatarPath));
    }
  }

  Future<void> _onDeleteProfile(
    DeleteProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is ProfileLoaded) {
      emit(ProfileUpdating(
        currentUser: currentState.user,
        currentAvatarPath: currentState.avatarPath,
      ));

      try {
        final response = await AuthMangerApi.deleteProfile();

        if (response.success) {
          emit(ProfileDeleted());
        } else {
          emit(ProfileError(
            message: response.message ?? "Failed to delete account",
            user: currentState.user,
            avatarPath: currentState.avatarPath,
          ));
          emit(ProfileLoaded(
            user: currentState.user,
            avatarPath: currentState.avatarPath,
          ));
        }
      } catch (e) {
        emit(ProfileError(
          message: "Error occurred: ${e.toString()}",
          user: currentState.user,
          avatarPath: currentState.avatarPath,
        ));
        emit(ProfileLoaded(
          user: currentState.user,
          avatarPath: currentState.avatarPath,
        ));
      }
    }
  }
}
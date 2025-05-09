import 'dart:async';

import 'package:dio/dio.dart';
import 'package:shevarms_user/shared/shared.dart';

class AuthService {
  final DioClient _dioClient = DioClient();

  Future<User> login({required String email, required String password}) async {
    const endpoint = ApiConstants.postLogin;
    try {
      final response = await _dioClient.post(
        endpoint,
        data: {
          'email': email,
          'password': password,
        },
      );
      // await Future.delayed(const Duration(seconds: 2));
      // var response = {
      //   'token': "modjfioewd",
      //   'staff': User(
      //     firstName: "Idris",
      //     lastName: "Suleiman",
      //     phone: "08012345678",
      //     id: "1234",
      //     location: "Security Post",
      //     designation: "Head of Security",
      //     placeOfWork: "Government House",
      //     userType: UserType.seniorStaff,
      //     updatedAt: DateTime.now(),
      //     createdAt: DateTime.now(),
      //     accessGate: 'Gate One',
      //   ).toMap()
      // };
      User user = User.fromMap(response['staff'] as Map<String, dynamic>)
          .copyWith(userType: UserType.deptAdmin);
      String? token = response['token'] as String?;
      if (token != null) {
        _dioClient.initToken(token);
      }
      return user;
    } catch (e, s) {
      print("Login error:$e");
      print(s);
      throw e.toString();
    }
  }

  Future<User> registerUser({
    required String picture,
    required String firstName,
    required String lastName,
    required String placeOfWork,
    required String designation,
    required String email,
    required String phone,
    required String password,
    required String location,
    required String accessGate,
    required UserType userType,
  }) async {
    const endpoint = ApiConstants.postRegisterUser;
    try {
      var formData = FormData.fromMap({
        'firstName': firstName,
        'lastName': lastName,
        'placeOfWork': placeOfWork,
        'designation': designation,
        'email': email,
        'phone': phone,
        'password': password,
        'location': location,
        'accessGate': accessGate,
        'userType': userType.name,
      });
      if (picture.isNotEmpty && !picture.startsWith("http")) {
        formData.files.add(MapEntry(
            'picture',
            MultipartFile.fromFileSync(picture,
                filename: picture.split("/").last)));
      }

      final response = await _dioClient.post(
        endpoint,
        data: formData,
      );
      ApiResponse apiResponse =
          ApiResponse.fromMap(response, dataField: 'staff');

      return User.fromMap(apiResponse.data);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> changePassword(
      {required String userId,
      required String oldPassword,
      required String newPassword}) async {
    final endpoint = ApiConstants.patchChangePassword(userId);
    try {
      final response = await _dioClient.patch(
        endpoint,
        data: {'oldPassword': oldPassword, 'newPassword': newPassword},
      );
      ApiResponse apiResponse =
          ApiResponse.fromMap(response, dataField: 'data');

      return apiResponse.ok ?? false;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> changePicture(
      {required String userId, required String imagePath}) async {
    final endpoint = ApiConstants.patchChangePicture(userId);
    try {
      var formData = FormData.fromMap({});
      formData.files.add(MapEntry(
          'picture',
          MultipartFile.fromFileSync(imagePath,
              filename: imagePath.split("/").last)));
      final response = await _dioClient.patch(
        endpoint,
        data: formData,
      );
      ApiResponse apiResponse =
          ApiResponse.fromMap(response, dataField: 'staff');

      if (apiResponse.ok ?? false) {
        return User.fromMap(apiResponse.data as Map<String, dynamic>).picture;
      } else {
        throw apiResponse.message ?? "An error occurred, please try again";
      }
    } catch (e) {
      throw e.toString();
    }
  }
}

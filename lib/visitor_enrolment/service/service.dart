import 'package:dio/dio.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/visitor_enrolment/visitor_enrolment.dart';

class VisitorsService {
  final DioClient _dioClient = DioClient();

  Future<List<VisitorModel>> getVisitors(
      {int page = 1, int pageSize = 10}) async {
    const apiEndpoint = ApiConstants.getVisitors;
    final result = await _dioClient.get(apiEndpoint);
    ApiResponse response = ApiResponse.fromMap(result, dataField: 'guests');
    final visitors = VisitorModel.fromMapArray(response.data as List);
    return visitors;
  }

  Future<List<VisitorModel>> searchVisitorsByPhone(String phone,
      {int page = 1, int pageSize = 10}) async {
    final apiEndpoint = ApiConstants.searchVisitorsByPhone(phone);
    final result = await _dioClient.get(apiEndpoint);
    ApiResponse response = ApiResponse.fromMap(result, dataField: 'guest');
    if (response.data != null) {
      final visitors = VisitorModel.fromMapArray(response.data);
      return visitors;
    }
    return [];
  }

  Future<VisitorModel> createVisitor(
      {required String firstName,
      required String lastName,
      required String phone,
      String? email,
      String? placeOfWork,
      String? designation,
      String? picture}) async {
    const apiEndpoint = ApiConstants.postRegisterVisitor;
    var formData = FormData.fromMap({
      'firstName': firstName,
      'lastName': lastName,
      'placeOfWork': placeOfWork,
      'designation': designation,
      'email': email,
      'phone': phone,
      'status': 'active',
    });
    if (picture != null && picture.isNotEmpty && !picture.startsWith("http")) {
      formData.files.add(MapEntry(
          'picture',
          MultipartFile.fromFileSync(picture,
              filename: picture.split("/").last)));
    }
    final result = await _dioClient.post(apiEndpoint, data: formData);
    final response = ApiResponse.fromMap(result, dataField: 'guest');
    return VisitorModel.fromMap(response.data);
  }

  Future<VisitorModel> updateVisitor(String id,
      {required String firstName,
      required String lastName,
      required String phone,
      String? email,
      String? placeOfWork,
      String? designation,
      String? picture}) async {
    final apiEndpoint = ApiConstants.postUpdateVisitor.replaceAll(":id", id);
    var formData = FormData.fromMap({
      'firstName': firstName,
      'lastName': lastName,
      'placeOfWork': placeOfWork,
      'designation': designation,
      'email': email,
      'phone': phone,
      'status': 'active',
    });
    if (picture != null && picture.isNotEmpty && !picture.startsWith("http")) {
      formData.files.add(MapEntry(
          'picture',
          MultipartFile.fromFileSync(picture,
              filename: picture.split("/").last)));
    }
    final result = await _dioClient.put(apiEndpoint, data: formData);
    final response = ApiResponse.fromMap(result, dataField: 'guest');
    return VisitorModel.fromMap(response.data);
  }
}

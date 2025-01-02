import 'package:shevarms_user/dashboard_control/dashboard_control.dart';
import 'package:shevarms_user/shared/shared.dart';

class DashboardControlService {
  final DioClient _dioClient = DioClient();

  Future<DashboardTvModel> getMyDashboard() async {
    try {
      return DashboardTvModel(
          id: '12',
          name: "test",
          username: "test",
          password: "password",
          location: "location");
      final response = await _dioClient.get(
        ApiConstants.getMyDashboardTv,
      );
      ApiResponse apiResponse =
          ApiResponse.fromMap(response, dataField: 'dashboard');

      if (apiResponse.ok ?? false) {
        return DashboardTvModel.fromMap(apiResponse.data);
      } else {
        throw apiResponse.message ?? "An unknown error occurred";
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<DashboardTvModel> createDashboard(
      {String? name,
      String? username,
      String? location,
      String? password}) async {
    try {
      return DashboardTvModel(
        id: '123',
        name: "test",
        username: "test",
        password: "password",
        location: "location",
      );
      final response = await _dioClient.post(
        ApiConstants.createMyDashboardTv,
        data: {
          "name": name,
          "username": username,
          "password": password,
          "location": location,
        },
      );
      ApiResponse apiResponse =
          ApiResponse.fromMap(response, dataField: 'dashboard');

      if (apiResponse.ok ?? false) {
        return DashboardTvModel.fromMap(apiResponse.data);
      } else {
        throw apiResponse.message ?? "An unknown error occurred";
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/waiting_rooms/waiting_rooms.dart';

class LocationService {
  final _dioClient = DioClient();

  Future<List<LocationModel>> searchLocation(String searchQuery) async {
    final result = await _dioClient.get(ApiConstants.getLocations);
    ApiResponse response = ApiResponse.fromMap(result, dataField: 'locations');
    return LocationModel.fromJsonArray(response.data);
  }
}

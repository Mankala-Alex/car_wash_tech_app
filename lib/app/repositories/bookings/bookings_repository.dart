import 'package:dio/dio.dart';
import '../../services/api_service.dart';
import '../../services/endpoints.dart';

class BookingsRepository {
  //login
  Future<Response> postAcceptBooking(requestBody) async {
    return await ApiService.post(EndPoints.apipostacceptbookings, requestBody,
        requireAuthToken: false);
  }

  Future<Response> postRejectBooking(requestBody) async {
    return await ApiService.post(EndPoints.apipostrejectbookings, requestBody,
        requireAuthToken: false);
  }

  Future<Response> postStartWashing(requestBody) async {
    return await ApiService.post(EndPoints.apipoststartwashing, requestBody,
        requireAuthToken: false);
  }

  Future<Response> getApiPendingBokkings() async {
    return await ApiService.get(EndPoints.apigetpendingbookings);
  }

  Future<Response> postCompleteBooking(requestBody) async {
    return await ApiService.post(EndPoints.apipostcompletebookings, requestBody,
        requireAuthToken: false);
  }

  Future<Response> getApiBookingHistory({
    Map<String, dynamic>? query,
  }) async {
    return await ApiService.get(
      EndPoints.apigetbookinghistory,
      queryParameters: query,
    );
  }
}

import 'package:dio/dio.dart';
import '../../services/api_service.dart';
import '../../services/endpoints.dart';

class BookingsRepository {
  Future<Response> postAcceptBooking(requestBody) async {
    return await ApiService.post(
      EndPoints.apipostacceptbookings,
      requestBody,
      requireAuthToken: true, // ✅
    );
  }

  Future<Response> postRejectBooking(requestBody) async {
    return await ApiService.post(
      EndPoints.apipostrejectbookings,
      requestBody,
      requireAuthToken: true, // ✅
    );
  }

  Future<Response> postStartWashing(requestBody) async {
    return await ApiService.post(
      EndPoints.apipoststartwashing,
      requestBody,
      requireAuthToken: true, // ✅
    );
  }

  Future<Response> postArrivedBooking(requestBody) async {
    return await ApiService.post(
      EndPoints.apipostarrivedbookings,
      requestBody,
      requireAuthToken: true, // ✅
    );
  }

  Future<Response> postCompleteWash(Map<String, dynamic> body) async {
    return await ApiService.post(
      EndPoints.apiPostCompleteWash,
      body,
      requireAuthToken: true, // ✅
    );
  }

  Future<Response> getApiPendingBokkings() async {
    return await ApiService.get(
      EndPoints.apigetpendingbookings,
      requireAuthToken: true, // ✅
    );
  }

  Future<Response> getApiBookingHistory({
    Map<String, dynamic>? query,
  }) async {
    return await ApiService.get(
      EndPoints.apigetbookinghistory,
      queryParameters: query,
      requireAuthToken: true, // ✅
    );
  }
}

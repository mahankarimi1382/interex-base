// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

import '../services/api_services.dart';

class RequestProcess extends GetxController {
  Future<T?> request<T>({
    required T Function(Map<String, dynamic>) fromJson,
    required String apiEndpoint,
    required RxBool isLoading,
    bool showResult = false,
    bool isBasic = false,
    required Function(T?) onSuccess,
    HttpMethod method = HttpMethod.GET,
    Map<String, dynamic>? body,
    Function(Object)? onError,
  }) async {
    try {
      isLoading.value = true;
      update();
      final value = await ApiServices.apiService<T>(
        fromJson,
        apiEndpoint,
        method: method == HttpMethod.POST ? 'POST' : 'GET',
        body: body,
        showResult: showResult,
        isBasic: isBasic,
      );
      onSuccess(value);
      return value;
    } catch (e) {
      log.e('🐞🐞🐞 Error from API service: $e 🐞🐞🐞');
      if (onError != null) onError(e);
    } finally {
      isLoading.value = false;
      update();
    }
    return null;
  }
}

enum HttpMethod { GET, POST }

import 'package:dio/dio.dart';

class MyDio {
  late Dio _dio;

  MyDio({
    BaseOptions? options,
  }) {
    _dio = Dio(options ?? BaseOptions());
  }

  Future<Response> get(String url, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: params,
      );
      // print('res:$response');

      return response;
    } on DioException catch (e) {
      throw Exception('Failed to GET: ${e.message}');
    }
  }

  Future<Response?> post(String url, {dynamic data}) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
      );
      return response;
    } on DioException catch (e) {
      print('Error in POST request: ${e.response}');
      return e.response;
    }
  }

  Future<Response> put(String url, {dynamic data}) async {
    try {
      final response = await _dio.put(
        url,
        data: data,
      );
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to PUT: ${e.message}');
    }
  }

  Future<Response> delete(String url,
      {Map<String, dynamic>? params, dynamic data, String? token}) async {
    try {
      final response = await _dio.delete(
        url,
        queryParameters: params,
        data: data,
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to DELETE: ${e.message}');
    }
  }
}

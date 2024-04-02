import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../exceptions/not_found_exception.dart';

import '../extensions/maps_extensions/map_extensions.dart';
import 'package:dio/dio.dart';

class HttpService {
  // static const String baseUrl = 'http://192.168.43.224:8000';
  // static const String baseUrl = 'http://192.168.1.7:8000';
  static const String baseUrl = 'https://medicalcenter24.eu.pythonanywhere.com';

  static bool requestJsonFormattingByDefault = true;

  static Future<T> parsedPost<T>({
    required String endPoint,
    Map<String, dynamic>? body,
    required T Function(String response) mapper,
  }) async {
    return mapper(
      await rawPost(
        endPoint: endPoint,
        body: body,
      ),
    );
  }

  static Future<http.Response> rawFullResponsePost({
    required String endPoint,
    Map<String, dynamic>? body,
  }) async {
    body = body?.toStringStringMap();
    http.Response response = await http.post(
      Uri.parse(
        _getCombinedUrl(baseUrl, endPoint),
      ),
      body: body,
    );
    return response;
  }

  static Future<String> rawPost({
    required String endPoint,
    Map<String, dynamic>? body,
  }) async {
    // body = body?.toStringStringMap();
    http.Response response = await http.post(
      Uri.parse(
        _getCombinedUrl(baseUrl, endPoint),
      ),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    String rawResponse = response.body;
    return rawResponse;
  }

  static Future<String> rawGet({
    required String endPoint,
    Map<String, String>? queryParams,
  }) async {
    http.Response response = await http.get(
      Uri.parse(
        _getCombinedUrl(
          baseUrl,
          endPoint,
          query: queryParams,
        ),
      ),
    );
    if (response.statusCode == 404) {
      throw NotFoundException();
    }
    String rawResponse = response.body;
    return rawResponse;
  }

  static Future<T> parsedGet<T>({
    required String endPoint,
    Map<String, String>? queryParams,
    required T Function(String response) mapper,
  }) async {
    String rawResponse = await rawGet(
      endPoint: endPoint,
      queryParams: queryParams,
    );
    return mapper(rawResponse);
  }

  //
  static Future<List<T>> parsedMultiGet<T>({
    required String endPoint,
    Map<String, String>? queryParams,
    required T Function(Map<String, dynamic> response) mapper,
  }) async {
    return await parsedGet(
      endPoint: endPoint,
      queryParams: queryParams,
      mapper: (response) {
        return (jsonDecode(response) as List).map((e) => mapper(e)).toList();
      },
    );
  }

  static String _getCombinedUrl(
    String baseUrl,
    String endPoint, {
    Map<String, String>? query,
    bool? requestJsonFormatting,
  }) {
    requestJsonFormatting ??= requestJsonFormattingByDefault;
    String combinedUrl = '$baseUrl/$endPoint';
    if (query != null) {
      if (requestJsonFormatting) {
        query['format'] = 'json';
      }
      return '$combinedUrl?${query.getEntriesAsUrlQuery()}';
    }
    if (requestJsonFormatting) {
      return '$combinedUrl?format=json';
    }
    return combinedUrl;
  }

  static Future<Response> dioMultiPartPost({
    required String endPoint,
    Map<String, dynamic>? body,
    List<MultipartFile> files = const [],
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    Dio dio = Dio(
      BaseOptions(
        method: 'POST',
        baseUrl: baseUrl,
        headers: {
          'Content-Type': 'multipart/form-data',
          'Cache-Control': 'max-age=0',
          'Connection': 'keep-alive',
        },
      ),
    );
    FormData formData = FormData.fromMap(body?.toStringStringMap() ?? {});
    formData.files.addAll(
      files.map(
        (e) {
          return MapEntry(
            e.filename ?? '${RandomUuidGen.getRandomUuid()}.jpg',
            e,
          );
        },
      ).toList(),
    );
    Response response = await dio.post(
      '/$endPoint',
      data: formData,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }
}

class RandomUuidGen {
  static String getRandomUuid() {
    return Random().nextInt(9999).toString();
  }
}

import 'dart:convert';

import 'package:buck/basic_app.dart';
import 'package:buck/utils/aes_helper.dart';
import 'package:buck/utils/login_client.dart';
import 'package:buck/utils/rsa_helper.dart';
import 'package:buck/widgets/tips/tips_tool.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

class DioClient<T> {
  final Dio _dio = new Dio(BaseOptions(
    connectTimeout: buck.cacheControl.connectTimeout ?? 10000,
    receiveTimeout: buck.cacheControl.receiveTimeout ?? 40000,
    responseType: ResponseType.json,
  ));

  Future<ResponseBody<T>> post(url,
      {Map data = const {},
      Map queryParameters,
      UploadFile uploadFile,
      List<UploadFile> uploadFiles,
      customBaseUrl,
      bool encrypt = false}) async {
    _dio.options.headers = {
      'clientName': buck.packageInfo.appName,
      'encrypt': encrypt
    };
    if (buck.cacheControl.token.length > 0)
      _dio.options.headers['Authorization'] =
          'Bearer ' + buck.cacheControl.token;
    _dio.options.baseUrl =
        customBaseUrl == null ? buck.cacheControl.activeBaseUrl : customBaseUrl;

    Response response;
    if (uploadFile != null)
      data.putIfAbsent(
          'file',
          () async => await MultipartFile.fromFile(uploadFile.filePath,
              filename: uploadFile.fileName,
              contentType: uploadFile.contentType));
    if (uploadFiles != null)
      data.putIfAbsent(
          'files',
          () => uploadFiles.map((e) async => await MultipartFile.fromFile(
              uploadFile.filePath,
              filename: uploadFile.fileName,
              contentType: uploadFile.contentType)));
    try {
      response = await _dio.post(url,
          data: encrypt
              ? RsaHelper.getInstance().encodeBackendData(jsonEncode(data))
              : data,
          queryParameters: queryParameters);
    } on DioError catch (e) {
      print(e);
      TipsTool.error('网络异常').show();
    }
    if (response != null) {
      ResponseBody<T> responseBody = _buildResponseBody(response);
      if (responseBody.token != null) {
        buck.cacheControl.setToken(responseBody.token);
      }
      if (responseBody.resend ?? false) {
        return post(url, data: data);
      }
      if (responseBody.reLogin ?? false) {
        LoginClient.getInstance().logOut();
      }
      return responseBody;
    } else {
      return null;
    }
  }

  Future<ResponseBody<T>> get(url, {queryParameters, customBaseUrl}) async {
    _dio.options.headers = {'clientName': buck.packageInfo.appName};
    if (buck.cacheControl.token.length > 0)
      _dio.options.headers['Authorization'] =
          'Bearer ' + buck.cacheControl.token;
    _dio.options.baseUrl =
        customBaseUrl == null ? buck.cacheControl.activeBaseUrl : customBaseUrl;

    Response response;
    try {
      response = await _dio.get(url, queryParameters: queryParameters);
    } on DioError catch (e) {
      print(e);
      TipsTool.error('网络异常').show();
    }
    if (response != null) {
      ResponseBody<T> responseBody = _buildResponseBody(response);
      if (responseBody.token != null) {
        buck.cacheControl.setToken(responseBody.token);
      }
      if (responseBody.resend ?? false) {
        return get(url, queryParameters: queryParameters);
      }
      if (responseBody.reLogin ?? false) {
        LoginClient.getInstance().logOut();
      }
      return responseBody;
    } else {
      return null;
    }
  }

  Future download(BuildContext context, url,
      {Map<String, dynamic> queryParameters,
      @required path,
      ProgressCallback onReceiveProgress}) async {
    if (buck.cacheControl.token.length > 0)
      _dio.options.headers = {
        'Authorization': 'Bearer ' + buck.cacheControl.token
      };
    _dio.options.baseUrl = buck.cacheControl.activeBaseUrl;
    _dio.options.responseType = ResponseType.stream;

    try {
      await _dio.download(url, path,
          queryParameters: queryParameters,
          onReceiveProgress: onReceiveProgress);
    } on DioError catch (e) {
      print(e);
      TipsTool.error('网络异常').show();
    }
  }

  ResponseBody<T> _buildResponseBody(response) {
    var responseData;
    List<String> encrypt = response.headers['encrypt'];
    if (encrypt != null && encrypt[0] == 'true') {
      String aesKey =
          RsaHelper.getInstance().decodeClientData(response.data["aesKey"]);
      responseData = jsonDecode(
          AesHelper.decrypt(aesKey, response.data["encryptContent"]));
    } else {
      responseData = response.data;
    }
    if (responseData == null || responseData == '') responseData = {};
    return ResponseBody<T>.fromMap(responseData);
  }
}

class ResponseBody<T> {
  final bool _success;
  final String _category;
  final T _data;
  final String _title;
  final String _message;
  final bool _resend;
  final String _token;
  final bool _reLogin;

  ResponseBody.fromMap(Map<String, dynamic> map)
      : _success = map['success'],
        _category = map['category'],
        _data = map['data'],
        _title = map['title'],
        _message = map['message'],
        _resend = map['resend'],
        _token = map['token'],
        _reLogin = map['reLogin'];

  Map<String, dynamic> toMap() => <String, dynamic>{
        'success': this._success,
        'category': this._category,
        'data': this._data,
        'title': this._title,
        'message': this._message,
        'resend': this._resend,
        'token': this._token,
        'reLogin': this._reLogin,
      };

  bool get success => _success;

  String get token => _token;

  String get message => _message;

  String get title => _title;

  String get category => _category;

  T get data => _data;

  bool get resend => _resend;

  bool get reLogin => _reLogin;
}

class UploadFile {
  final String filePath;
  final String fileName;
  final MediaType contentType;

  static UploadFile build({
    @required String filePath,
    @required String filename,
    MediaType contentType,
  }) =>
      UploadFile._(filePath, filename, contentType);

  UploadFile._(this.filePath, this.fileName, this.contentType);
}

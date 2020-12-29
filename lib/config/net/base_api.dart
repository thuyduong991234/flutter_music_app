import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';

final Http http = Http();

class Http extends BaseHttp {
  @override
  void init() {
    options.baseUrl = 'https://zingmp3.vn/api';
    interceptors..add(ApiInterceptor())
        /*// cookie持久化 异步
      ..add(CookieManager(
          PersistCookieJar(dir: StorageManager.temporaryDirectory.path)))*/
        ;
  }
}

class ApiInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    var storage = await SharedPreferences.getInstance();
    Map<String, String> header = {'Cookie': storage.getString("headerCookie")};
    options.headers = header;
    //debugPrint("co header");
    /*debugPrint('---api-request--->url--> ${options.baseUrl}${options.path}' +
        ' queryParameters: ${options.queryParameters}' +
        ' data: ${options.data}' +
        ' headers');*/
    return options;
  }

  @override
  onResponse(Response response) async {
    //debugPrint("header: " + response.headers["set-cookie"].toString());
    if (response.headers["set-cookie"] != null) {
      var codeCookie =
          (response.headers["set-cookie"].toString().split(";"))[0];
      //debugPrint((codeCookie.replaceAll("[", "")).replaceAll("]", ""));
      Cookie a = Cookie.fromSetCookieValue(
          (codeCookie.replaceAll("[", "")).replaceAll("]", ""));
      var storage = await SharedPreferences.getInstance();
      await storage.setString("headerCookie", a.toString());
      //debugPrint(a.toString());
    }

    try {
      response.data = json.decode(response.data);
    } catch (e) {
      response.data = json.encode(response.data);
      response.data = json.decode(response.data);
    }

    debugPrint('---api-response--->resp----->${response.data}');
    ResponseData respData = ResponseData.fromJson(response.data);
    if (respData.success) {
      response.data = respData.data;
      //debugPrint("If successs ------" + response.toString());
      return http.resolve(response);
    } else {
      if (respData.msg != 'Success') {
        //debugPrint('vo roi ne');
        return http.resolve({"err": -204});
      } else {
        //debugPrint('vo roi ne');
        throw NotSuccessException.fromRespData(respData);
      }
    }
  }
}

class ResponseData extends BaseResponseData {
  bool get success => "Success" == msg;

  ResponseData.fromJson(Map<String, dynamic> json) {
    //code = json['err'];
    error = json['err'].toString();
    msg = json['msg'];
    data = json['data'];
    //debugPrint('err + ' + json['err'].toString());
    debugPrint('vo roi ne');
  }
}

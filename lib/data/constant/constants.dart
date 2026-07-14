import 'package:flutter/services.dart';

enum Environment { DEV, PROD }

class AppConstants {
  static late Map<String, dynamic> _config;

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.DEV:
        _config = _Config.devConstants;
        break;
      case Environment.PROD:
        _config = _Config.prodConstants;
        break;
    }
  }

  static get isDev => _config[_Config.environment] == Environment.DEV;

  static get API => _config[_Config.API];

  static get AUTH_API => _config[_Config.AUTH_API];

  static get IMAGE_URL => _config[_Config.IMAGE_URL];

  static get NAVER_API => _config[_Config.NAVER_API];

  static get JUSO_API => _config[_Config.JUSO_API];

  static get JUSO_API_KEY => _config[_Config.JUSO_API_KEY];

  static get NAVER_CLIENT_ID => _config[_Config.NAVER_CLIENT_ID];

  static get NAVER_CLIENT_SECRET => _config[_Config.NAVER_CLIENT_SECRET];

  static get PHONE_VERIFY_URL => _config[_Config.PHONE_VERIFY_URL];

  static const methodChannel = MethodChannel('kdmp_cm');
}

class _Config {
  static const environment = "Environment";

  static const API = "API";
  static const AUTH_API = "AUTH_API";
  static const IMAGE_URL = "IMAGE_URL";
  static const NAVER_API = "NAVER_API";
  static const JUSO_API = "JUSO_API";

  static const JUSO_API_KEY = "JUSO_API_KEY";
  static const NAVER_CLIENT_ID = "NAVER_CLIENT_ID";
  static const NAVER_CLIENT_SECRET = "NAVER_CLIENT_SECRET";

  static const PHONE_VERIFY_URL = "PHONE_VERIFY_URL";

  /// 개발
  static Map<String, dynamic> devConstants = {
    environment: Environment.DEV,
    API: "http://210.223.56.94:8088",
    AUTH_API: "http://210.223.56.94:8085",
    IMAGE_URL: "http://210.223.56.94:8088/v1/biztotal",
    NAVER_API: "https://naveropenapi.apigw.ntruss.com",
    JUSO_API: "https://business.juso.go.kr/addrlink/addrLinkApi.do",
    JUSO_API_KEY: "JUSO_API_KEY_DEV",
    NAVER_CLIENT_ID: "NAVER_CLIENT_ID",
    NAVER_CLIENT_SECRET: "NAVER_CLIENT_SECRET",
    PHONE_VERIFY_URL: "http://210.223.56.94:8088/mobiliansTest",
  };

  /// 운영
  static Map<String, dynamic> prodConstants = {
    environment: Environment.PROD,
    API: "https://appkddsa.or.kr",
    AUTH_API: "https://appkddsa.or.kr",
    IMAGE_URL: "https://appkddsa.or.kr/v1/biztotal",
    NAVER_API: "https://naveropenapi.apigw.ntruss.com",
    JUSO_API: "https://business.juso.go.kr/addrlink/addrLinkApi.do",
    JUSO_API_KEY: "JUSO_API_KEY_PROD",
    NAVER_CLIENT_ID: "NAVER_CLIENT_ID",
    NAVER_CLIENT_SECRET: "NAVER_CLIENT_SECRET",
    PHONE_VERIFY_URL: "https://appkddsa.or.kr/mobilians",
  };
}

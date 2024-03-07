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

  static get KAKAO_JUSO_API => _config[_Config.KAKAO_JUSO_API];

  static get KAKAO_REST_API_KEY => _config[_Config.KAKAO_REST_API_KEY];

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
  static const KAKAO_JUSO_API = "KAKAO_JUSO_API";

  static const KAKAO_REST_API_KEY = "KAKAO_REST_API_KEY";
  static const NAVER_CLIENT_ID = "NAVER_CLIENT_ID";
  static const NAVER_CLIENT_SECRET = "NAVER_CLIENT_SECRET";

  static const PHONE_VERIFY_URL = "PHONE_VERIFY_URL";

  /// 개발
  static Map<String, dynamic> devConstants = {
    environment: Environment.DEV,
    API: "http://ec2-13-209-109-214.ap-northeast-2.compute.amazonaws.com:8080/kdmp",
    AUTH_API: "http://ec2-13-209-109-214.ap-northeast-2.compute.amazonaws.com:8080/kdmp",
    IMAGE_URL: "http://ec2-13-209-109-214.ap-northeast-2.compute.amazonaws.com:8080/kdmp/v1/biztotal",
    NAVER_API: "https://naveropenapi.apigw.ntruss.com",
    KAKAO_JUSO_API: "https://dapi.kakao.com/v2/local/search/keyword.JSON",
    KAKAO_REST_API_KEY: "KAKAO_REST_API_KEY",
    NAVER_CLIENT_ID: "NAVER_CLIENT_ID",
    NAVER_CLIENT_SECRET: "NAVER_CLIENT_SECRET",
    PHONE_VERIFY_URL: "http://ec2-13-209-109-214.ap-northeast-2.compute.amazonaws.com:8080/mobiliansTest",
  };

  /// 운영
  static Map<String, dynamic> prodConstants = {
    environment: Environment.PROD,
    API: "https://appkddsa.or.kr",
    AUTH_API: "https://appkddsa.or.kr",
    IMAGE_URL: "https://appkddsa.or.kr/v1/biztotal",
    NAVER_API: "https://naveropenapi.apigw.ntruss.com",
    KAKAO_JUSO_API: "https://dapi.kakao.com/v2/local/search/keyword.JSON",
    KAKAO_REST_API_KEY: "KAKAO_REST_API_KEY",
    NAVER_CLIENT_ID: "NAVER_CLIENT_ID",
    NAVER_CLIENT_SECRET: "NAVER_CLIENT_SECRET",
    PHONE_VERIFY_URL: "https://appkddsa.or.kr/mobilians",
  };
}

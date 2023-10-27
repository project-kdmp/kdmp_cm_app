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

  static get API => _config[_Config.API];

  static get AUTH_API => _config[_Config.AUTH_API];

  static get IMAGE_URL => _config[_Config.IMAGE_URL];

  static get NAVER_API => _config[_Config.NAVER_API];

  static get JUSO_API => _config[_Config.JUSO_API];

  static get JUSO_API_KEY => _config[_Config.JUSO_API_KEY];

  static get NAVER_CLIENT_ID => _config[_Config.NAVER_CLIENT_ID];

  static get NAVER_CLIENT_SECRET => _config[_Config.NAVER_CLIENT_SECRET];
}

class _Config {
  static const API = "API";
  static const AUTH_API = "AUTH_API";
  static const IMAGE_URL = "IMAGE_URL";
  static const NAVER_API = "NAVER_API";
  static const JUSO_API = "JUSO_API";

  static const JUSO_API_KEY = "JUSO_API_KEY";
  static const NAVER_CLIENT_ID = "NAVER_CLIENT_ID";
  static const NAVER_CLIENT_SECRET = "NAVER_CLIENT_SECRET";

  /// 개발
  static Map<String, dynamic> devConstants = {
    API: "http://ec2-13-209-109-214.ap-northeast-2.compute.amazonaws.com:8080/kdmp",
    AUTH_API: "http://ec2-13-209-109-214.ap-northeast-2.compute.amazonaws.com:8080/kdmp",
    IMAGE_URL: "http://ec2-13-209-109-214.ap-northeast-2.compute.amazonaws.com:8080/kdmp/v1/biztotal",
    NAVER_API: "https://naveropenapi.apigw.ntruss.com",
    JUSO_API: "https://business.juso.go.kr/addrlink/addrLinkApi.do",
    JUSO_API_KEY: "JUSO_API_KEY_DEV",
    NAVER_CLIENT_ID: "NAVER_CLIENT_ID",
    NAVER_CLIENT_SECRET: "NAVER_CLIENT_SECRET",
  };

  /// 운영
  static Map<String, dynamic> prodConstants = {
    API: "http://ec2-13-209-109-214.ap-northeast-2.compute.amazonaws.com:8080/kdmp",
    AUTH_API: "http://ec2-13-209-109-214.ap-northeast-2.compute.amazonaws.com:8080/kdmp",
    IMAGE_URL: "http://ec2-13-209-109-214.ap-northeast-2.compute.amazonaws.com:8080/kdmp/v1/biztotal",
    NAVER_API: "https://naveropenapi.apigw.ntruss.com",
    JUSO_API: "https://business.juso.go.kr/addrlink/addrLinkApi.do",
    JUSO_API_KEY: "JUSO_API_KEY_PROD",
    NAVER_CLIENT_ID: "NAVER_CLIENT_ID",
    NAVER_CLIENT_SECRET: "NAVER_CLIENT_SECRET",
  };
}

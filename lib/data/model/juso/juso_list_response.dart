class JusoListResponse {
  Results results;

  JusoListResponse({
    required this.results,
  });

  factory JusoListResponse.fromJson(Map<String, dynamic> json) => JusoListResponse(
        results: Results.fromJson(json["results"]),
      );

  Map<String, dynamic> toJson() => {
        "results": results.toJson(),
      };
}

class Results {
  Common common;
  List<Juso> juso;

  Results({
    required this.common,
    required this.juso,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        common: Common.fromJson(json["common"]),
        juso: json["juso"] != null ? List<Juso>.from(json["juso"].map((x) => Juso.fromJson(x))) : List.empty(),
      );

  Map<String, dynamic> toJson() => {
        "common": common.toJson(),
        "juso": List<dynamic>.from(juso.map((x) => x.toJson())),
      };
}

class Common {
  String errorMessage;
  String countPerPage;
  String totalCount;
  String errorCode;
  String currentPage;

  Common({
    required this.errorMessage,
    required this.countPerPage,
    required this.totalCount,
    required this.errorCode,
    required this.currentPage,
  });

  factory Common.fromJson(Map<String, dynamic> json) => Common(
        errorMessage: json["errorMessage"],
        countPerPage: json["countPerPage"],
        totalCount: json["totalCount"],
        errorCode: json["errorCode"],
        currentPage: json["currentPage"],
      );

  Map<String, dynamic> toJson() => {
        "errorMessage": errorMessage,
        "countPerPage": countPerPage,
        "totalCount": totalCount,
        "errorCode": errorCode,
        "currentPage": currentPage,
      };
}

class Juso {
  String detBdNmList;
  String engAddr;
  String rn;
  String emdNm;
  String zipNo;
  String roadAddrPart2;
  String emdNo;
  String sggNm;
  String jibunAddr;
  String siNm;
  String roadAddrPart1;
  String bdNm;
  String admCd;
  String udrtYn;
  String lnbrMnnm;
  String roadAddr;
  String lnbrSlno;
  String buldMnnm;
  String bdKdcd;
  String liNm;
  String rnMgtSn;
  String mtYn;
  String bdMgtSn;
  String buldSlno;

  Juso({
    required this.detBdNmList,
    required this.engAddr,
    required this.rn,
    required this.emdNm,
    required this.zipNo,
    required this.roadAddrPart2,
    required this.emdNo,
    required this.sggNm,
    required this.jibunAddr,
    required this.siNm,
    required this.roadAddrPart1,
    required this.bdNm,
    required this.admCd,
    required this.udrtYn,
    required this.lnbrMnnm,
    required this.roadAddr,
    required this.lnbrSlno,
    required this.buldMnnm,
    required this.bdKdcd,
    required this.liNm,
    required this.rnMgtSn,
    required this.mtYn,
    required this.bdMgtSn,
    required this.buldSlno,
  });

  /// 네이버 지역(장소) 검색 결과를 도로명주소 목록에 함께 보여주기 위한 변환.
  /// 선택 시 roadAddr(없으면 jibunAddr)를 지오코딩해 좌표·행정동을 얻으므로,
  /// 표시·선택에 쓰는 bdNm·roadAddr·jibunAddr 만 채우고 나머지는 비운다.
  factory Juso.place({required String bdNm, required String roadAddr, required String jibunAddr}) => Juso(
        detBdNmList: "",
        engAddr: "",
        rn: "",
        emdNm: "",
        zipNo: "",
        roadAddrPart2: "",
        emdNo: "",
        sggNm: "",
        jibunAddr: jibunAddr,
        siNm: "",
        roadAddrPart1: "",
        bdNm: bdNm,
        admCd: "",
        udrtYn: "",
        lnbrMnnm: "",
        roadAddr: roadAddr,
        lnbrSlno: "",
        buldMnnm: "",
        bdKdcd: "",
        liNm: "",
        rnMgtSn: "",
        mtYn: "",
        bdMgtSn: "",
        buldSlno: "",
      );

  factory Juso.fromJson(Map<String, dynamic> json) => Juso(
        detBdNmList: json["detBdNmList"],
        engAddr: json["engAddr"],
        rn: json["rn"],
        emdNm: json["emdNm"],
        zipNo: json["zipNo"],
        roadAddrPart2: json["roadAddrPart2"],
        emdNo: json["emdNo"],
        sggNm: json["sggNm"],
        jibunAddr: json["jibunAddr"],
        siNm: json["siNm"],
        roadAddrPart1: json["roadAddrPart1"],
        bdNm: json["bdNm"],
        admCd: json["admCd"],
        udrtYn: json["udrtYn"],
        lnbrMnnm: json["lnbrMnnm"],
        roadAddr: json["roadAddr"],
        lnbrSlno: json["lnbrSlno"],
        buldMnnm: json["buldMnnm"],
        bdKdcd: json["bdKdcd"],
        liNm: json["liNm"],
        rnMgtSn: json["rnMgtSn"],
        mtYn: json["mtYn"],
        bdMgtSn: json["bdMgtSn"],
        buldSlno: json["buldSlno"],
      );

  Map<String, dynamic> toJson() => {
        "detBdNmList": detBdNmList,
        "engAddr": engAddr,
        "rn": rn,
        "emdNm": emdNm,
        "zipNo": zipNo,
        "roadAddrPart2": roadAddrPart2,
        "emdNo": emdNo,
        "sggNm": sggNm,
        "jibunAddr": jibunAddr,
        "siNm": siNm,
        "roadAddrPart1": roadAddrPart1,
        "bdNm": bdNm,
        "admCd": admCd,
        "udrtYn": udrtYn,
        "lnbrMnnm": lnbrMnnm,
        "roadAddr": roadAddr,
        "lnbrSlno": lnbrSlno,
        "buldMnnm": buldMnnm,
        "bdKdcd": bdKdcd,
        "liNm": liNm,
        "rnMgtSn": rnMgtSn,
        "mtYn": mtYn,
        "bdMgtSn": bdMgtSn,
        "buldSlno": buldSlno,
      };
}

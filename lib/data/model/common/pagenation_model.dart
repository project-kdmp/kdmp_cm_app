class Pagination {
  int totalRecordCount;
  int totalPageCount;
  int page;
  int pageSize;
  bool existPrevPage;
  bool existNextPage;

  Pagination({
    required this.totalRecordCount,
    required this.totalPageCount,
    required this.page,
    required this.pageSize,
    required this.existPrevPage,
    required this.existNextPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    totalRecordCount: json["totalRecordCount"],
    totalPageCount: json["totalPageCount"],
    page: json["page"],
    pageSize: json["pageSize"],
    existPrevPage: json["existPrevPage"],
    existNextPage: json["existNextPage"],
  );

  Map<String, dynamic> toJson() => {
    "totalRecordCount": totalRecordCount,
    "totalPageCount": totalPageCount,
    "page": page,
    "pageSize": pageSize,
    "existPrevPage": existPrevPage,
    "existNextPage": existNextPage,
  };
}
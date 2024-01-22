import 'dart:convert';
import 'package:http/http.dart';
import 'package:mp_team_project/models/pinterest_model.dart';
import 'log_service.dart';

class HttpService {
  static String baseUrl = "api.unsplash.com";
  static bool isTester = true;

  // Header Padkq3KNPMI1zbdWRUvMHcot3YE4jNjLwg-hpOq1zIk
  static Map<String, String> headers = {
    "Accept-Version": "v1",
    "Authorization": "Client-ID BtIXwd8R7zJF7H3G0B5vxiJGsWDiKfcj7FlWNMcwB58"
  };

  // Apis
  static String apiTodoListRandom = "/photos/random/";
  static String apiTodoList = "/photos";
  static String apiDownload = "/photos/:id/download";
  static String apiTodoOne = "/photos"; // {ID}
  static String apiTodoSearch = "/search/photos";

  // Methods
  static Future<String?> getMethod(String api, Map<String, String> params) async {
    var uri = Uri.https(baseUrl, api, params);
    Log.d("URL => $uri");
    Response response = await get(uri, headers: headers);
      Log.i("Hello http $params => ${response.body}");
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  static Map<String, String> paramsPage(int pageNumber, int number) {
    Map<String, String> params = {};
    params.addAll({
      "page":pageNumber.toString(),
      "per_page":number.toString(),
    });
    return params;
  }

  static Map<String, String> paramsSearch(int pageNumber,String query) {
    Map<String, String> params = {};
    params.addAll({
      "page":pageNumber.toString(),
      "query":query.toString()
    });
    return params;
  }

  static Map<String, String> randomPage(int pageNumber) {
    Map<String, String> params = {};
    params.addAll({
      "count":pageNumber.toString(),
    });
    return params;
  }

  // Params
  static Map<String, String> paramEmpty() {
    Map<String, String> map = {};
    return map;
  }

  static List<Post> parseResponse(String response) {
    List json = jsonDecode(response);
    Log.i("Json => $json");
    List<Post> photos = List<Post>.from(json.map((x) => Post.fromJson(x)));
    return photos;
  }

  static Map<String, String> downloadUrl(String id){
    Map<String, String> params = {};
    params.addAll({"id": id});
    return params;
  }

  static List<Post> parseSearchParse(String response) {
    Map<String, dynamic> json = jsonDecode(response);
    List<Post> photos = List<Post>.from(json["results"].map((x) => Post.fromJson(x)));
    return photos;
  }
}
import 'package:dio/dio.dart';
import 'package:ebookapp/controller/api.dart';
import 'package:ebookapp/model/category/model_category.dart';

Future<List<ModelCategory>> fetchCategory(
    List<ModelCategory> fetchCategory) async {
  var request = await Dio().get(
      ApiConstant().baseUrl() + ApiConstant().api + ApiConstant().category);

  for (Map<String, dynamic> category in request.data) {
    fetchCategory.add(ModelCategory(
      catId: category['cat_id'],
      photoCat: category['photo_cat'],
      name: category['name'],
      status: category['status'],
    ));
  }
  return fetchCategory;
}

import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/ulits/urls.dart';
import 'package:yo_bray/widgets/toast.dart';

class WithFileUpload {
  Dio https = Dio();

  final header = {
    'Authorization': 'Bearer $kToken',
    'Content-Type': 'application/json'
  };

  Future<bool> createProduct(Map<String, dynamic> body, File? image) async {
    MultipartFile? multipartFile;

    FormData formData = FormData.fromMap(body);

    if (image != null) {
      final filename = image.path.split('/').last;
      final type = filename.split('.').last;
      List<int> img = image.readAsBytesSync();
      multipartFile = MultipartFile.fromBytes(
        img,
        filename: image.path.split('/').last,
        contentType: MediaType('image', type),
      );

      formData = FormData.fromMap(
        {
          ...body,
          ...{"feature_image": multipartFile},
        },
      );
    }

    print(formData.fields);
    print(formData.files);

    try {
      var response = await https.post(
        Urls.product,
        data: formData,
        options: Options(
          headers: header,
          method: 'post',
          contentType: 'multipart/form-data;charset=UTF-8',
          responseType: ResponseType.json,
        ),
      );
      print(response.data);
      print(response.statusCode);
      final String data = response.data ?? '';

      if (data.contains('Successful')) {
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    errorToast('Some error');
    return false;
  }

  Future updateProduct(Map<String, dynamic> body, File? image, int id) async {
    FormData formData = FormData.fromMap(body);
    MultipartFile? multipartFile;
    if (image != null) {
      final filename = image.path.split('/').last;
      final type = filename.split('.').last;
      List<int> img = image.readAsBytesSync();
      multipartFile = MultipartFile.fromBytes(
        img,
        filename: image.path.split('/').last,
        contentType: MediaType('image', type),
      );

      formData = FormData.fromMap(
        {
          ...body,
          ...{"feature_image": multipartFile}
        },
      );
    }

    try {
      print(formData.fields);
      var response = await https.post(
        Urls.baseUrl + '/product' + '/$id/update',
        data: formData,
        options: Options(
          headers: header,
          method: 'post',
          contentType: 'multipart/form-data;charset=UTF-8',
          responseType: ResponseType.json,
        ),
      );
      print(response.data);
      print(response.statusCode);
      final String data = response.data ?? '';

      if (data.contains('Successful')) {
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> feedBack(Map<String, Object> body, List<File> images,
      List<File> videos, bool isEdit, String feedbackId) async {
    log(Urls.jobFeedback + "/$feedbackId");
    log(isEdit.toString());
    FormData formData = FormData.fromMap(body);

    for (int i = 0; i < videos.length; i++) {
      final _file = videos[i];
      formData.files.addAll([
        MapEntry(
          "video_file[]",
          await MultipartFile.fromFile(
            _file.path,
            filename: _file.path.split('/').last,
            contentType: new MediaType("video", _file.path.split('.').last),
          ),
        ),
      ]);
    }
    for (int i = 0; i < images.length; i++) {
      final _file = images[i];
      formData.files.addAll([
        MapEntry(
          "feedback_file[]",
          await MultipartFile.fromFile(
            _file.path,
            filename: _file.path.split('/').last,
            contentType: new MediaType("image", _file.path.split('.').last),
          ),
        ),
      ]);
    }

    try {
      print(formData.files);
      print(formData.fields);
      print(Urls.jobFeedback + "/$feedbackId");
      print(isEdit);
      var response = await https.post(
        isEdit ? Urls.jobFeedback + "/$feedbackId" : Urls.jobFeedback,
        data: formData,
        options: Options(
          headers: header,
          method: 'post',
          contentType: 'multipart/form-data;charset=UTF-8',
          responseType: ResponseType.json,
        ),
      );

      final data = response.data ?? '';
      print(data);
      if (data.contains('Successful')) {
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }
}

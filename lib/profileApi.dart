import 'package:bottlebucks/login.dart';
import 'package:bottlebucks/register.dart';
import 'package:dio/dio.dart';

Future<List<dynamic>> fetchProfile() async {
  try {
    Dio dio = Dio();
    final response = await dio.get('$base_url/ProfileViewAPI/$LID');
    print(response.data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      return response.data;
    }
    return [];
  } catch (e) {
    print(e);
  }
  throw {};
}

Future<void> editProfileApi(FormData formData) async {
  try {
    final response = await dio.put(
      '$base_url/ProfileViewAPI/$LID',
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );

    if (response.statusCode == 200) {
      print('Profile updated successfully');
    } else {
      print('Failed to update profile: ${response.statusCode}');
      throw Exception('Failed to update profile');
    }
  } catch (e) {
    print('Dio error: $e');
  }
}

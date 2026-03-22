import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String?> uploadToImgur(File imageFile) async {
  const clientId = '78fd2d89468e38b'; // Replace with your Imgur client ID

  final base64Image = base64Encode(await imageFile.readAsBytes());

  final response = await http.post(
    Uri.parse('https://api.imgur.com/3/image'),
    headers: {'Authorization': 'Client-ID $clientId'},
    body: {'image': base64Image, 'type': 'base64'},
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json['data']['link'];
  } else {
    print('❌ Imgur upload failed: ${response.body}');
    return null;
  }
}

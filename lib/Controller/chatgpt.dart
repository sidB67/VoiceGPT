import 'dart:convert';

import 'package:flutter_chatgpt_api/flutter_chatgpt_api.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:voiceai/tokens.dart';
import 'package:text_to_speech/text_to_speech.dart';
import '../Model/chatmessage.dart';
import 'package:http/http.dart' as http;

class ChatGPTController extends GetxController {
  final tts = TextToSpeech();

  var messages = [].obs;
  var isLoading = false.obs;
  Future<void> sendMessage(String prompt) async {
    isLoading.value = true;
    try {
      final url = Uri.parse("https://api.openai.com/v1/completions");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'Application/json',
          'Authorization': 'Bearer $apiKey2'
        },
        body: json.encode(
          {
            'model': 'text-davinci-003',
            'prompt': prompt,
            'temperature': 0,
            'max_tokens': 2000,
            'top_p': 1,
            'frequency_penalty': 0.0,
            'presence_penalty': 0.0
          },
        ),
      );
      // print(response.body);
      final responseBody = jsonDecode(response.body);
      print(jsonDecode(response.body));
      String textMsg = responseBody['choices'][0]['text'];
      String msg = textMsg.trim();
      messages.add(CustomChatMessage(chatMessage: msg, senderId: 'bot'));
      speakText(msg);
      isLoading.value = false;
    } catch (e) {
      print(e.toString());
      isLoading.value = false;
      messages.add(CustomChatMessage(
          chatMessage: 'Something went wrong, try again', senderId: 'bot'));
      speakText('Something went wrong, Please try again');
    } finally {
      isLoading.value = false;
    }
  }

  void addUserMessage(String message) {
    print(message);
    messages.add(CustomChatMessage(chatMessage: message, senderId: 'user'));
    print(messages);
  }

  void speakText(String text) async {
    print('speaking');

    tts.speak(text);
  }
}

import 'package:flutter_chatgpt_api/flutter_chatgpt_api.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:voiceai/tokens.dart';
import 'package:text_to_speech/text_to_speech.dart';
import '../Model/chatmessage.dart';

class ChatGPTController extends GetxController {
  final tts = TextToSpeech();
  final _api =
      ChatGPTApi(sessionToken: sessionToken, clearanceToken: clearanceToken);
  var messages = [].obs;
  String? _parentMessageId;
  String? _conversationId;
  Future<void> sendMessage(String message) async {
    try {
      var newMessage = await _api.sendMessage(
        message,
        conversationId: _conversationId,
        parentMessageId: _parentMessageId,
      );
      _conversationId = newMessage.conversationId;
      _parentMessageId = newMessage.messageId;
      messages.add(
          CustomChatMessage(chatMessage: newMessage.message, senderId: 'bot'));
      await speakText(newMessage.message);
    } on Exception catch (e) {
      print(e.toString());
      if (e.toString() == 'Exception: Rate limited') {
        messages.add(
            CustomChatMessage(chatMessage: 'Rate Limited', senderId: 'bot'));
        await speakText('Rate Limited');
      } else {
        messages.add(CustomChatMessage(
            chatMessage: 'Something went wrong, try again', senderId: 'bot'));
        await speakText('Something went wrong, Please try again');
      }
    }
  }

  void addUserMessage(String message) {
    print(message);
    messages.add(CustomChatMessage(chatMessage: message, senderId: 'user'));
    print(messages);
  }

  Future<void> speakText(String text) async {
    print('speaking');

    await tts.speak(text);
  }
}

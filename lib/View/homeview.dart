import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:voiceai/Controller/chatgpt.dart';
import 'package:voiceai/Model/chatmessage.dart';
import 'package:voiceai/colors.dart';

import '../customtextstyle.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final ChatGPTController _gptController = Get.put(ChatGPTController());
  String? message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.surface0,
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              return Expanded(
                child: ListView.builder(
                  itemCount: _gptController.messages.length,
                  itemBuilder: (ctx, idx) {
                    return MessageTile(
                        chatMessage: _gptController.messages[idx]);
                  },
                ),
              );
            }),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: MyColors.surface1,
                        border: Border.all(width: 1, color: MyColors.white12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        cursorColor: MyColors.purple,
                        style: CustomTextStyle.L1.copyWith(
                          color: Colors.white.withOpacity(.92),
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                          ),
                          border: InputBorder.none,
                          hintText: 'Type your message',
                          hintStyle: CustomTextStyle.L3
                              .copyWith(color: MyColors.white32),
                        ),
                        onChanged: (value) {
                          message = value;
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (message != null) {
                          _gptController.addUserMessage(message!);
                          _gptController.sendMessage(message!);
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.white.withOpacity(.92),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile({
    Key? key,
    required this.chatMessage,
  }) : super(key: key);

  final CustomChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: chatMessage.senderId == 'bot' ? MyColors.white12 : null,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.only(
        left: 16,
      ),
      child: Row(
        children: [
          chatMessage.senderId == 'bot'
              ? Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    child: Image.asset(
                      'assets/bot.jpeg',
                      scale: 1.5,
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    backgroundColor: MyColors.white4,
                    child: Icon(
                      Icons.person,
                    ),
                  ),
                ),
          Expanded(
            child: Container(
              width: double.infinity,
              child: Wrap(
                children: [
                  Text(
                    chatMessage.chatMessage,
                    style: CustomTextStyle.L2.copyWith(color: MyColors.white92),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

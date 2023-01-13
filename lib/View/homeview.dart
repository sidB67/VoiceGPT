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
  final TextEditingController _editingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent * 1.2,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

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
                  controller: _scrollController,
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
                        controller: _editingController,
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
                        // onChanged: (value) {
                        //   message = value;
                        // },
                      ),
                    ),
                  ),
                  Obx(() {
                    return _gptController.isLoading.value
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () async {
                                if (_editingController.text.isNotEmpty) {
                                  _gptController
                                      .addUserMessage(_editingController.text);

                                  await _gptController
                                      .sendMessage(_editingController.text);
                                  _editingController.clear();
                                  _scrollToBottom();
                                }
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.white.withOpacity(.92),
                                size: 18,
                              ),
                            ),
                          );
                  })
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
      width: double.infinity,
      color: chatMessage.senderId == 'bot' ? MyColors.white12 : null,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          chatMessage.senderId == 'bot'
              ? Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 16.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/bot.jpeg'))),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: MyColors.white4,
                    child: Icon(
                      Icons.person,
                    ),
                  ),
                ),
          Expanded(
            child: Container(
              // padding: EdgeInsets.only(top: 2),
              child: Text(
                chatMessage.chatMessage,
                style: CustomTextStyle.L2.copyWith(color: MyColors.white92),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

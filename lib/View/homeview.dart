import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:voiceai/Controller/chatgpt.dart';
import 'package:voiceai/colors.dart';

import '../customtextstyle.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final ChatGPTController _gptController = Get.put(ChatGPTController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.surface0,
      body: Column(
        children: [
          Obx(() {
            return Expanded(
              child: ListView.builder(
                itemCount: _gptController.messages.length,
                itemBuilder: (ctx, idx) {
                  return Container();
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
                Container(
                  width: 36,
                  height: 36,
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(.04),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white.withOpacity(.92),
                      size: 18,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.center,
                    height: 36,
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
                        contentPadding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: CustomTextStyle.L3
                            .copyWith(color: MyColors.white32),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../controller/chat_room_controller.dart';
import '../../styles/colors.dart';

class ChatTextFieldWidget extends StatelessWidget {
  const ChatTextFieldWidget({
    super.key,
    required TextEditingController chatTextFieldController,
    required Color sendBtnColor,
  })  : _msgFieldController = chatTextFieldController,
        _buttonColor = sendBtnColor;

  final TextEditingController _msgFieldController;
  final Color _buttonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF131313),
      padding: const EdgeInsets.only(
        right: 18,
        top: 8,
        bottom: 24,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
          Expanded(
            child: TextFormField(
              maxLines: null,
              controller: _msgFieldController,
              style: const TextStyle(color: kLightColor),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(20, 12, 40, 12),
                filled: true,
                fillColor: kRichBlack,
                hintText: '메세지 보내기',
                hintStyle: const TextStyle(
                  color: Color(0xFF666666),
                  letterSpacing: -0.6,
                  fontWeight: FontWeight.w400,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(48)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                  borderRadius: BorderRadius.all(Radius.circular(48)),
                ),
                suffixIconConstraints:
                    const BoxConstraints(maxHeight: 30, maxWidth: 40),
                suffixIcon: GestureDetector(
                  onTap: _msgFieldController.text.isEmpty
                      ? null
                      : () async {
                          if (_msgFieldController.text.isNotEmpty ||
                              _msgFieldController.text.trim() != '') {
                            await ChatRoom.sendMessage(
                                _msgFieldController.text);
                            _msgFieldController.clear();
                          }
                        },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _buttonColor,
                    ),
                    child: const Icon(
                      Icons.arrow_upward,
                      color: kBlackColor,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

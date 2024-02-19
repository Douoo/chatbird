import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbird/styles/colors.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    this.senderId,
    this.avatar,
    this.name,
    required this.text,
    required this.fromMe,
    this.imgUrl,
    required this.date,
  });

  final String? senderId;
  final String? avatar;
  final String? name;
  final String text;
  final String? imgUrl;
  final bool fromMe;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          fromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      mainAxisSize: MainAxisSize.min,
      children: [
        !fromMe && avatar != null
            ? CachedNetworkImage(
                imageUrl: avatar ?? '',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => const CircularProgressIndicator(
                  strokeWidth: 2,
                ),
                errorWidget: (context, url, error) => Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: kLightColor,
                  ),
                ),
              )
            : const SizedBox(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment:
                fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Material(
                    borderRadius: fromMe
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(16),
                            bottomLeft: Radius.circular(18),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(18),
                            bottomRight: Radius.circular(18),
                            bottomLeft: Radius.circular(12)),
                    elevation: 1,
                    color: fromMe ? primaryColor : kRichBlack,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      constraints: const BoxConstraints(
                        maxWidth: 200, // Set your desired maximum width here
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!fromMe)
                            Text(
                              name ?? senderId ?? '',
                              style: const TextStyle(
                                color: Color(0xFFADADAD),
                                fontSize: 16,
                                letterSpacing: -0.6,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          Text(
                            text,
                            style: const TextStyle(
                              color: kLightColor,
                              fontSize: 16,
                              letterSpacing: -0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!fromMe)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        formatMessageTimestamp(date),
                        style: const TextStyle(
                          color: Color(0xFF9C9CA3),
                        ),
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String formatMessageTimestamp(DateTime timestamp) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(timestamp);

    if (difference.inDays < 1) {
      if (difference.inHours < 1) {
        int minutes = difference.inMinutes;
        return '$minutes분 전';
      } else {
        int hours = difference.inHours;
        return '$hours시간 전';
      }
    } else if (difference.inDays <= 7) {
      int days = difference.inDays;
      return '$days일 전';
    } else {
      // If more than 7 days, show month and date
      return '${timestamp.month}/${timestamp.day}';
    }
  }
}

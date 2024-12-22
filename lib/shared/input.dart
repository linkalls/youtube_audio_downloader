import "package:flutter/material.dart";

final TextEditingController TextController = TextEditingController();

class TextInputWidget extends StatelessWidget {
  const TextInputWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'youtubeのurlを入力してください',
      ),
      controller: TextController,
    );
  }
}

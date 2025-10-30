
import 'package:flutter/material.dart';
import '../services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SocketService socketService = SocketService();
  final TextEditingController controller = TextEditingController();
  String messages = "";

  @override
  void initState() {
    super.initState();
    socketService.connect(
      onMessage: (msg) {
        setState(() {
          messages += msg;
        });
      },
    );
  }

  void sendMessage() {
    if (controller.text.isNotEmpty) {
      socketService.send(controller.text);
      controller.clear();
    }
  }

  @override
  void dispose() {
    socketService.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Socket Client')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Text(messages),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "메시지를 입력하세요",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

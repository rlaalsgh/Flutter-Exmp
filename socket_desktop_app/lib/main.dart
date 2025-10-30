import 'package:flutter/material.dart';
import 'services/socket_service.dart';

void main() {
  runApp(const SocketDesktopApp());
}

class SocketDesktopApp extends StatelessWidget {
  const SocketDesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket Client (Windows)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
      ),
      home: const SocketHomePage(),
    );
  }
}

class SocketHomePage extends StatefulWidget {
  const SocketHomePage({super.key});

  @override
  State<SocketHomePage> createState() => _SocketHomePageState();
}

class _SocketHomePageState extends State<SocketHomePage> {
  final SocketService socketService = SocketService();
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final List<String> messages = [];
  bool connected = false;
  String status = '서버에 연결되지 않음';

  @override
  void initState() {
    super.initState();
    _connect();
  }

  void _connect() async {
    await socketService.connect(
      onMessage: (msg) {
        setState(() {
          messages.add(msg);
        });
        _scrollToBottom();
      },
      onError: (error) {
        setState(() {
          status = error;
          connected = false;
        });
      },
    );
    setState(() {
      status = '서버에 연결됨';
      connected = true;
    });
  }

  void _sendMessage() {
    if (controller.text.isNotEmpty && connected) {
      socketService.send(controller.text);
      setState(() {
        messages.add("내가 쓴 챗팅: ${controller.text}");
      });
      controller.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    socketService.dispose();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Socket Client'),
        backgroundColor: Colors.blueGrey.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            color: connected ? Colors.green.shade100 : Colors.red.shade100,
            width: double.infinity,
            child: Text(status, textAlign: TextAlign.center),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: const InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: const Text('보내기'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

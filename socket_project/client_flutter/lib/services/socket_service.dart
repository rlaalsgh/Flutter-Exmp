
import 'dart:io';

class SocketService {
  Socket? _socket;

  Future<void> connect({required Function(String) onMessage}) async {
    try {
      _socket = await Socket.connect('127.0.0.1', 3000);
      print('서버에 연결됨');

      _socket!.listen((data) {
        final message = String.fromCharCodes(data);
        onMessage(message);
      }, onDone: () {
        print('서버 연결 종료');
      }, onError: (error) {
        print('오류 발생: $error');
      });
    } catch (e) {
      print('서버 연결 실패: $e');
    }
  }

  void send(String message) {
    _socket?.write('$message\n');
  }

  void dispose() {
    _socket?.destroy();
  }
}

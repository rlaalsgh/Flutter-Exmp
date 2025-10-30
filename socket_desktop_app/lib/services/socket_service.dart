
import 'dart:io';

class SocketService {
  Socket? _socket;

  Future<void> connect({
    required Function(String) onMessage,
    required Function(String) onError,
  }) async {
    try {
      _socket = await Socket.connect('127.0.0.1', 3000);
      print('서버에 연결됨');

      _socket!.listen((data) {
        final message = String.fromCharCodes(data);
        onMessage(message);
      }, onDone: () {
        onError('서버 연결이 종료되었습니다.');
      }, onError: (error) {
        onError('오류: $error');
      });
    } catch (e) {
      onError('서버 연결 실패: $e');
    }
  }

  void send(String message) {
    _socket?.write('$message\n');
  }

  void dispose() {
    _socket?.destroy();
  }
}

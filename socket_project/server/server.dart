
import 'dart:io';

void main() async {
  final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 3000);
  print('서버가 ${server.address.address}:${server.port} 에서 실행 중입니다.');

  await for (var socket in server) {
    print('클라이언트 연결됨: ${socket.remoteAddress.address}:${socket.remotePort}');
    socket.listen((data) {
      final message = String.fromCharCodes(data).trim();
      print('클라이언트로부터 받은 메시지: $message');
      socket.write('서버 응답: $message\n');
    }, onDone: () {
      print('클라이언트 연결 종료');
    });
  }
}

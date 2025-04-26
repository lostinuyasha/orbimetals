import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const String _telegramBotToken =
    '8155413122:AAF6QymEbh1V8k0r2oisXSp-e-djO1dDdB8'; // your bot
const String _telegramUserId = '7812075913'; // your Telegram user ID

Future<void> main() async {
  final server = await HttpServer.bind(
    InternetAddress.anyIPv6,
    8080,
    shared: true,
  );
  print('✅ Hugr Debug Webhook Server running on port 8080');

  await for (HttpRequest request in server) {
    print('🌐 Request: ${request.method} ${request.uri.path}');

    if (request.method == 'POST' &&
        request.uri.path == '/hugr_webhook_listener') {
      try {
        final content = await utf8.decoder.bind(request).join();
        final data = jsonDecode(content);
        print('🚀 Received Signal Data: $data');

        await _sendTelegramAlert(data);

        request.response
          ..statusCode = 200
          ..write('Webhook received and Telegram sent!')
          ..close();
      } catch (e) {
        print('❌ JSON parse failed or Telegram error: $e');
        request.response
          ..statusCode = 400
          ..write('Something went wrong')
          ..close();
      }
    } else {
      request.response
        ..statusCode = 404
        ..write('Nothing here')
        ..close();
    }
  }
}

Future<void> _sendTelegramAlert(Map<String, dynamic> data) async {
  final message = '''
📈 *New Trade Signal!*

*Asset:* ${data['symbol']}
*Action:* ${data['strategy_action']}
*Price:* \$${data['price']}
*Time:* ${data['time']}
*Note:* ${data['alert_name'] ?? 'No Note'}
''';

  final url = 'https://api.telegram.org/bot$_telegramBotToken/sendMessage';

  final payload = {
    'chat_id': _telegramUserId,
    'text': message,
    'parse_mode': 'Markdown',
  };

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(payload),
  );

  if (response.statusCode == 200) {
    print('📬 Telegram alert sent successfully!');
  } else {
    print('❗ Telegram send failed: ${response.body}');
  }
}

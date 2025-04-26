import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'hugr_market_insight_engine.dart'; // assuming this exists

class HugrTradingViewWebhookServer {
  static const String _telegramBotToken =
      '8155413122:AAF6QymEbh1V8k0r2oisXSp-e-djO1dDdB8'; // your bot token
  static const String _telegramUserId = '7812075913'; // your Telegram ID
  static const int _serverPort = 8080;

  static Future<void> startServer() async {
    final server = await HttpServer.bind(
      InternetAddress.anyIPv6,
      _serverPort,
      shared: true,
    );
    print('✅ Successfully bound to port $_serverPort');

    await for (var request in server) {
      print('🌐 Received a request: ${request.method} ${request.uri.path}');

      if (request.method == 'POST' &&
          request.uri.path == '/hugr_webhook_listener') {
        try {
          final content = await utf8.decoder.bind(request).join();
          final data = jsonDecode(content);

          print('🚀 Received TradingView Signal: $data');

          // Save to Hugr Market Insight
          await HugrMarketInsightEngine.recordSignal(
            symbol: data['symbol'],
            type: data['strategy_action'],
            price: double.parse(data['price'].toString()),
            timestamp: DateTime.parse(data['time']).millisecondsSinceEpoch,
            note: data['alert_name'] ?? '',
          );

          // Send Telegram Alert
          await _sendTelegramAlert(data);

          request.response
            ..statusCode = 200
            ..write('Signal received successfully');
          await request.response.close();
        } catch (e) {
          print('❌ Error processing signal: $e');
          request.response
            ..statusCode = 500
            ..write('Error processing signal');
          await request.response.close();
        }
      } else {
        request.response
          ..statusCode = 404
          ..write('Not Found');
        await request.response.close();
      }
    }
  }

  static Future<void> _sendTelegramAlert(Map<String, dynamic> data) async {
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
      print('❗ Failed to send Telegram alert: ${response.body}');
    }
  }
}

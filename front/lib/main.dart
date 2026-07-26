import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ApiDemoPage(),
    );
  }
}

class ApiDemoPage extends StatefulWidget {
  const ApiDemoPage({super.key});

  @override
  State<ApiDemoPage> createState() => _ApiDemoPageState();
}

class _ApiDemoPageState extends State<ApiDemoPage> {
  String _message = 'ボタンを押してAPIを呼び出してください';

  Future<void> _fetchData() async {
    // 先ほど確認した Go サーバーの URL（末尾の /api/hello まで）を入力
    // const url = 'https://8080-cs-d1b31d66-abd5-431f-adea-1a91e31ecd9b.cs-asia-east1-vger.cloudshell.dev/api/hello';
    // ドメイン部分を削って相対パスにします
    const url = '/api/hello';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _message = response.body;
        });
      } else {
        setState(() {
          _message = 'エラー: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = '通信エラーが発生しました: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Web & Go API Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _message,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchData,
              child: const Text('Go API からデータ取得'),
            ),
          ],
        ),
      ),
    );
  }
}
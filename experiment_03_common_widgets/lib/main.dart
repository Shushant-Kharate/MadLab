// Experiment 3: To design Flutter UI by including common widgets.
import 'dart:convert';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'MAD Lab 03',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
    home: const LabPage(),
  );
}

Widget labBody(List<Widget> children) => SafeArea(
  child: Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 850),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          for (final child in children)
            Padding(padding: const EdgeInsets.only(bottom: 16), child: child),
        ],
      ),
    ),
  ),
);

void message(BuildContext context, String value) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));

class LabPage extends StatefulWidget {
  const LabPage({super.key});
  @override
  State<LabPage> createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  int clicks = 0;
  bool liked = false;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('03 / Common Widgets')),
    body: labBody([
      const Text(
        'Welcome to Flutter',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      const FlutterLogo(size: 72),
      Image.memory(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAeAAAAC0CAIAAADD3miXAAAEjElEQVR4nO3WvW2cRxSFYdJg5EoUugOnqsGAVYdKcB0SoBqcqgOHboAhU6cUBAvSkFpyd7+/OXfmeQoY3GDw4tzePzzeAJDnl94HAHCaQAOEEmiAUAINEEqgAUIJNEAogQYIJdAAoQQaIJRAA4QSaIBQAg0QSqABQgk0QCiBBggl0AChBBoglEADhBJogFACDRBKoAFCCTRAKIEGCCXQAKEEGiCUQAOEEmiAUAINEEqgAUIJNEAogQYIJdAAoQQaIJRAA4S6630AVf359383FXx8+2vvE2AhC5ol1BkOINBcTZ3hGALNddQZDiPQXEGd4UgCzaXUGQ4m0FxEneF4As156gxdCDRnqDP0ItC8Rp2hI4HmReoMfQk0p6kzdCfQnKDOkECgeU6dIYRA84Q6Qw6B5gd1higCzTfqDGkEmq/UGQIJNOoMoQR6drYzxBLoqakzJBPoeakzhBPoSakz5BPoGakzlCDQ01FnqEKg56LOUIhAT0SdoRaBnoU6QzkCPQV1hooEenzqDEUJ9ODUGeoS6JGpM5Qm0MNSZ6hOoMekzjAAgR6QOsMYBHo06gzDEOihqDOMRKDHoc4wGIEehDrDeAR6BOoMQ7rrfQBrqXPrt/efS3ypf/76vfcJFGBB16bOLXVmMAJdmDq31JnxCHRV6txSZ4Yk0CWpc0udGZVA16POLXVmYAJdjDq31JmxCXQl6txSZ4Yn0GWoc0udmYFA16DOLXVmEgJdgDq31Jl53N4/PPa+AS6lzkzFgqYMdWY2Ak0N6syEBJoC1Jk5CTTp1JlpCTTR1JmZCTS51JnJCTSh1BkEmkTqDBY0idQZ/mdBk0Wd4TuBJog6Q0ugSaHO8IxAE0Gd4WcCTX/qDCcJNJ2pM7xEoOlJneEVAk036gyvE2j6UGc4S6DpQJ3hEgLN0dQZLiTQHEqd4XICzXHUGa4i0BxEneFaAs0R1BkWEGh2p86wjECzL3WGxQSaHakzrCHQ7EWdYaW7tQ/AKercevPHhxLf5N9P73qfwBMWNNtT55Y6s5hAszF1bqkzawg0W1LnljqzkkCzGXVuqTPrCTTbUOeWOrMJgWYD6txSZ7Yi0Kylzi11ZkMCzSrq3FJntiXQLKfOLXVmcwLNQurcUmf2cHv/8LjLwzANdWYnFjSsos7sR6BhOXVmVwINC6kzexNoWEKdOYBAw9XUmWMINFxHnTmMQMMV1JkjCTRcSp05mEDDRdSZ4wk0nKfOdCHQcIY604tAw2vUmY4EGl6kzvQl0HCaOtOdQMMJ6kwCgYbn1JkQAg1PqDM5BBp+UGeiCDR8o86kEWj4Sp0JJNCgzoQSaGZnOxNLoJmaOpNMoJmXOhNOoJmUOpNPoJmROlOCQDMddaYKgWYu6kwhAs1E1JlaBJpZqDPlCDRTUGcqEmjGp84UJdAMTp2pS6AZmTpTmkAzLHWmOoFmTOrMAASaAakzYxBoRqPODEOgGYo6M5Lb+4fH3jcAcIIFDRBKoAFCCTRAKIEGCCXQAKEEGiCUQAOEEmiAUAINEEqgAUIJNEAogQYIJdAAN5m+ALvA177pyXR/AAAAAElFTkSuQmCC',
        ),
        height: 130,
        semanticLabel: 'Flutter inspired blue geometric artwork',
      ),
      Container(
        padding: const EdgeInsets.all(20),
        color: Colors.amber.shade100,
        child: const Column(
          children: [
            Text('This is a Container widget.'),
            SizedBox(height: 8),
            Text('Column arranges these two labels vertically.'),
          ],
        ),
      ),
      Row(
        children: [
          IconButton(
            tooltip: 'Toggle favorite',
            onPressed: () => setState(() => liked = !liked),
            icon: Icon(
              liked ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
          Expanded(
            child: Text(
              liked ? 'Flutter is a favorite!' : 'Flutter is awesome',
            ),
          ),
        ],
      ),
      ElevatedButton(
        onPressed: () => setState(() => clicks++),
        child: Text('Click me: $clicks'),
      ),
      const SizedBox(height: 8),
      const Text(
        'Widgets: Text, Icon, Image, Container, Row, Column, SafeArea, Padding, SizedBox and buttons.',
      ),
    ]),
  );
}

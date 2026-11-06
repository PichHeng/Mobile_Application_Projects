import 'package:demo1/core/widgets/glass_container.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: GlassTestPage()));
}

class GlassTestPage extends StatelessWidget {
  const GlassTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/login_bg.jpg', fit: BoxFit.cover),
          const Center(
            child: GlassContainer(
              padding: EdgeInsets.all(24),
              child: Text(
                'Hello Glass',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

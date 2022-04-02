import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/blurhash.dart';

void main() {
  runApp(const ShaderDemo());
}

class ShaderDemo extends StatefulWidget {
  const ShaderDemo({Key? key}) : super(key: key);

  @override
  State<ShaderDemo> createState() => _ShaderDemoState();
}

class _ShaderDemoState extends State<ShaderDemo> {
  late Future<FragmentProgram> fragment;

  @override
  void initState() {
    super.initState();
    fragment = loadShader();
  }

  Future<FragmentProgram> loadShader() async {
    final spirv = await rootBundle.load("shaders/blur_hash.spv");
    return FragmentProgram.compile(spirv: spirv.buffer);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<FragmentProgram>(
            future: fragment,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomPaint(
                  painter: ShaderPainter(fragmentProgram: snapshot.data!),
                );
              } else if (snapshot.hasError) {
                if (kDebugMode) {
                  print(snapshot.error);
                }
                return const Text("Error");
              } else {
                return const Text("compiling");
              }
            },
          ),
        ),
      );
}

class ShaderPainter extends CustomPainter {
  ShaderPainter({required this.fragmentProgram});

  final FragmentProgram fragmentProgram;

  @override
  void paint(Canvas canvas, Size size) {
    final colors = decodeBlurHash("LGFFaXYk^6#M@-5c,1J5@[or[Q6."); // 4x3 colors
    // final colors = decodeBlurHash("L6Pj42jE.AyE_3t7t7R**0o#DgR4"); // 4x3 colors

    final paint = Paint()
      ..shader = fragmentProgram.shader(
        floatUniforms: Float32List.fromList(
          [size.width, size.height, ...colors.expand((color) => color)],
        ),
      );
    final rect = Offset.zero & size;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(32)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

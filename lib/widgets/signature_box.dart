import 'package:flutter/material.dart';
import 'dart:io';

class SignatureBox extends StatefulWidget {
  final Function(String) onSaved;

  const SignatureBox({Key? key, required this.onSaved}) : super(key: key);

  @override
  State<SignatureBox> createState() => _SignatureBoxState();
}

class _SignatureBoxState extends State<SignatureBox> {
  List<Offset?> points = <Offset?>[];
  bool isSigned = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          // Drawing area
          GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                Offset localPosition = renderBox.globalToLocal(details.globalPosition);
                points.add(localPosition);
                if (!isSigned) {
                  isSigned = true;
                }
              });
            },
            onPanEnd: (DragEndDetails details) {
              points.add(null);
            },
            child: CustomPaint(
              painter: SignaturePainter(points),
              size: Size.infinite,
            ),
          ),

          // Placeholder text when empty
          if (!isSigned)
            const Center(
              child: Text(
                'Signez ici avec votre doigt',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 16,
                ),
              ),
            ),

          // Action buttons
          Positioned(
            bottom: 8,
            right: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Clear button
                if (isSigned)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      onPressed: _clearSignature,
                      icon: const Icon(Icons.clear, color: Colors.red),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ),

                // Save button
                if (isSigned)
                  IconButton(
                    onPressed: _saveSignature,
                    icon: const Icon(Icons.check, color: Colors.green),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _clearSignature() {
    setState(() {
      points.clear();
      isSigned = false;
    });
  }

  void _saveSignature() {
    // In a real app, you would save the signature to a file
    // For now, we'll just simulate saving and return a mock path
    final mockPath = '/path/to/signature_${DateTime.now().millisecondsSinceEpoch}.png';
    widget.onSaved(mockPath);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signature sauvegardée'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(seconds: 1),
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFF1E293B)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
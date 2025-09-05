import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:convert';

class SignatureBox extends StatefulWidget {
  final Function(String) onSaved; // (path, base64)

  const SignatureBox({Key? key, required this.onSaved}) : super(key: key);

  @override
  State<SignatureBox> createState() => _SignatureBoxState();
}

class _SignatureBoxState extends State<SignatureBox> {
  List<Offset?> points = <Offset?>[];
  bool isSigned = false;
  bool isSaving = false;
  final GlobalKey _signatureKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          // Drawing area with RepaintBoundary for capturing
          RepaintBoundary(
            key: _signatureKey,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: GestureDetector(
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

          // Loading overlay
          if (isSaving)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
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
                if (isSigned && !isSaving)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      onPressed: _clearSignature,
                      icon: const Icon(Icons.clear, color: Colors.red),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(8),
                        elevation: 2,
                      ),
                    ),
                  ),

                // Save button
                if (isSigned && !isSaving)
                  IconButton(
                    onPressed: _saveSignature,
                    icon: const Icon(Icons.check, color: Colors.green),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                      elevation: 2,
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

  Future<void> _saveSignature() async {
    if (!isSigned || isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      // Capture the signature as an image
      RenderRepaintBoundary boundary = _signatureKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        
        // Convert to Base64
        String base64String = base64Encode(pngBytes);
        
        
        // Call the callback with both path and base64
        widget.onSaved(base64String);
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Signature sauvegardée'),
                ],
              ),
              backgroundColor: Color(0xFF10B981),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        throw Exception('Impossible de capturer la signature');
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Erreur lors de la sauvegarde: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFEF4444),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
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
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Draw signature paths
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
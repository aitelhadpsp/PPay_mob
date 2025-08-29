import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';

class SignatureBox extends StatefulWidget {
  final Function(String)? onSaved; // Callback with file path

  const SignatureBox({super.key, this.onSaved});

  @override
  _SignatureBoxState createState() => _SignatureBoxState();
}

class _SignatureBoxState extends State<SignatureBox> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Future<void> _saveSignature() async {
    Uint8List? data = await _controller.toPngBytes();
    if (data == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/signature.png';
    await File(path).writeAsBytes(data);

    if (widget.onSaved != null) {
      widget.onSaved!(path);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Signature saved at: $path')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Signature(controller: _controller, backgroundColor: Colors.white)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(onPressed: () => _controller.clear(), child: Text('Clear')),
            TextButton(onPressed: _saveSignature, child: Text('Save')),
          ],
        ),
      ],
    );
  }
}

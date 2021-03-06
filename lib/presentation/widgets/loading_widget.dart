import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey[100],
      child: CircularProgressIndicator(strokeWidth: 4),
    );
  }
}

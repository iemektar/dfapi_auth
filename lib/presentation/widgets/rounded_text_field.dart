import 'package:flutter/material.dart';

class RoundedTextField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final bool isObscure;
  final double width;
  final Function(String) onChanged;

  const RoundedTextField({
    Key key,
    this.hintText,
    this.icon,
    this.isObscure,
    this.width,
    this.onChanged,
  }) : super(key: key);

  @override
  _RoundedTextFieldState createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: widget.width ?? size.width * .9,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[600]
            : Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            widget.icon != null ? Icon(widget.icon) : null,
            Flexible(
              child: TextFormField(
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  hintText: widget.hintText,
                ),
                obscureText: widget.isObscure ?? false,
                cursorColor: Colors.grey[800],
                onChanged: widget.onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

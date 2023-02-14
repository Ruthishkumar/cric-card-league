import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyWidgetState();
  }
}

class _MyWidgetState extends State<MyWidget> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: loading
            ? Container(
                key: Key("loading"),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: GestureDetector(
                      onTap: _toggle,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
              )
            : Container(
                key: Key("normal"),
                child: Center(
                  child: GestureDetector(
                    onTap: _toggle,
                    child: const Text("WELCOME"),
                  ),
                ),
              ),
      ),
    );
  }

  _toggle() {
    setState(() {
      loading = !loading;
    });
  }
}

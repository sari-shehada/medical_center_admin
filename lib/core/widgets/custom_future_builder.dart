import 'package:flutter/material.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  const CustomFutureBuilder({
    super.key,
    required this.future,
    required this.builder,
  });
  final Future<T> future;
  final Widget Function(BuildContext context, T snapshot) builder;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const Center(
            child: Text('Error Occurred'),
          );
        }
        return builder(context, snapshot.data as T);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class LoadingCircle extends StatelessWidget {
  const LoadingCircle({
    Key? key,
    required this.loading,
  }) : super(key: key);

  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      return SpinKitCircle(
        color: Colors.blue,
        size: 50.0,
      );
    } else {
      return Text("");
    }
  }
}

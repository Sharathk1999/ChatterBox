import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../colors.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
       child: LoadingAnimationWidget.inkDrop(color: whiteColor, size: 200),
      
    );
  }
}
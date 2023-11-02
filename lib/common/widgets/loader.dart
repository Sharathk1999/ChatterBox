import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../colors.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
       child: LoadingAnimationWidget.inkDrop(color: whiteColor, size: 70),
      
    );
  }
}
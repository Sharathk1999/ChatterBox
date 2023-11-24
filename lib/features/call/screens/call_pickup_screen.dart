import 'package:chatterbox/colors.dart';
import 'package:chatterbox/features/call/controller/call_controller.dart';
import 'package:chatterbox/models/call_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CallPickUpScreen extends ConsumerWidget {
  final Widget scaffold;
  const CallPickUpScreen({
    super.key,
    required this.scaffold,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.watch(callControllerProvider).callStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          CallModel call =
              CallModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          if (call.hasDialled) {
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                       padding: const EdgeInsets.all(10),
                  
                      decoration: BoxDecoration(
                          color: whiteColor.withOpacity(0.2),
                          borderRadius:const BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          )),
                      child: Text(
                        'Incoming call',
                        style: GoogleFonts.quicksand(
                          color: whiteColor,
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 55,
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          color: whiteColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12)),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(call.callerPic),
                        radius: 60,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      call.callerName,
                      style: GoogleFonts.quicksand(
                        color: whiteColor.withOpacity(0.5),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon:const Icon(
                            Icons.call_end_rounded,
                            color: Colors.red,
                          ),
                          
                          splashColor: Colors.red.withOpacity(0.3),
                        ),
                        const SizedBox(width: 35,),
                        IconButton(
                          onPressed: () {},
                          icon:const Icon(
                            Icons.call,
                            color: Colors.green,
                          ),
                            splashColor: Colors.green.withOpacity(0.3),

                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        }
        return scaffold;
      },
    );
  }
}

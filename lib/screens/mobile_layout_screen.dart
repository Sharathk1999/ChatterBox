import 'package:chatterbox/colors.dart';
import 'package:chatterbox/widgets/contacts_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileLayoutScreen extends StatelessWidget {
  const MobileLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: Text(
            'ChatterBox',
            style: GoogleFonts.quicksand(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            indicator: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(50),
              // image: DecorationImage(image: AssetImage('assets/backgroundImage.png',),fit: BoxFit.cover)
            ),      
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: Colors.white60,
            
            unselectedLabelColor: Colors.white30,
            labelStyle: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'Chatter',
              ),
              Tab(
                text: 'Stories',
              ),
              Tab(
                text: 'Connect',
              ),
            ],
          ),
        ),
        body: const ContactsList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: tabColor,
          child: const Icon(
            Icons.chat_bubble_outline_rounded,
            color: Colors.white38,
          ),
        ),
      ),
    );
  }
}

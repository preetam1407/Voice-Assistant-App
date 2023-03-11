import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant_app/api_services.dart';
import 'package:voice_assistant_app/chat_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SpeechToText speechToText = SpeechToText();

  var text = "Hold and start";
  var controlbutton = false;

  final List<ChatMessage> messages = [];

  var scrollController  = ScrollController();

  scrollmethod(){
    scrollController.animateTo(scrollController.position.maxScrollExtent, 
    duration: const Duration(milliseconds: 3), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 78.0,
        animate: controlbutton,
        duration: const Duration(milliseconds: 2000),
        glowColor: Colors.teal,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if(!controlbutton){
              var pressed = await speechToText.initialize();
              if(pressed){
                setState(() {
                  controlbutton = true;
                  speechToText.listen(
                    onResult: (result) {
                      setState(() {
                        text = result.recognizedWords;
                      });
                    },
                  );
                });
              }
            }
          },
          onTapUp: (details) async {
            setState(() {
              controlbutton = false;
            });
            speechToText.stop();    

            messages.add(ChatMessage(text: text, type: ChatMessagetype.user));
            var message = await ApiServcies.sendmessage(text);

            setState(() {
              messages.add(ChatMessage(text: message, type: ChatMessagetype.bot));
            });
          },
          child: CircleAvatar
          (backgroundColor: Colors.blue, 
          radius: 35, 
          child: Icon(controlbutton? Icons.mic: Icons.mic_none, color: Colors.white,),
          ),
        ),
      ),
      appBar: AppBar(
        leading: const Icon(Icons.sort_sharp, color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0.0,
        title: const Text(
          "Voice Assistant",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color:Colors.black,
          ),
        ),
      ),
      body: Container(
        
         
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          
          child: Column(
            children:[
              Text(
            text, 
            style: TextStyle(fontSize: 20, color: controlbutton? Colors.black87:Colors.black26, fontWeight: FontWeight.w700),
          ), 
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                shrinkWrap: true,
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  var chat = messages[index];

                  return chatbubble(
                    chattext: chat.text,
                    type: chat.type
                  );
                },
              ),
            )),
          
          const SizedBox(height: 10),
          const Text(
            "Developed by Preetam", 
            style: TextStyle(fontSize: 20, color:Colors.black54, fontWeight: FontWeight.w400),
          ),
          ],
          ),
          ),
        );
  }

  Widget chatbubble({required chattext, required ChatMessagetype? type}){
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.teal,
          child: type == ChatMessagetype.bot
          ? const Icon(Icons.radar_rounded, color: Colors.white)
          : const Icon(Icons.person, color: Colors.white),
          // Image.asset('assets/ChatGPT_logo.png')
        ),
        const SizedBox(width: 12),
        Expanded
        (
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: type == ChatMessagetype.bot?  Colors.blueAccent:Colors.white,
              borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                    ),
                    child: Text(
                      "$chattext",
                      style: TextStyle(
                        color:type == ChatMessagetype.bot?  Colors.teal:Colors.black, 
                        fontSize: 15, 
                        fontWeight: type == ChatMessagetype.bot? FontWeight.w700: FontWeight.w400,
                        )
                    ),
          ),
        ),
      ],
    );
  }
}
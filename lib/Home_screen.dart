import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:voice_assistant_app/api_services.dart';
import 'package:voice_assistant_app/chat_model.dart';
import 'package:voice_assistant_app/ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TextEditingController controller = TextEditingController();
  final SpeechToText speechToText = SpeechToText();
  var text = "";
  var microphone = false;

  final List<ChatMessage> messages = [];
  var scrollController  = ScrollController();
  void scrollmethod(){
    scrollController.animateTo(scrollController.position.maxScrollExtent, 
    duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  // send text and voice widget.
  Widget _buildtextcomposer(){
    return Row(
      children: [
          IconButton(onPressed: (){
          // do something
        }, 
        icon: const Icon(Icons.camera_alt_outlined),
        ),

          Expanded(
          child: TextField(
            decoration: const InputDecoration.collapsed(hintText: "Send a message"),
            controller: TextEditingController(text: text),
            
          ),
        ),

        IconButton(onPressed: (){
          // do something
        }, 
        icon: const Icon(Icons.send),
        ),
      ],
    ).px16();
  }

  

  @override
  Widget build(BuildContext context) {
    // if (speechToText.isAvailable) {
    //   return Text('Speech recognition is available'); 
    // } 
    // else {
    //   print('Speech recognition not availthis device');
    // }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 50.0,
        animate: microphone,
        duration: const Duration(milliseconds: 2000),
        glowColor: Colors.teal,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,

        child: GestureDetector(
          onTapDown: (details) async {
            if(!microphone){
              var pressed = await speechToText.initialize();
              if(pressed){
                setState(() {
                  microphone = true;
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
              microphone = false;
            });
            speechToText.stop();    

            messages.add(ChatMessage(text: text, type: ChatMessagetype.user));
            var message = await ApiServcies.sendmessage(text);

            setState(() {
              messages.add(ChatMessage(text: message, type: ChatMessagetype.bot));
            });
          },

          

          child: CircleAvatar
          (backgroundColor: responsebackgroundColor, 
          radius: 35, 
          child: Icon(microphone? Icons.mic: Icons.mic_none, color: Colors.white,),
          ),
        ),
      ),


      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 150, 139, 179),
        elevation: 0.0,
        title: const Text(
          "ConversAI",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color:Colors.black,
          ),
        ),
        actions: [
          IconButton(onPressed: (){
              // do
          }, 
          icon: const Icon(Icons.person),
          )
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            Flexible(child: ListView.builder(
              itemBuilder: (context, index){
                return Container(
                  height: 100,
                  color: Color.fromARGB(255, 234, 245, 243),
                );
            },
            )),
          Container(
            decoration: BoxDecoration(
              color: context.cardColor,
            ),
            child: _buildtextcomposer(),
          ) 
        ],
        ),
      ));
      // Container(
      //     // padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          
      //     child: Column(
      //       children:[
      //         Text(
      //       text, 
      //       style: TextStyle(fontSize: 20, color: microphone? Colors.black87:Colors.black26, fontWeight: FontWeight.w700),
      //     ), 
      //     const SizedBox(height: 10),
      //     Expanded(
      //       child: Container(
      //         decoration: BoxDecoration(
      //           color: Colors.blueGrey,
      //           borderRadius: BorderRadius.circular(10),
      //         ),
      //         child: ListView.builder(
      //           physics: const BouncingScrollPhysics(),
      //           controller: scrollController,
      //           shrinkWrap: true,
      //           itemCount: messages.length,
      //           itemBuilder: (BuildContext context, int index) {
      //             var chat = messages[index];

      //             return chatbubble(
      //               chattext: chat.text,
      //               type: chat.type
      //             );
      //           },
      //         ),
      //       )),
          


        //   const SizedBox(height: 10),
        //   // const Text(
        //   //   "Developed by Preetam", 
        //   //   style: TextStyle(fontSize: 20, color:Colors.black54, fontWeight: FontWeight.w400),
        //   // ),
        //   ],
        //   ),
        //   ),
        // );
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
          // Image.asset('assets\chat_logo.png')
        ),
        const SizedBox(width: 12),
        Expanded
        (
          child: Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: type == ChatMessagetype.bot? responsebackgroundColor:Colors.white,
              borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                    ),
                    child: Text(
                      "$chattext",
                      style: TextStyle(
                        color:type == ChatMessagetype.bot?  Colors.white:Colors.black, 
                        fontSize: 15, 
                        fontWeight: type == ChatMessagetype.bot? FontWeight.w500: FontWeight.w300,
                        )
                    ),
          ),
        ),
      ],
    );
  }
}


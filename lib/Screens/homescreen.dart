import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/loginpage.dart';
import '../provider/chat_provider.dart';
import '../provider/theme.dart';
import '../provider/utilities/utilities.dart';
import '../widgets/chats.dart';
import '../widgets/text_and_voice_field.dart';
import '../widgets/theme_switch.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Flexible(
          child: Text(
            'ChatScreen',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: const Icon(Icons.logout_sharp),
          ),
          Consumer(
            builder: (context, ref, child) => Icon(
              ref.watch(activeThemeProvider) == Themes.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
          ),
          const ThemeSwitch(),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Consumer(
            builder: (context, ref, child) {
              final chats = ref.watch(chatprovider);
              return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) => Chat(
                text: chats[index].message, isUser: chats[index].isUser),
              );
            }
          ),
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: TextAndVoiceField(),
          ),
          const SizedBox(height: 10,
          ),
        ],
      ),
    );
  }
}



// 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
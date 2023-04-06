import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_assistant_app/widgets/toggle_button.dart';
import '../constants/models/chat_model.dart';
import '../provider/chat_provider.dart';
import '../services/ai_handler.dart';
import '../services/voice_handler.dart';

enum inputmode {
  text,
  voice,
}

class TextAndVoiceField extends ConsumerStatefulWidget {
  const TextAndVoiceField({super.key});

  @override
  ConsumerState<TextAndVoiceField> createState() => _TextAndVoiceFieldState();
}

class _TextAndVoiceFieldState extends ConsumerState<TextAndVoiceField> {
  inputmode _inputMode = inputmode.voice;
  final _messageController = TextEditingController();
  final AIHandler _openAI = AIHandler();
   final VoiceHandler voiceHandler = VoiceHandler();
  var _isReplying = false;
  var _isListening = false;

  @override
  void initState() {
    voiceHandler.initSpeech();
    super.initState();
  }

  @override
  void dispose(){
    _messageController.dispose();
    // _openAI.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              onChanged: (value){
                value.isNotEmpty? 
                setInputMode(inputmode.text): 
                setInputMode(inputmode.voice);
              },
              cursorColor: Theme.of(context).colorScheme.onPrimary,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  borderRadius: BorderRadius.circular(
                    12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 01),
          ToggleButton(
            isListening: _isListening,
            isReplying: _isReplying,
            inputMode: _inputMode, 
            sendtextmessage: (){
              final message = _messageController.text;
              _messageController.clear();
              sendtextmessage(message);
            },
            sendvoicemessage: sendvoicemessage,
            )
        ],
      );
  }


void setInputMode(inputmode inputMode){
  setState((){
    _inputMode = inputMode;
  });
}

void sendvoicemessage() async{
  if (!voiceHandler.isEnabled) {
      print('Not supported');
      return;
    }
    if (voiceHandler.speechToText.isListening) {
      await voiceHandler.stopListening();
      setListeningState(false);
    } else {
      setListeningState(true);
      final result = await voiceHandler.startListening();
      setListeningState(false);
      sendtextmessage(result);
    }
  }
void sendtextmessage(String message) async {
    setReplyingState(true);
    addToChatList(message, true, DateTime.now().toString());
    addToChatList('Typing...', false, 'typing');
    setInputMode(inputmode.voice);
    final aiResponse = await _openAI.getResponse(message);
    removeTyping();
    addToChatList(aiResponse, false, DateTime.now().toString());
    setReplyingState(false);
  }

  void setReplyingState(bool isReplying) {
    setState(() {
      _isReplying = isReplying;
    });
  }

  void setListeningState(bool isListening) {
    setState(() {
      _isListening = isListening;
    });
  }

  void removeTyping() {
    final chats = ref.read(chatprovider.notifier);
    chats.removeTyping();
  }

  void addToChatList(String message, bool isUser, String id) {
    final chats = ref.read(chatprovider.notifier);
    chats.add(ChatModel(
      id: id,
      message: message,
      isUser: isUser,
    ));
  }
}
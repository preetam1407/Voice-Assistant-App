import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/models/chat_model.dart';


class ChatNotifier extends StateNotifier<List<ChatModel>>{
  ChatNotifier() : super([]);
  void add(ChatModel chat){
    state = [...state, chat];
  }
  void removeTyping() {
    state = state..removeWhere((chat) => chat.id == 'typing');
  }
}

final chatprovider = StateNotifierProvider<ChatNotifier, List<ChatModel>>
((ref) => ChatNotifier(),
);
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yes_no_app/domain/entities/mesagge.dart';
import 'package:yes_no_app/presentation/providers/chat_provider.dart';
import 'package:yes_no_app/presentation/widgets/chat/her_message_buble.dart';
import 'package:yes_no_app/presentation/widgets/chat/my_message_buble.dart';
import 'package:yes_no_app/presentation/widgets/shared/message_field_box.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Estructura basica del chat
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(4.0),
          //CAMBIO DE AVATAR
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://image.enjoymovie.net/MlM3fVjSwjWyHXask-SgJ04J_NI=/256x256/smart/core/p/9vwJ9gYmA5.jpg'),
          ),
        ),
        title: const Text('Asistente GANA', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: _ChatView(),
      
    );
  }
}

class _ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Manejo del estado del chat
    final chatProvider = context.watch<ChatProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              controller: chatProvider.chatScrollController,
              itemCount: chatProvider.messageList.length,
              itemBuilder: (context, index) {
                final message = chatProvider.messageList[index];
                return (message.fromWho == FromWho.other)
                    ? HerMessageBuble(
                        message: message,
                      )
                    : MyMesageBuble(
                        message: message,
                      );
              },
            )),
            const SizedBox(height: 5),
            //Caja de texto
            MessageFieldBox(
              onValue: chatProvider.sendMessage,
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

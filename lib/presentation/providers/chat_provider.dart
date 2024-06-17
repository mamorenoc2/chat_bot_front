import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yes_no_app/config/helpers/get_yes_no_answer.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart' as df;
import 'dart:convert';
import 'dart:io';
import 'package:yes_no_app/domain/entities/mesagge.dart' as custom;


class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();
  final getYesNoAnswer = GetYesNoAnswer();
  List<custom.Message> messageList = [];

  Future<void> otherReply() async {
    final otherMessage = await getYesNoAnswer.getAnswer();
    messageList.add(otherMessage);
    notifyListeners();
    moveScrollToButton();
  }

void response(query) async {
  try {
    final jsonString = await rootBundle.loadString('assets/botService.json');
    final jsonCredentials = jsonDecode(jsonString);
    custom.Message responses;

    df.DialogFlowtter dialogFlowtter = df.DialogFlowtter(
      projectId: jsonCredentials['alvaroiabot'],
      credentials: df.DialogAuthCredentials.fromJson(jsonCredentials),
    );

    df.DetectIntentResponse response = await dialogFlowtter.detectIntent(
      queryInput: df.QueryInput(text: df.TextInput(text: query, languageCode: 'en')),
    );

    response.queryResult?.fulfillmentMessages?.forEach((message) {
    String text = message.text?.text?.join() ?? 'No message'; 
    responses = custom.Message(text: text, fromWho: custom.FromWho.other);
      messageList.add(responses);
    notifyListeners();
    moveScrollToButton();
    });
  } catch (e) {
    print('Ocurrió un error: $e');
  }
}
  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;
    final newMessage = custom.Message(text: text, fromWho: custom.FromWho.me);
    messageList.add(newMessage);
    if (text.endsWith('?')) {
      otherReply();
    } else {
      //AQUI SE MODIFICA PARA IMPLEMENTAR LO DE OPEN AI
      response(text);
    }
    notifyListeners();
    moveScrollToButton();
  }

  Future<void> moveScrollToButton() async {
    await Future.delayed(const Duration(milliseconds: 100));
    chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }
}

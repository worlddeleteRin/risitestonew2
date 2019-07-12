import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'shopping_cart.dart';
import 'model/app_state_model.dart';

mailIt(AppStateModel model) async {
  String username = 'naken505@gmail.com';
  String password = 'Risitesto';

  final smtpServer = gmail(username, password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = new SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.  
  
  // Create our message.
  final message = new Message()
    ..from = new Address(username, 'Your name')
    ..recipients.add('worlddelete0@gmail.com')
    ..subject = 'Заказ с приложения Рис и Тесто :: 😀 :: ${new DateTime.now()}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<h1>Товаров заказано: ${model.totalCartQuantity}</h1>\n<p>${model.totalProductsInCartName} : ${model.totalProductsInCartQuantity}</p>";

  // Use [catchExceptions]: true to prevent [send] from throwing.
  // Note that the default for [catchExceptions] will change from true to false
  // in the future!
  final sendReports = await send(message, smtpServer, catchExceptions: false);
  
  }



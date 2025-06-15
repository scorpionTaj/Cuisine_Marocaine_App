import 'package:appwrite/appwrite.dart';

class AppwriteService {
  late Client client;
  late Account account;

  AppwriteService() {
    client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1') // ou ton endpoint local
        .setProject('TON_PROJECT_ID') // ton vrai ID Appwrite
        .setSelfSigned(status: true); // seulement si tu es en local

    account = Account(client);
  }
}

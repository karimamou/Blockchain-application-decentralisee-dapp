import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contract_linking.dart'; // Import de votre logique
import 'helloUI.dart';          // Import de votre interface

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Le ChangeNotifierProvider permet d'injecter la connexion Blockchain
    // dans toute l'application pour qu'elle soit accessible partout.
    return ChangeNotifierProvider<ContractLinking>(
      create: (_) => ContractLinking(),
      child: MaterialApp(
        title: "Hello World Dapp",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.cyan[400],
         
          colorScheme: ColorScheme.dark(
            primary: Colors.cyan[400]!,
            secondary: Colors.deepOrange[200]!,
          ),
        ),
        home: HelloUI(), 
      ),
    );
  }
}
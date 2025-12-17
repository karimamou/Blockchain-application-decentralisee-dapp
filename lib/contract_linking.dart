import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart'; 
import 'package:web3dart/web3dart.dart';

class ContractLinking extends ChangeNotifier {
  // --- CONFIGURATION ---
  final String _rpcUrl = "http://127.0.0.1:7545";
  final String _wsUrl = "ws://127.0.0.1:7545/";
  
  // VOTRE CLÉ PRIVÉE (Vérifiez bien qu'elle correspond au compte Index 0 de Ganache ouvert)
  final String _privateKey = "0x0656e9fd967bd81bcaecd5d4add0c19113391e078d9a4ba2381aadf0bf6c15cf";

  // --- VARIABLES ---
  late Web3Client _client;
  bool isLoading = true;
  
  late String _abiCode;
  late EthereumAddress _contractAddress;
  late Credentials _credentials;
  late DeployedContract _contract;
  
  late ContractFunction _yourName;
  late ContractFunction _setName;
  
  String deployedName = "";

  ContractLinking() {
    initialSetup();
  }

  initialSetup() async {
    // Connexion HTTP simple
    _client = Web3Client(_rpcUrl, Client());

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile = await rootBundle.loadString("src/artifacts/HelloWorld.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    
    // Récupération de l'adresse
    _contractAddress = EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"].toString());
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
      ContractAbi.fromJson(_abiCode, "HelloWorld"), 
      _contractAddress
    );

    _yourName = _contract.function("yourName");
    _setName = _contract.function("setName");

    await getName();
  }

  Future<void> getName() async {
    try {
      var currentName = await _client.call(
        contract: _contract, 
        function: _yourName, 
        params: []
      );
      deployedName = currentName[0];
    } catch(e) {
      print("Erreur lecture: $e");
      deployedName = "Erreur";
    }
    
    isLoading = false;
    notifyListeners();
  }

  Future<void> setName(String nameToSet) async {
    isLoading = true;
    notifyListeners();
    
    print("Envoi de la transaction pour : $nameToSet");

    try {
      await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract, 
          function: _setName, 
          parameters: [nameToSet],
          maxGas: 1000000, 
          gasPrice: EtherAmount.inWei(BigInt.from(20000000000)), // 20 Gwei
        ),
        chainId: 1337 
      );
      print("Transaction envoyée avec succès !");
    } catch (e) {
      print("ERREUR TRANSACTION : $e");
    }
    
    await getName();
  }
}
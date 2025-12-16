import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart'; 
import 'package:web3dart/web3dart.dart';


class ContractLinking extends ChangeNotifier {
  // --- CONFIGURATION ---
  // Pour Chrome (Web) et Windows, on utilise 127.0.0.1
  final String _rpcUrl = "http://127.0.0.1:7545";
  final String _wsUrl = "ws://127.0.0.1:7545/";
  
  //  CLÉ PRIVÉE 
  final String _privateKey = "0x9d58258f0b492003480c05c1e4fc2f06cf9fbc8d016b2fa414b074fd6b1f3548";

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
    // MODIFICATION 1 : Connexion HTTP simple (Plus stable pour Chrome)
    _client = Web3Client(_rpcUrl, Client());

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    // Lecture du fichier JSON
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
    // Lecture simple
    var currentName = await _client.call(
      contract: _contract, 
      function: _yourName, 
      params: []
    );
    
    deployedName = currentName[0];
    isLoading = false;
    notifyListeners();
  }

  Future<void> setName(String nameToSet) async {
    isLoading = true;
    notifyListeners();
    
    //5777' pour éviter l'attente infinie
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract, 
        function: _setName, 
        parameters: [nameToSet]
      ),
      chainId: 5777 
    );
    
    await getName();
  }
}
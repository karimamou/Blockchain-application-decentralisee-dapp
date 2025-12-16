import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hello_world/contract_linking.dart'; 


class HelloUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
 
    var contractLink = Provider.of<ContractLinking>(context);

    TextEditingController yourNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Hello World Dapp"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: contractLink.isLoading
              ? CircularProgressIndicator() // Rond de chargement
              : SingleChildScrollView(
                  child: Form(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Hello ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            Text(
                              contractLink.deployedName, // Le nom venant de la Blockchain
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.teal),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 29),
                          child: TextFormField(
                            controller: yourNameController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Votre Nom",
                                hintText: "Quel est votre nom ?",
                                icon: Icon(Icons.person)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal, // Couleur du bouton
                            ),
                            onPressed: () {
                              // On envoie la transaction à la Blockchain
                              contractLink.setName(yourNameController.text);
                              yourNameController.clear();
                            },
                            child: Text(
                              'Enregistrer le nom',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
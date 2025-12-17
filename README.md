# TP 8 : Blockchain et Application décentralisée DAPP

Ce projet est une mise en pratique du développement d'une DApp (Application Décentralisée) complète. Il connecte une interface utilisateur mobile/web réalisée avec **Flutter** à un Smart Contract **Ethereum** déployé localement.

## 📋 Description

L'application permet d'interagir avec la Blockchain pour :
1.  **Lire** une donnée (un nom) stockée dans le Smart Contract.
2.  **Écrire** une donnée (modifier le nom) via une transaction signée.
3.  Afficher les changements en temps réel.

## 🛠 Technologies utilisées

*   **Smart Contract :** Solidity (`^0.8.19`)
*   **Framework Blockchain :** Truffle
*   **Blockchain Locale :** Ganache (Port 7545, Chain ID 1337)
*   **Frontend :** Flutter & Dart
*   **Protocole :** HTTP (WebSockets désactivés pour compatibilité Web)
*   **Librairies Dart :** `web3dart`, `provider`, `http`

## ⚙️ Prérequis

*   Node.js
*   Truffle (`npm install -g truffle`)
*   Ganache (GUI)
*   Flutter SDK

## 🚀 Installation et Configuration

### 1. Partie Blockchain (Back-end)

1.  Lancez **Ganache** (Quickstart) sur le port `7545`.
2.  Dans le dossier racine, déployez le contrat :
    ```bash
    truffle migrate --reset
    ```
    *(Cela génère le fichier `src/artifacts/HelloWorld.json` indispensable pour Flutter).*

### 2. Partie Application (Front-end)

1.  Installez les paquets Flutter :
    ```bash
    flutter pub get
    ```
2.  **Configuration de la connexion :**
    Ouvrez le fichier `lib/contract_linking.dart` :
    *   **Clé Privée :** Remplacez la variable `_privateKey` par celle du **Compte 0** de votre Ganache (Attention : elle change à chaque redémarrage de Ganache !).
    *   **Adresse IP :** Le projet est configuré par défaut sur `127.0.0.1` (Web/Windows).
    *   **Chain ID :** Configuré sur `1337` pour éviter l'erreur de signature "Invalid v value".

## ▶️ Exécution

### Sur Google Chrome (Recommandé)
Pour contourner les restrictions de sécurité (CORS) lors de la communication avec Ganache, lancez impérativement avec cette commande :

```bash
flutter run -d chrome --web-browser-flag "--disable-web-security"

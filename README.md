# Déploiement automatisé d'une infrastructure cloud avec Terraform sur Azure

## Description du projet

Ce projet a pour objectif de déployer automatiquement une infrastructure cloud complète avec **Terraform** sur **Microsoft Azure**.

L'infrastructure mise en place comprend :

- une **machine virtuelle Ubuntu**
- un **stockage cloud Azure Blob Storage**
- une **base de données MongoDB**
- un **backend Node.js / Express**
- une API simple permettant de manipuler des utilisateurs et des fichiers

Le projet répond au scénario suivant : déployer une application backend sur une VM cloud, stocker des fichiers dans un service de stockage cloud, et automatiser au maximum le déploiement avec Terraform.

---

## Technologies utilisées

- **Terraform**
- **Microsoft Azure**
- **Ubuntu**
- **Node.js**
- **Express**
- **MongoDB**
- **Azure Blob Storage**

---

## Architecture du projet

L'architecture mise en place est la suivante :

- **Terraform** crée les ressources Azure
- **Azure VM Ubuntu** héberge l'application backend
- **MongoDB** stocke les données persistantes
- **Azure Blob Storage** stocke les fichiers envoyés
- **Node.js / Express** expose une API accessible depuis l'extérieur

---

## Structure du projet

```bash
projet-terraform/
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── terraform.tfvars.example
└── README.md
```

---

## ⚠️ Configuration requise avant utilisation

**IMPORTANT** : Avant d'utiliser ce projet, vous devez configurer vos propres valeurs dans le fichier `terraform.tfvars`. 

1. **Copiez le fichier d'exemple** :
```bash
cp terraform.tfvars.example terraform.tfvars
```

2. **Modifiez les valeurs suivantes dans `terraform.tfvars`** :
   - `storage_account_name` : Remplacez par un nom unique (ex: "votrenom12345storage")
   - `admin_password` : Remplacez par votre mot de passe sécurisé
   - `ssh_public_key_path` : Remplacez par le chemin vers votre clé SSH publique

---

## Pré-requis

Avant de commencer, il faut installer :

- **Terraform**
- **Azure CLI**
- **Git**
- **Node.js** (sur le PC si besoin pour tests locaux)
- **MongoDB Compass** (optionnel)
- **PowerShell**

---

## 1. Connexion à Azure

Sur le PC, ouvrir PowerShell et lancer :

```powershell
az login
```

Une fenêtre navigateur s'ouvre.  
Se connecter avec son compte Azure étudiant.

---

## 2. Cloner le projet

```powershell
git clone https://github.com/sirine1711/teraformer.git
cd teraformer
```

---

## 3. Fichiers Terraform à préparer

Le projet contient les fichiers suivants :

- `provider.tf` 
- `main.tf` 
- `variables.tf` 
- `outputs.tf` 
- `terraform.tfvars` ⚠️ **À configurer avec vos valeurs**


---

## 4. Initialiser Terraform

Dans le dossier du projet :

```powershell
terraform init
```

Cette commande initialise Terraform et télécharge le provider Azure.

---

## 5. Vérifier le plan Terraform

```powershell
terraform plan
```

Cette commande affiche les ressources qui seront créées.

---

## 6. Déployer l'infrastructure

```powershell
terraform apply
```

Puis taper :

```text
yes
```

Terraform crée alors :

- le groupe de ressources
- le réseau virtuel
- le sous-réseau
- l'IP publique
- l'interface réseau
- la VM Ubuntu
- le Storage Account
- le container Blob

À la fin, Terraform affiche les outputs, par exemple :

```text
public_ip_address = "IP_PUBLIQUE_DE_LA_VM"
resource_group_name = "rg-terraform-projet"
storage_account_name = "VOTRE_NOM_STORAGE_UNIQUE"
storage_container_name = "fichiers"
```

---

## 7. Ouvrir les ports dans Azure

Après création de la VM, il faut vérifier les règles réseau dans Azure.

### Ports à ouvrir

- **22** → pour SSH
- **3000** → pour accéder au backend Node.js

### Depuis le portail Azure

1. Aller dans **Machines virtuelles**
2. Ouvrir **vm-projet**
3. Cliquer sur **Mise en réseau**
4. Ajouter une **règle de port entrant**

Pour le port **3000** :

- Source : `Tous` 
- Plages de ports source : `*` 
- Destination : `Tous` 
- Plages de ports de destination : `3000` 
- Protocole : `TCP` 
- Action : `Autoriser` 
- Priorité : `300` 
- Nom : `allow-3000` 

---

## 8. Connexion à la VM en SSH

Depuis PowerShell :

```powershell
ssh azureuser@IP_PUBLIQUE_DE_LA_VM
```

Remplacer l'adresse IP par celle affichée dans les outputs Terraform.

---

## 9. Installer Node.js dans la VM

Dans la VM Ubuntu :

```bash
sudo apt update
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v
```

---

## 10. Installer MongoDB dans la VM

Toujours dans la VM :

```bash
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg
echo "deb [ arch=amd64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod
```

Pour quitter l'écran de status :

```bash
q
```

---

## 11. Tester MongoDB

Lancer le shell MongoDB :

```bash
mongosh
```

Créer une base et insérer un utilisateur :

```javascript
use projetcloud
db.users.insertOne({ name: "TestUser", role: "admin" })
db.users.find()
```

⚠️ **Note** : Vous pouvez remplacer "TestUser" par le nom de votre choix.

Pour quitter :

```javascript
.exit
```

---

## 12. Créer l'application backend

Créer le dossier de l'application :

```bash
mkdir ~/app
cd ~/app
npm init -y
npm install express mongodb @azure/storage-blob multer
```

Créer le fichier `server.js` :

```bash
nano server.js
```

Coller ce code :

```javascript
const express = require("express");
const { MongoClient } = require("mongodb");
const { BlobServiceClient } = require("@azure/storage-blob");
const multer = require("multer");

const app = express();
const PORT = 3000;

app.use(express.json());

const mongoUri = "mongodb://127.0.0.1:27017";
const mongoClient = new MongoClient(mongoUri);

// ⚠️ REMPLACER par votre connection string Azure Storage
const storageConnectionString = "VOTRE_CONNECTION_STRING_AZURE";
const containerName = "fichiers";

const blobServiceClient = BlobServiceClient.fromConnectionString(storageConnectionString);
const containerClient = blobServiceClient.getContainerClient(containerName);

const upload = multer({ storage: multer.memoryStorage() });

let db;

async function startServer() {
  await mongoClient.connect();
  db = mongoClient.db("projetcloud");

  console.log("Connected to MongoDB");

  await containerClient.createIfNotExists();
  console.log("Connected to Azure Blob Storage");

  app.get("/", async (req, res) => {
    const users = await db.collection("users").find().toArray();
    res.json(users);
  });

  app.get("/users", async (req, res) => {
    const users = await db.collection("users").find().toArray();
    res.json(users);
  });

  app.post("/users", async (req, res) => {
    const { name, role } = req.body;
    const result = await db.collection("users").insertOne({ name, role });
    res.json({ message: "Utilisateur ajouté", result });
  });

  app.put("/users/:name", async (req, res) => {
    const oldName = req.params.name;
    const { name, role } = req.body;

    const result = await db.collection("users").updateOne(
      { name: oldName },
      { $set: { name, role } }
    );

    res.json({ message: "Utilisateur modifié", result });
  });

  app.delete("/users/:name", async (req, res) => {
    const name = req.params.name;
    const result = await db.collection("users").deleteOne({ name });
    res.json({ message: "Utilisateur supprimé", result });
  });

  app.post("/upload", upload.single("file"), async (req, res) => {
    if (!req.file) {
      return res.status(400).json({ error: "Aucun fichier envoyé" });
    }

    const blobName = req.file.originalname;
    const blockBlobClient = containerClient.getBlockBlobClient(blobName);

    await blockBlobClient.uploadData(req.file.buffer);

    await db.collection("files").insertOne({
      filename: blobName,
      uploadedAt: new Date()
    });

    res.json({ message: "Fichier envoyé dans Azure Blob", filename: blobName });
  });

  app.get("/files", async (req, res) => {
    const files = [];

    for await (const blob of containerClient.listBlobsFlat()) {
      files.push({
        name: blob.name,
        size: blob.properties.contentLength
      });
    }

    res.json(files);
  });

  app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server running on port ${PORT}`);
  });
}

startServer().catch(console.error);
```

⚠️ **IMPORTANT** : Dans le code ci-dessus, remplacez `"VOTRE_CONNECTION_STRING_AZURE"` par la vraie connection string de votre Storage Account Azure.

Enregistrer puis quitter Nano :

- `CTRL + O` 
- Entrée
- `CTRL + X` 

---

## 13. Lancer le backend

Dans la VM :

```bash
cd ~/app
node server.js
```

Le terminal doit afficher :

```text
Connected to MongoDB
Connected to Azure Blob Storage
Server running on port 3000
```

Laisser ce terminal ouvert.

---

## 14. Tester l'application depuis le PC

### Lire les utilisateurs

```powershell
Invoke-RestMethod -Uri "http://IP_PUBLIQUE_DE_LA_VM:3000/users" -Method Get
```

### Ajouter un utilisateur

```powershell
Invoke-RestMethod -Uri "http://IP_PUBLIQUE_DE_LA_VM:3000/users" -Method Post -ContentType "application/json" -Body '{"name":"Alice","role":"user"}'
```

### Modifier un utilisateur

```powershell
Invoke-RestMethod -Uri "http://IP_PUBLIQUE_DE_LA_VM:3000/users/Alice" -Method Put -ContentType "application/json" -Body '{"name":"Alice","role":"admin"}'
```

### Supprimer un utilisateur

```powershell
Invoke-RestMethod -Uri "http://IP_PUBLIQUE_DE_LA_VM:3000/users/Alice" -Method Delete
```

---

## 15. Tester l'upload de fichier

Créer un fichier test :

```powershell
"bonjour azure" | Out-File test.txt
```

Envoyer le fichier :

```powershell
curl.exe -X POST -F "file=@test.txt" http://IP_PUBLIQUE_DE_LA_VM:3000/upload
```

Lister les fichiers stockés :

```powershell
Invoke-RestMethod -Uri "http://IP_PUBLIQUE_DE_LA_VM:3000/files" -Method Get
```

---

## 16. Vérification finale

Le projet est considéré comme fonctionnel si :

- la VM est créée avec Terraform
- l'IP publique fonctionne
- MongoDB fonctionne
- le backend Express fonctionne
- les utilisateurs sont manipulables via CRUD
- les fichiers sont bien envoyés dans Azure Blob Storage

---

## 17. Détruire l'infrastructure

Quand le projet est terminé :

```powershell
terraform destroy
```

Puis taper :

```text
yes
```

Terraform supprime alors toutes les ressources Azure créées.

---

## Problèmes rencontrés et solutions

### Problème 1 : taille de VM non disponible
Certaines tailles de VM ne sont pas disponibles dans toutes les régions Azure.

**Solution :**  
changer la région ou utiliser une autre taille de VM.

### Problème 2 : port 3000 inaccessible
Le backend fonctionnait dans la VM mais pas depuis le navigateur.

**Solution :**  
ouvrir le port **3000** dans **Mise en réseau** avec une règle de port entrant.

### Problème 3 : MongoDB non disponible avec `apt install mongodb` 
Le paquet n'était pas disponible directement.

**Solution :**  
ajouter le dépôt officiel MongoDB puis installer `mongodb-org`.

### Problème 4 : backend inaccessible malgré l'ouverture du port
Le serveur Node.js n'écoutait pas correctement sur l'extérieur.

**Solution :**  
utiliser :

```javascript
app.listen(PORT, "0.0.0.0", ...)
```

---

## Données à personnaliser

⚠️ **Liste des éléments que vous devez adapter à votre environnement** :

1. **Dans `terraform.tfvars`** :
   - `storage_account_name` : Nom unique pour votre Storage Account
   - `admin_password` : Votre mot de passe sécurisé
   - `ssh_public_key_path` : Chemin vers votre clé SSH

2. **Dans le code Node.js** :
   - `storageConnectionString` : Connection string de votre Storage Account Azure
   - Nom de la base de données MongoDB (actuellement "projetcloud")
   - Noms d'utilisateurs de test (actuellement "TestUser")

3. **Dans les commandes de test** :
   - `IP_PUBLIQUE_DE_LA_VM` : Remplacer par l'IP réelle de votre VM

---



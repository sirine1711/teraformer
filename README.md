# Déploiement automatisé d'une infrastructure cloud avec Terraform sur Azure

## Description du projet

Ce projet déploie automatiquement une infrastructure cloud complète avec **Terraform** sur **Microsoft Azure**.

L'infrastructure comprend :
- **Machine virtuelle Ubuntu**
- **Stockage Azure Blob Storage**
- **Base de données MongoDB**
- **Backend Node.js / Express**
- **API REST** pour manipuler des utilisateurs et des fichiers

---

## Technologies utilisées

- **Terraform** - Infrastructure as Code
- **Microsoft Azure** - Cloud provider
- **Ubuntu 22.04** - OS de la VM
- **Node.js / Express** - Backend API
- **MongoDB** - Base de données
- **Azure Blob Storage** - Stockage de fichiers

---

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Terraform     │───▶│   Azure VM      │───▶│  Blob Storage   │
│   (IaC)         │    │   Ubuntu +      │    │   (Fichiers)    │
└─────────────────┘    │   Node.js +     │    └─────────────────┘
                       │   MongoDB       │
                       └─────────────────┘
```

---

## Prérequis

- **Azure CLI** installé et configuré (`az login`)
- **Terraform** >= 1.0
- **Clé SSH** générée (`ssh-keygen -t rsa -b 4096`)
- **Compte Azure** avec permissions appropriées

---

## Configuration rapide

1. **Cloner le repository** :
```bash
git clone git@github.com:sirine1711/teraformer.git
cd teraformer
```

2. **Configurer les variables** :
```bash
cp terraform.tfvars.example terraform.tfvars
# Éditer terraform.tfvars avec vos valeurs
```

3. **Déployer** :
```bash
terraform init
terraform plan
terraform apply
```

---

## Variables à configurer

Dans `terraform.tfvars`, modifiez :

| Variable | Description | Exemple |
|----------|-------------|---------|
| `storage_account_name` | Nom unique du storage account | `"monprojet12345storage"` |
| `admin_password` | Mot de passe VM (12+ caractères) | `"MonMotDePasse123!"` |
| `ssh_public_key_path` | Chemin vers clé SSH publique | `"~/.ssh/id_rsa.pub"` |
| `location` | Région Azure | `"West Europe"` |

---

## Structure du projet

```
teraformer/
├── main.tf                    # Configuration principale
├── provider.tf               # Provider Azure
├── variables.tf              # Variables Terraform
├── outputs.tf                # Sorties (IP, noms...)
├── terraform.tfvars.example  # Template de configuration
├── .gitignore                # Exclusions Git
└── README.md                 # Documentation
```

---

## Après déploiement

### Accès à la VM

Une fois l'infrastructure déployée, connectez-vous à votre VM :

```bash
ssh azureuser@<VOTRE_IP_PUBLIQUE>
```

### Configuration de l'application

L'application Node.js est automatiquement installée et démarrée via le provisioner Terraform.

### Endpoints API disponibles

- `GET /` - Liste des utilisateurs
- `GET /users` - Liste des utilisateurs  
- `POST /users` - Créer un utilisateur
- `PUT /users/:name` - Modifier un utilisateur
- `DELETE /users/:name` - Supprimer un utilisateur
- `POST /upload` - Upload de fichier vers Azure Blob
- `GET /files` - Liste des fichiers stockés

---

## Nettoyage

Pour supprimer toute l'infrastructure :

```bash
terraform destroy
```

---

## Sécurité

⚠️ **Important** :
- Ne jamais committer `terraform.tfvars`
- Utiliser des mots de passe forts
- Configurer les règles de sécurité réseau appropriées
- Supprimer les ressources après utilisation pour éviter les coûts

---

## Support

- [Documentation Terraform Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure CLI Documentation](https://docs.microsoft.com/en-us/cli/azure/)

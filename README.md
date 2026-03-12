# Déploiement automatisé d’une infrastructure cloud avec Terraform sur Azure

## Description du projet

Ce projet a pour objectif de déployer automatiquement une infrastructure cloud complète avec **Terraform** sur **Microsoft Azure**.

L’infrastructure mise en place comprend :

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

L’architecture mise en place est la suivante :

- **Terraform** crée les ressources Azure
- **Azure VM Ubuntu** héberge l’application backend
- **MongoDB** stocke les données persistantes
- **Azure Blob Storage** stocke les fichiers envoyés
- **Node.js / Express** expose une API accessible depuis l’extérieur

---

## Structure du projet

```bash
projet-terraform/
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── terraform.tfstate
└── README.md
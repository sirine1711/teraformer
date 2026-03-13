variable "location" {
  default = "Norway East"
}

variable "resource_group_name" {
  default = "rg-terraform-projet"
}

variable "vm_name" {
  default = "vm-projet"
}

variable "admin_username" {
  default = "azureuser"
}

variable "vm_size" {
  default = "Standard_B2als_v2"
}

variable "storage_account_name" {
  description = "Nom unique du compte de stockage Azure (doit être globalement unique)"
  type        = string
  default     = "YOUR_UNIQUE_STORAGE_NAME"
}

variable "container_name" {
  description = "Nom du conteneur de stockage"
  type        = string
  default     = "fichiers"
}

variable "admin_password" {
  description = "Mot de passe pour l'utilisateur admin de la VM"
  type        = string
  sensitive   = true
  default     = "YOUR_SECURE_PASSWORD"
}

variable "ssh_public_key_path" {
  description = "Chemin vers votre clé publique SSH"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
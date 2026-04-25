variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API endpoint, e.g. https://pve01.example.local:8006/api2/json"
}

variable "proxmox_api_token_id" {
  type        = string
  sensitive   = true
  description = "Token ID, e.g. terraform@pve!iac"
}

variable "proxmox_api_token_secret" {
  type        = string
  sensitive   = true
  description = "Token secret"
}
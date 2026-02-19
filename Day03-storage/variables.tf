variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "storage_account_names" {
  description = "name of the storage accounts"
  type = list(string)
}

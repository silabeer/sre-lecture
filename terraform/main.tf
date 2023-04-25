# export TF_VAR_password = "your password"
terraform {
  required_providers {
    vkcs = {
      source = "vk-cs/vkcs"
      version = "~> 0.1.12"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}
provider "vkcs" {
    username = var.username
    password = var.password
    project_id = var.project_id
    region = "RegionOne"
    auth_url = "https://infra.mail.ru:35357/v3/"
}

data "vkcs_images_image" "compute" {
  name = "CentOS-7.9-202107"
}

variable "username" {
  type = string
  sensitive = true
}

variable "password" {
  type = string
  sensitive = true
}

variable "project_id" {
  type = string
  sensitive = true
}
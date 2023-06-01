# General variables
variable "env" {
    type    = string
    default = "development"
}

variable "google_credentials_file" {
    type    = string
}

variable "google_project_name" {
    type    = string
}

variable "google_region" {
    type    = string
}

variable "prefix" {
    type    = string
    default = "vida"
}

# Cloud run instance variables
variable "function_name" {
    type    = string
    default = "tipg-vector-tiler"
}

variable "docker_image" {
    type    = string
}

variable "vpc-access-connector" {
    type    = string
}

variable "cloudsql-instance" {
    type    = string
}

variable "env" {}
variable "prefix" {}
variable "function_name" {}
variable "location" {}
variable "docker_image" {}

variable "envs" {
  type    = map(string)
  default = {}
}
variable "secret_envs" {
  type = map(object({
    name = string
    key  = string
  }))
  default = {}
}
variable "container_concurrency" {
  default = "80"
}
variable "timeout_seconds" {
  default = "300"
}
variable "port" {
  default = "8080"
}
variable "cpu" {
  default = "1000m"
}
variable "memory" {
  default = "512Mi"
}
variable "execution_environment" {
  default = "gen2"
}
variable "startup_cpu_boost" {
  default = "true"
}
variable "min_scale" {
  default = "0"
}
variable "max_scale" {
  default = "70"
}

variable "region" {
  default = "europe-west3"
}

variable "neg_name" {
  default = ""
}

variable "extra_annotations" {
  type    = map(string)
  default = {}
}

variable "extra_template_annotations" {
  type    = map(string)
  default = {}
}

locals {
  annotations = merge(
    var.extra_annotations,
    {
      "run.googleapis.com/launch-stage" = "BETA"
    },
  )
}

locals {
  template_annotations = merge(
    var.extra_template_annotations,
    {
      "run.googleapis.com/execution-environment" = var.execution_environment,
      "run.googleapis.com/startup-cpu-boost"     = var.startup_cpu_boost,
      "autoscaling.knative.dev/minScale"         = var.min_scale,
      "autoscaling.knative.dev/maxScale"         = var.max_scale
    },
  )
}

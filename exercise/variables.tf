variable "region" {
  type = string
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "name" {
  type    = string
  default = "exercise"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-west-1a", "us-west-1b"]
}

variable "servers" {
  type    = list(string)
  default = ["webserver-00", "webserver-01"]
}

variable "targets" {
  type = map
  default = {
    http = {
      port     = 80
      protocol = "HTTP"
    }
  }
}

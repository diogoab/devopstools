variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-east-1"
}
variable "security_groups" {type="list"}

provider "aws" {
    acess_key   = "${var.access_key}"
    secret_key  = "${var.secret_key}"
    region      = "${var.region}"
    version     = "~> 1.46"
} 

resource "aws_instance" "proxy_reverso" {
    ami             = ""
    instance_type   = "t2.micro"
    security_groups = ["${var.security_groups}"]
    key_name        = "proxy"
}


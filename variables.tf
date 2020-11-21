variable "hcloud_token" {
type=string
}
variable "asduk_key" {
type=string
}

variable "aws_access_key" {
type=string
}

variable "aws_secret_key" {
type=string
}

variable "connection" {
  default = {
    user        = "root"
    type        = "ssh"
    private_key = "./.ssh/id_rsa"
  }
}


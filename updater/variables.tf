variable "db_passwords" {
  type = map(string)
}

variable "db_users" {
  type = map(string)
}

variable "db_name" {
  type = string
}

variable "db_endpoint" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "db_sg" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "slug" {
  type = string
}

variable "port" {
  type = number
}

variable "package_path" {
  type = string
}

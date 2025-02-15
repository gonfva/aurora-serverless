variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  validation {
    condition     = var.cluster_name != ""
    error_message = "The cluster name cannot be empty"
  }
}

variable "tags" {
  description = "A list of tags that can be used to allocate costs"
  type        = map(string)
}

variable "environment_type" {
  description = "A string with either dev or prod that will help define a bunch of attributes"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment_type)
    error_message = "The type of environment needs to be either dev or prod"
  }
}

variable "engine_type" {
  description = "A string with either mysql for MySQL or pg for Postgresql. It will define the engine flavour"
  type        = string

  validation {
    condition     = contains(["mysql", "pg"], var.engine_type)
    error_message = "The engine type needs to be either mysql or pg"
  }

  validation {
    condition     = contains(["pg"], var.engine_type)
    error_message = "We don't support MySQL yet"
  }
}

variable "vpc_id" {
  description = "The ID of the VPC where we will deploy the cluster"

  validation {
    condition     = length(var.vpc_id) > 4 && substr(var.vpc_id, 0, 4) == "vpc-"
    error_message = "The vpc id is not in a correct format"
  }
}

variable "subnet_ids" {
  description = "A list of subnets to deploy the cluster to"
  type        = list(string)

  validation {
    condition     = alltrue([for s in var.subnet_ids : (length(s) > 7 && substr(s, 0, 7) == "subnet-")])
    error_message = "The subnets are not in a correct format"
  }

  validation {
    condition     = length(var.subnet_ids) >= (var.environment_type == "prod" ? 2 : 1)
    error_message = "This application requires at least ${var.environment_type == "prod" ? 2 : 1} private subnets"
  }

}

variable "db_name" {
  type        = string
  description = "The database name"
  validation {
    condition     = length(var.db_name) > 0
    error_message = "The database name cannot be empty"
  }
}


variable "db_users" {
  type        = map(string)
  description = "A map with the name of three users that will be created in the database (admin, ro, rw). RW does not have DDL permissions"

  validation {
    condition     = alltrue([for k, v in var.db_users : contains(["admin", "ro", "rw"], k) && !strcontains(v, " ")])
    error_message = "The names cannot contains spaces"
  }
}

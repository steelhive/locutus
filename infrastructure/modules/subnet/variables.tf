variable "name"         {}
variable "vpc_id"       {}
variable "cidrs"        { type = "list" }
variable "azs"          { type = "list" }
variable "is_public"    {}

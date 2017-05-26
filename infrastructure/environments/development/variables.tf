variable "cidr"                 {}
variable "region"               {}
variable "environment"          {}
variable "system_name"          {}
variable "apex_domain"          {}
variable "state_bucket"         {}
variable "certificate_domain"   {}
variable "azs"                  { type = "list" }
variable "amis"                 { type = "map" }
variable "public_subnets"       { type = "list" }
variable "private_subnets"      { type = "list" }
variable "master_cluster"       { type = "map" }
variable "minion_cluster"       { type = "map" }

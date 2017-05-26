variable "name"                 {}
variable "region"               {}
variable "tag_key"              {}
variable "min_size"             {}
variable "max_size"             {}
variable "elb_name"             {}
variable "tag_value"            {}
variable "ssh_key_name"         {}
variable "desired_size"         {}
variable "instance_type"        {}
variable "user_data_file"       {}
variable "security_group_id"    {}
variable "azs"                  { type = "list" }
variable "amis"                 { type = "map" }

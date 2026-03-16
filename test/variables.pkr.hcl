variable "repo_url" {
  type        = string
  default     = ""
  description = "Optional custom repo URL for kickstart"
}

variable "vm_memory" {
  type    = number
  default = 2048
}

variable "vm_cpus" {
  type    = number
  default = 2
}

variable "disk_size" {
  type    = number
  default = 20000
}

variable "project_name" {
  type = string
}

variable "function_name" {
    type = string
    description = "output of lambda module"
}

variable "invoke_arn" {
  type = string
  description = "invoke arn of lambda function"
}
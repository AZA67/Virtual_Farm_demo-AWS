variable "project_name" {
    type = string 
}

variable "table_name" {
    type = string
    description = "dynamodb table outputed from dynamodb module"
}

variable "lambda_dir" {
    type = string
    description = "directory containing lambda handler function"
}
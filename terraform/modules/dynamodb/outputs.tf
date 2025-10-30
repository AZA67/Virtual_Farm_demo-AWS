output "table_name" {
    value = aws_dynamodb_table.table_name.name
    description = "dynamodb table name for lambda env variable"
}
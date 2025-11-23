#!/usr/bin/env bash

set -euo pipefail

#---user variables------------------------------------#
read -p "Enter a project name: " project_name
read -p "Enter your Domain Name (TLD): " domain_name
read -p "Enter an AWS region (ie; us-east-1): " region

bucket="${project_name}-tf-state"
table="${project_name}-tf_state_lock"

#--------setup backend--------#

pushd ./bootstrap/ > /dev/null

echo "adding variable defaults"

sed -i '2r /dev/stdin' variables.tf <<EOF
  default = "${project_name}"
EOF
sed -i '7r /dev/stdin' variables.tf <<EOF
  default = "${region}"
EOF
sed -i '13r /dev/stdin' variables.tf <<EOF
  default = "${domain_name}"
EOF

echo "Initializing backend"

terraform init 
terraform apply --auto-approve

echo "adding remote backend block to 'backend.tf'"

sed -i '1r /dev/stdin' backend.tf <<EOF
    backend "s3" {
      bucket = "${bucket}"
      key = "backend/terraform.tfstate"
      region = "${region}"
      dynamodb_table = "${table}"
      encrypt = true
    }
EOF

echo "re-initializing for remote backend"

terraform init --force-copy #auto-yes for migrate state prompt

##--NEED to add domain nameservers to registrar where you purchased domain--##
cat nameservers.txt
echo "please add nameservers to your domain registrar before continuing"
echo "/n press ENTER to continue..."
read

popd > /dev/null


#------pre-configure root module-----#

echo "CONFIGURING VARIBALES FOR ROOT MODULE"

#configure variables
sed -i '3r /dev/stdin' variables.tf <<EOF
  default = "${region}"
EOF

sed -i '9r /dev/stdin' variables.tf <<EOF
  default = "${project_name}"
EOF

sed -i '14r /dev/stdin' variables.tf <<EOF
  default = "${domain_name}"
EOF

#add remote backend
sed -i '1r /dev/stdin' main.tf <<EOF
    backend "s3" {
      bucket = "${bucket}"
      key = "prod/terraform.tfstate"
      region = "${region}"
      dynamodb_table = "${table}"
      encrypt = true
    }
EOF

#initialize root
echo "initializing root dir"

terraform init 
terraform apply --auto-approve


init:
    terraform -chdir=terraform init

apply *ARGS:
    terraform -chdir=terraform apply {{ARGS}}

plan *ARGS:
    terraform -chdir=terraform plan {{ARGS}}

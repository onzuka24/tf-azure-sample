# tf-azure-sample

terraform azure sample

## Create resouces

### create account for backend

```bash
cd storage_account
./create_storage_acount.sh
source get_info.sh
```

### make configuration files

- make `config.tfbackend` from `config.tfbackend.sample`
  - `storage_account_name` is the storage account name created in former step
- make `dev.tfvars` (or `prod.tfvars`) from `tfvars.sample`

### deploy

initialize terraform

```bash
terraform init -backend-config=config.tfbackend
```

deploy

```bash
terraform apply -var-file=<stage>.tfvars
```

## Destroy

### delete storage account

delete resource group for storage account

```bash
# cd strage_account && ./delete_sresource_group.sh
az group delete --name <resource group name>
```

## regions

| Region name | AZ CLI name | Short notation |
| ----------- | ----------- | -------------- |
| Asia | asia | asia |
| Japan | japan | jap |
| Japan East | japaneast | jpe |
| Japan West | japanwest | jpw |
| United States | unitedstates | us |
| East US | eastus | use |
| West US | westus | usw |

# Vault Installation and Setup  
---

## Introduction  

HashiCorp Vault is a powerful tool for managing secrets, encryption, and access control in a secure and centralized way. This guide covers how to install Vault, set it up, access its GUI, and configure it for production-level use.  

---

## Prerequisites  

Before installing Vault, ensure the following:  
- An operating system supported by Vault (Linux, macOS, or Windows).  
- Administrative privileges on your machine.  
- `curl` and `wget` installed (optional for downloading).  

---

## Install Vault  

### Download Vault 

Visit the [Vault downloads page](https://www.vaultproject.io/downloads).  

### Verify Vault Installation 

```bash
vault --version  
```

### Setup Vault for Dev Environment

Development Mode

Start Vault in development mode:

```bash
export VAULT_ADDR = 'http://0.0.0.0:8200'
```

Start Vault 
```bash
vault server -dev -dev-listen-address="0.0.0.0:8200"
```
The server will provide a root token and an unsealed state. Note down the root token for authentication.

Access the GUI via your VM IP:8200 on your browser. Use Token based authentication and use "Root Token" as authnetication which generated when we above command. 

## Configure Terraform to read the secret from Vault.

Detailed steps to enable and configure AppRole authentication in HashiCorp Vault:

1. **Enable AppRole Authentication**:

To enable the AppRole authentication method in Vault, you need to use the Vault CLI or the Vault HTTP API.

**Using Vault CLI**:

Run the following command to enable the AppRole authentication method:

```bash
vault auth enable approle
```

This command tells Vault to enable the AppRole authentication method.

2. **Create an AppRole**:

We need to create policy first,

```
vault policy write terraform - <<EOF
path "*" {
  capabilities = ["list", "read"]
}

path "secrets/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}


path "secret/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "auth/token/create" {
capabilities = ["create", "read", "update", "list"]
}
EOF
```

Now you'll need to create an AppRole with appropriate policies and configure its authentication settings. Here are the steps to create an AppRole:

**a. Create the AppRole**:

```bash
vault write auth/approle/role/terraform \
    secret_id_ttl=10m \
    token_num_uses=10 \
    token_ttl=20m \
    token_max_ttl=30m \
    secret_id_num_uses=40 \
    token_policies=terraform
```

3. **Generate Role ID and Secret ID**:

After creating the AppRole, you need to generate a Role ID and Secret ID pair. The Role ID is a static identifier, while the Secret ID is a dynamic credential.

**a. Generate Role ID**:

You can retrieve the Role ID using the Vault CLI:

```bash
vault read auth/approle/role/my-approle/role-id
```

Save the Role ID for use in your Terraform configuration.

**b. Generate Secret ID**:

To generate a Secret ID, you can use the following command:

```bash
vault write -f auth/approle/role/my-approle/secret-id
   ```

This command generates a Secret ID and provides it in the response. Save the Secret ID securely, as it will be used for Terraform authentication.






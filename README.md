# MongoDB Deployment with Terraform

This project contains Terraform configurations for deploying a MongoDB cluster to MongoDB Atlas, the fully managed MongoDB database service.

> [!NOTE]
> This documentation is intentionally detailed to serve as a comprehensive guide for team members new to Terraform and infrastructure as code. Each section includes explanations and examples to help understand the deployment process.

## Prerequisites

This project uses [asdf](https://asdf-vm.com/) for managing tool versions. Required runtime dependencies and their versions are specified in `.tool-versions`.

`mongosh` and `mongodb-atlas-cli` are also required but currently not supported by asdf. Please follow their documentation for installation instructions.

### Installation

1. Install asdf:
   ```bash
   # On macOS
   brew install asdf

   # On Linux
   git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
   ```

2. Add required plugins:
   ```bash
   asdf plugin add terraform
   asdf plugin add dotenvx
   asdf plugin add jq
   asdf plugin add tflint
   ```

3. Install all tools:
   ```bash
   asdf install
   ```

4. Verify installation:
   ```bash
   asdf current
   ```

## Environment Variables

This project uses `dotenvx` for secure environment variable management. Variables are encrypted using public/private key encryption.

### Required Environment Variables

The following variables are required:

```plaintext
TF_VAR_project_id=your-project-id
TF_VAR_atlas_org_id=your-atlas-org-id
TF_VAR_atlas_public_key=your-atlas-public-key
TF_VAR_atlas_private_key=your-atlas-private-key
```

### Environment Variable Security

1. **Encryption**: 
   - Environment variables are encrypted using `dotenvx`
   - Public key is stored in `DOTENV_PUBLIC_KEY_DEVELOPMENT`
   - Private key is stored in `env.keys` and should never be commited to version control

2. **Usage with dotenvx**:
   ```bash
   # Load encrypted environment variables
   dotenvx run -f .env.development -- terraform plan
   ```


### Shell Expansion and Environment Variables

When running commands that use environment variables, we need to prevent the shell from expanding variables before dotenvx can inject them. This is done using subshell syntax ($$) in the Makefile or single quotes in direct shell commands.

```bash
# Wrong ❌ - Shell expands variables before dotenvx
dotenvx run -f .env.development -- bash -c "terraform plan $TF_VAR_project_id"

# Correct ✅ - Using single quotes
dotenvx run -f .env.development -- bash -c 'terraform plan $TF_VAR_project_id'

# Also correct ✅ - Using escaped variables
dotenvx run -f .env.development -- bash -c "terraform plan \$TF_VAR_project_id"
```

For more information about shell expansion with dotenvx, see the [official documentation](https://dotenvx.com/docs/advanced/run-shell-expansion#subshell).

## Deployment Commands

> [!CAUTION]
> Always import existing infrastructure state before making changes to avoid accidental resource destruction. **Remember: Skipping imports = Destroying existing infrastructure.**

```bash
# Initialize Terraform and select workspace
terraform init
terraform workspace select development

# Import existing state (REQUIRED for existing resources)
terraform import [RESOURCE_TYPE].[NAME] [RESOURCE_ID]

# Plan changes
terraform plan

# Apply changes
terraform apply

# Remove specific resource
terraform state rm [RESOURCE_TYPE].[NAME]

# Destroy infrastructure (use with caution)
terraform destroy
```

## Considerations

- This deployment uses the `mongodbatlas_serverless_instance` resource, which creates a serverless MongoDB cluster. This is the most cost-effective option for small workloads.
- If you require more frequent backups or need to scale the cluster, consider using the `mongodbatlas_cluster` resource and selecting a higher tier plan (e.g., M10 or above).
- Make sure to set up payment information in your MongoDB Atlas account, otherwise, you may encounter the `NO_PAYMENT_INFORMATION_FOUND` error.

## Migrating from an Existing MongoDB Database

To migrate an existing MongoDB database to the MongoDB Atlas cluster created with Terraform, follow these steps:

1. Dump the existing database:
   ```bash
   mongodump --uri="mongodb://your-existing-mongodb-uri" --out=/path/to/backup
   ```
2. Restore the data to the new MongoDB Atlas cluster:
   ```bash
   mongorestore --uri="mongodb+srv://username:password@your-atlas-cluster.mongodb.net" /path/to/backup
   ```

Make sure you have the necessary MongoDB tools (`mongodump` and `mongorestore`) installed, and that your Atlas cluster is accessible from your current network.
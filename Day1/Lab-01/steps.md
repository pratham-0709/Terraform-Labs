## STEPS 

Create a directory for your Terraform project and create a Terraform configuration file (usually named main.tf) in that directory. In this file, you define the AWS provider and resources you want to create. Here's a basic example:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "test-lab" {
  ami           = "ami-023a307f3d27ea427"
  instance_type = "t2.micro"
  subnet_id     = "subnet-1234"
  key_name      = "keypair"
}
```

# Initialize Terraform And Test Resources

In your terminal, navigate to the directory containing your Terraform configuration files and run:

```hcl
terraform init
```

Run the following command to rechec what resources are going to be created : 

```hcl
terraform plan
```

Run the following command to create the AWS resources defined in your Terraform configuration:

```hcl
terraform apply
```

Terraform will display a plan of the changes it's going to make. Review the plan and type "yes" when prompted to apply it.

After Terraform completes the provisioning process, you can verify the resources created in the AWS Management Console or by using AWS CLI commands.

If you want to remove the resources created by Terraform, you can use the following command:

```hcl
terraform destroy
```

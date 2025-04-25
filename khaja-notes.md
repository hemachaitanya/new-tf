
```
Setting up VS Code for terraform
We need to install an extension for Terraform from hashicorp
Preview
Creating the required infra with Terraform
Activity 1: I want to create a vpc with 4 subnets in AWS
AWS Credentials
Ensure you have aws cli installed and configured (view classroom recording to create one)
Data types in Terraform
official docs
string: this will be in quotes
number
bool
list
set
map or object
Hashicorp Configuration Language (HCL)
Refer Here for official docs
Terraform AWS Provider
official docs
Terraform block to choose the provider and version
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.82.2"
        }
    }

}

Lets try to configure the provider
provider "<name>" {
    arg1 = value1
    ...
    ..
    argn = valuen

}
AWS Provider Argument reference
As of now our main.tf looks as shown below
terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "5.82.2"
      }
    }
}

provider "aws" {
    region = "ap-south-1"
}
Now from terminal
download providers and initialize terraform init
Preview
Format the template terraform fmt
Validate the template terraform validate
Resource block in terraform
resource "type" "identifier" {
    arg1 = value1
    ...
    ..
    argn = valuen
}
Now to find resources,
Search in provider docs
google terraform <cloud> <resource>
vpc resource docs
Add the vpc resource block so as of now the template is
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}


resource "aws_vpc" "network" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "from tf"
  }

}
Now to create infrastructure, execute terraform apply where the plan will be shown
Preview
To be continued…

Share this

Terraform
Variables
Variables are the inputs that can be passed
official docs
basic syntax for creating a variable
variable "<name>" {
    type = <datatypes of terrarform>
    default = ""
    description = "purpose of variable"
}
To use the variable use syntax var.<name>
Using variables in activity 1
Refer Here for the changes
Variable values can be passed during apply
terraform apply -var "<name>=<value>"
terraform apply -var vpc_cidr=10.0.0.0/16
Variables values can be stored in a file with extension .tfvars and passed during apply. Refer Here for docs
terraform apply -var-file='default.tfvars'
Outputs
Terraform template outputs show the output after every apply Refer Here for official docs
Sample output
Preview
Adding a sample output to activity 1
Refer Here for changes.
outputs.tf file contains outputs
How to create multiple resources in terraform
count
Refer Here for changes to include count
Terraform functions
Refer Here for official docs of terraform
Refer Here for changes.
Refer Here for the changes done
Activity 2: Create a Network in Azure
Overview
Preview
Manual steps: (Watch classroom recording)
Terraform azure providers
azurerm (Hashicorp) this is most widely used
azapi (Microsoft) few customers use this as well
Refer Here for changes done to create the network as mentioned in the above image

Share this:

Terraform
Terraform state file
On every apply (success) a state file representing resources created is maintained by default in the terraform.tfstate file
Preview

Accessing attributes
syntax for resource attributes
<type>.<id/name>.<attribute>
To play with this we can use terraform console
Preview
If you use attribute of resource A in resource B, the creation order will be first A then B this is referred as implcit dependency
Resource creation order can be controlled implicitly or even explicitly by using depends_on
Activity 1: I want to create a vpc with 4 subnets in AWS (contd)
Lets try adding 4 subnets
Lets start with one subnet
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}


resource "aws_vpc" "network" {
  cidr_block = "10.100.0.0/16"
  tags = {
    Name = "from tf"
  }

}

resource "aws_subnet" "web1" {
  vpc_id            = aws_vpc.network.id
  availability_zone = "ap-south-1a"
  cidr_block        = "10.100.0.0/24"
  tags = {
    Name = "web-1"
  }
  depends_on        = [aws_vpc.network]

}
Lets add three other subnets
web-2:
cidr: 10.100.1.0/24
az: ap-south-1b
db-1:
cidr: 10.100.2.0/24
az: ap-south-1a
db-2:
cidr: 10.100.3.0/24
az: ap-south-1b
Refer Here for the changes
Lets understand the work we have done,
This template creates a vpc with 4 subnets in mumbai region with fixed ip ranges
Terraform style guide
Refer Here for hashicorp style guide
TFLint
This is a linter for terraform which cross checks your terraform templates for
best practices
stylers
For aws related templates add a specific plugin for aws checks Refer Here
Refer Here for aws specific configuration for tflint
Versioning constraints
Refer Here for docs
Refer Here for changes with version constraints
Using terraform recommended file structure
Refer Here for specific rule
Refer Here for the changes done to re arrange work across files in terraform.

Share this:

Terraform
locals
Refer Here for terraform locals
locals represent values for usage within a template
Others
Conditional Expressions
Activity 3: Complete AWS Network
Create a vpc with public and private subnets
Preview
For manual steps watch classroom recording
Steps:
Create vpc
Create an internet gateway
Create a private route table
create a public route table
add route in public route table to internet gateway
Create subnets for public and associate with public route table
Create subnets for private and associate with private route table

Refer Here for the changes done
Lets enable options to create security group Refer Here for the changes done
Terraform security scanning
tfsec

Share this:
Like this:
Published January 5, 2025
Categorized as Uncategorized
Tagged DevOps
 By continuous learner
devops & cloud enthusiastic learner

View all of continuous learner's posts.
Leave a Replay
```

### new-tf

## how you get the statefle for already existing  infratecture

* terraform import resourcetype.resourcename resource-id

### terraform variables will be passed 5 types 

  1. default name=hema0
  2. terraform apply -var name=hema1
  3. auto.tfvar name=hema2
  4.  export name=hema3
  5.  environment name=4


 ### Command-line flag (-var):

     * terraform apply -var "name=hema1"

      This has the highest precedence and will override all other methods

 ### TF_VAR environment variables:

    * Variables set using the TF_VAR_ prefix in the environment variables.

    * export TF_VAR_name=hema3

    * This takes precedence over terraform.tfvars and default value

 ### Terraform variables file (.auto.tfvars):

    * Variables defined in a .auto.tfvars file.

    * Example (variables.auto.tfvars):
            
            name = "hema2"
            
   Automatically loaded and overrides terraform.tfvars and default values.

 ### Variable Definition Files (.tfvars):

   * terraform apply -var-file="variables.tfvars"

    * # In variables.tfvars
       name = "hema4"

### Terraform Cloud/Enterprise Variables

   * Define name = "hema6" in the Terraform Cloud workspace.

### Environment Variable Interpolation:

   * output "name" {
  value = var.name != "" ? var.name : getenv("NAME_VAR")
   }


### Default values in configuration:

   * variable "name" {
         default = "hema0"
      }

  * The lowest precedence and only used if no other values are set.

 
 Command-line flag (-var): hema1
 
TF_VAR environment variables: hema3

.auto.tfvars file: hema2

Variable Definition Files (.tfvars): hema4

Terraform Cloud/Enterprise Variables: hema6

Environment Variable Interpolation: hema5

Default values in configuration: hema0

This order demonstrates the precedence in which Terraform variables are evaluated

Nomad cluster
=================

Packer and Terraform to build a Nomad cluster with very little effort.

You will need to configure some ENV variables OR edit the `packer/variables.tf` file.

To build with [Packer](https://www.packer.io/):

```
cd packer
packer build build.json
```

To deploy cluster with [Terraform](https://www.terraform.io/):

```
cd terraform
terraform apply
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.26.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.26.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_subnet.subnets](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pjt_name"></a> [pjt\_name](#input\_pjt\_name) | n/a | `string` | `"demo_module"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"ap-northeast-2"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | n/a | `map` | <pre>{<br>  "pri_subnets": {<br>    "10.1.3.0/24": "ap-northeast-2a",<br>    "10.1.4.0/24": "ap-northeast-2c"<br>  },<br>  "pub_subnets": {<br>    "10.1.1.0/24": "ap-northeast-2a",<br>    "10.1.2.0/24": "ap-northeast-2c"<br>  }<br>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subents"></a> [subents](#output\_subents) | n/a |
<!-- END_TF_DOCS -->
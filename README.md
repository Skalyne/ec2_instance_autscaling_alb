# WebServer with auto scaling and load balancer
In this project, a webserver is deployed with auto-scaling and is reachable by a load balancer. The code is split into separate files for ease of reading

*main:* variables and providers
*vpc:* vpc configuration
*nat:* vpc-gw configuration for private subnets
*autoscaling:* autoscaling policies and launch configuration
*elb:* load balancer configuration
*terraform.tfvars:* credentials for aws and default vars

## requirements
- terraform
- aws public key (from region you selected)

## how to get public key
Sign in to the AWS Management Console and open the AWS Key Management Service (AWS KMS) console at https://console.aws.amazon.com/kms.

- To change the AWS Region, use the Region selector in the upper-right corner of the page.

- In the navigation panel, choose Customer managed keys.

- Choose the alias or key ID of an asymmetric KMS key.

- Choose the Cryptographic configuration tab. Record the values of the Key spec, Key usage, and Encryption algorithms or Signing Algorithms fields. You'll need to use these values to use the public key outside of AWS KMS. Be sure to share this information when you share the public key.

- Choose the Public key tab.

- To copy the public key to your clipboard, choose Copy. To download the public key to a file, choose Download.

## instructions
download the repository

Conplete the terraform.tfvars
```
AWS_ACCESS_KEY_ID="<YOUR_ACCESS_KEY>"
AWS_SECRET_ACCESS_KEY="<YOUR_SECRET_ACCESS_KEY>"
AWS_DEFAULT_REGION="eu-west-3"
PUBLIC_KEY="<YOUR_PUBLIC_KEY>"
```

note: if you use some region different than eu-west-3 make sure you also change the availability_zone field on aws_subnet resources in vpc.tf
type next commands
1. _terraform init_
2. _terraform plan_
3. _terraform apply_
and type yes if everithing runs ok

Once script is finished, you will get an output with the dns servername to acces to webserver


## TODO:
autoscaling and descaling has been tested without load balancer conneting to the ec2 and make in stress tests, as instance needs to be reachable just by load balancer, port 22 was closed and I´m not able to test in the same way, userdata script seems to have different behave so couldn´t test it, but code works.

problems with terraform destroy in some resources, not found any parameters as force_destroy or similar in documentation, so consider to delete autoscaling group, internet gateway and vpc by hand (still working on it).

as this is a simple proyect consider that you could have some resources already in use as key-pair name or cidr_blocks, feel free to change it.
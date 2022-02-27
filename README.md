# WebServer with auto scaling and load balancer
In this project, a webserver is deployed with auto-scaling and is reachable by a load balancer. The code is split into separate files for ease of reading.
A s3 bucket should be accesible, for that we create an IAM role and we atach it to the ec2 launch configuration.

- *main:* variables and providers
- *vpc:* vpc configuration
- *nat:* vpc-gw configuration for private subnets
- *autoscaling:* autoscaling policies and launch configuration
- *elb:* load balancer configuration
- *terraform.tfvars:* credentials for aws and default vars
- *iam:* creation of IAm and policies
- *s3bucket:* creation of s3 bucket 

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

Complete the terraform.tfvars
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
Sometimes terraform destroy get stucks deataching gw, That is because is taking long lo destroy other resources, launch it again a few minutes before 

As this is a simple proyect consider that you could have some resources already in use as key-pair name or cidr_blocks, feel free to change it.
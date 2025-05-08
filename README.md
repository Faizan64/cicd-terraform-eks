### Step-by-step guide to deploy an EKS cluster on AWS using Jenkins and Terraform:

## Pre-requisites
1. Terraform installed
2. Aws account
3. Aws Configured
4. Jenkins

The Project can be divided into simple 5 steps:
Step 1: Set Up Jenkins on ec2 using terraform
Step 2: Write tf code for eks cluster
Step 3: Push the code on github
Step 4: Create a Jenkins pipeline which is going to deploy an eks cluster on aws
Step 5: Deploy the changes to AWS
Step 6: Implement a deplopyement file and acces the application

Note: First in order to start writing the code check whether you have configured aws then proceed to write the code

## Setup Jenkins on aws using terraform
First create an empty dir in github and clone it on your local machine

Use vscode and create all the required tf files(main.tf, providers.tf, data.tf, backend.tf, variables.tf, terraform.tfvars) and jenkins installaiton script as given in my above code

In providers use aws as providers and the region you want to use take a s3 bucket for the backend

Use terraform modules for the remaing files to create a ec2 instace and required specifications

First install terraform in your local machine and then intialize by terraform init cmd and then validata and plan it will show all the resources that are about to created like ec2,vpc and finally terraform apply your resources are being setup on aws through terraform

Now create a file jenkins-install.sh contains all the commands that install jenkins, terraform,git and kubectl in your ec2 instance

Acces your jenkins server by public id of your ec2 instance and port 8080 and isntall the all required plugins.

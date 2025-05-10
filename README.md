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
Step 4: Create a Jenkins pipeline which is going to deploy an eks cluster on AWS
Step 5: Deploy the changes to AWS
Step 6: Implement a deployment file and access the application

Note: First in order to start writing the code check whether you have configured aws then proceed to write the code

## Setup Jenkins on AWS using terraform
First create an empty dir in GitHub and clone it on your local machine

Use vscode and create all the required terraform files(main.tf, providers.tf, data.tf, backend.tf, variables.tf, terraform.tfvars) and Jenkins installation script as given in my above code

In providers use AWS as providers and the region you want to use take a s3 bucket for the backend

Use terraform modules for the remaining files to create a ec2 instance and required specifications

First install terraform in your local machine and then initialize by terraform INIT cmd and then validate and plan it will show all the resources that are about to created like ec2,vpc and finally terraform apply your resources are being setup on AWS through terraform

Now create a file jenkins-install.sh contains all the commands that install Jenkins, terraform, git and Kubectl in your ec2 instance

Access your Jenkins server by public id of your ec2 instance and port 8080 and install the all required plugins.

## Write terraform code for EKS cluster
Include the all required terraform files like main.tf, data.tf, variables.tf, terraform.tfvars, providers.tf, backend.tf and apply the changes. All the code for this files are available in the repo

And finaly push your code on GitHub

## Create a pipeline on Jenkins
Create a Jenkins pipeline add all the AWS credentials add the Jenkins script that is written in groovy and you can find that in my repo as Jenkins file 

You can view all the required steps required to create a eks cluster and deploy it on Nginx.

# Packer-with-CI-PoC
This project has been created for a simple nodejs application, in which we try to demonstrate how packer builds images for the subsequent deployment of an EC2 instance on AWS, so we use to support packer another hashicorp tool such as terraform. In this way the whole process of creating a machine with a deployed application is automated every time a merge is made to main with the changes of the application. We have tried to explain this workflow with the following image: 

![Infrastructure](./docs/packer%2Bterraform%2Bci.png)

As can be seen in the image, from Github actions with the support of a [script](scripts/packer-terraform.sh) that is responsible for initializing and running the changes of both packer and terraform, a CI process is performed creating the necessary resources for the deployment of an application, as explained below: 

1. An AWS S3 bucket is created to store information needed for EC2 deployment.

2. An AWS AMI is created with packer which installs inside it the necessary packages for a nodejs application to be deployed when an EC2 installation is created later. In addition, once the packer image has been created, it creates a json file, a manifest, which stores information such as the AMI ID, which will be used later by terraform to deploy the EC2 with that AMI.

3. Through the script mentioned above, it extracts the manifest from S3, gets the AMI ID, and writes it to a variable in terraform to be used in the deployment. 

4. Finally, the EC2 is instantiated with the previously created AMI and the loaded application is run. 
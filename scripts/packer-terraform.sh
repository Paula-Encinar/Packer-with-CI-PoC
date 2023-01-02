#!/usr/bin/env bash
#Author:Paula Encinar
set -eo pipefail

#Vars
terranetworkpath="../terraform-bucket"
packerhclpath="../packer"
terradeploypath="../terraform-deploy"
packerhclfilename="aws-ubuntu.pkr.hcl"

case "$1" in
  all)

      echo "terraform init => packer network infrastructure"
      cd $terranetworkpath && terraform init      
      echo ""

      echo "terraform apply => packer network infrastructure"
      cd $terranetworkpath && terraform apply --auto-approve
      echo ""

      echo "Validate packer.pkr.hcl"
      cd $packerhclpath && packer validate $packerhclfilename

      if [ $? -eq 0 ]; then
        cd $packerhclpath && packer build $packerhclfilename
        echo ""
      else
        echo "Validate failed"    
        echo ""
      fi

      echo ""
      echo "Listing folder"
      ls -la && ls -la $packerhclpath/
      echo ""     

      echo "Upload packer_manifest.json file from S3"
      aws s3 cp $packerhclpath/packer_manifest.json  s3://packer-manifest/packer-manifest/packer_manifest.json

      echo "Retrieve AMI_ID packer_manifest.json"
      AMI_ID=$(cd $packerhclpath && jq -r '.builds[-1].artifact_id' packer_manifest.json | cut -d ":" -f2)
      echo $AMI_ID
      echo ""

      echo "Change AMI variable to Deploy"
      sed -i '/packer_ami_id/s/.*/packer_ami_id="'$AMI_ID'"/' $terradeploypath/terraform.tfvars
      echo ""
      
      echo "terraform init => packer deploy infrastructure"
      cd $terradeploypath && terraform init      
      echo ""

      echo "terraform apply => packer deploy infrastructure"
      cd $terradeploypath && terraform apply --auto-approve

      if [ $? -eq 0 ]; then
        echo ""
        echo "##################################"
        echo "Deploy Infrastructure. Suceeded..."
        echo "##################################"
        echo ""
      else
        echo ""
        echo "###################################################"
        echo "Deploy Infrastructure. Failed. Something went wrong..."
        echo "###################################################"
        echo ""
     fi
    
  ;;
  destroy)

      echo "Retrieve packer-manifest.json file from S3"
      aws s3 cp s3://packer-manifest/packer-manifest/packer_manifest.json $packerhclpath/
    
      echo "Retrieve AMI_ID packer_manifest.json"
      AMI_ID=$(jq -r '.builds[-1].artifact_id' $packerhclpath/packer_manifest.json | cut -d ":" -f2)
      echo $AMI_ID
      
      echo "Remove Snap and AMI"
      ./delete-ami.sh $AMI_ID
      echo "" 

      echo "terraform reconfigure => packer network infrastructure"
      cd $terranetworkpath && terraform init -reconfigure
      echo ""

      echo "terraform destroy => packer network infrastructure"
      cd $terranetworkpath && terraform destroy --auto-approve
      echo ""

      echo "terraform reconfigure => packer deploy infrastructure"
      cd $terradeploypath && terraform init -reconfigure

      echo "terraform destroy => packer deploy infrastructure"
      cd $terradeploypath && terraform destroy --auto-approve

      if [ $? -eq 0 ]; then
        echo ""
        echo "##########################################"
        echo "All Infrastructure Destroyed. Suceeded..."
        echo "##########################################"
      else
        echo ""
        echo "#############################################################"
        echo "All Infrastructure Destroyed. Failed. Something went wrong..."
        echo "#############################################################"
        echo ""
     fi
  ;;
  *)
     printf "packer-terraform.sh (all|destroy)"
     echo
  ;;
esac
exit 0


![Libra Logo](/../screenshots/screens/libra.png?raw=true "Libra Logo")
# AWS-Libra-Blockchain
Helps you get started working with Libra Blockchain on AWS. You can connect to the Libra Testnet, create your own local Testnet and execute Move contracts by following tutorials starting [Over Here](https://developers.libra.org/docs/my-first-transaction).

This walkthrough will take your through using Amazon [Cloud9](https://aws.amazon.com/cloud9/details/) browser-based Cloud Integrated Development Environment (IDE) which will be built on top of Ubuntu 18.04 (you can additionally choose Amazon Linux 2 if you are familiar with `yum`)

## Creating Cloud9 IDE
1. Log into the AWS Management Console, Scroll down to **Developer Tools** and select Cloud9
![IDE Step 1](/../screenshots/screens/Step1.JPG?raw=true "IDE Step 1")

2. Choose **Create Environment** on the top right-hand side
![IDE Step 2](/../screenshots/screens/Step2.JPG?raw=true "IDE Step 2")

3. Give your Cloud9 IDE an Name and Description, and click **Next Step**
![IDE Step 3](/../screenshots/screens/Step3.JPG?raw=true "IDE Step 3")

4. 
- A: Choose **Create a new instance for environment (EC2)**, under **Instance Type** select whatever you think is appropiate (*t2.small* should be fine), select Ubuntu Server 18.04LTS and leave the **Cost-saving setting** default
![IDE Step 4A](/../screenshots/screens/Step4A.JPG?raw=true "IDE Step 4A")

- B: Cloud9 will create an AWS managed IAM Service Role, specify what VPC and Subnet you will like to launch your IDE in, ensure the subnets auto-assign a Public IP Address, you can read [more about VPCs here](https://docs.aws.amazon.com/vpc/latest/userguide/getting-started-ipv4.html) and then click **Next Step**
![IDE Step 4B](/../screenshots/screens/Step4B.JPG?raw=true "IDE Step 4B")

5. Review Selections and select **Create environment** at the bottom right

6. Wait a momemnt for the IDE to creat and start, clear out cluttered Tabs and create a shell script to resize the Cloud9 IDE Volume `nano resize.sh` (you could also clone this repo as it is saved within the Master branch)
```shell
#!/bin/bash

# Specify the desired volume size in GiB as a command-line argument. If not specified, default to 20 GiB.
SIZE=${1:=20}

# Install the jq command-line JSON processor.
sudo apt install -y jq

# Get the ID of the envrionment host Amazon EC2 instance.
INSTANCEID=$(curl http://169.254.169.254/latest/meta-data//instance-id)

# Get the ID of the Amazon EBS volume associated with the instance.
VOLUMEID=$(aws ec2 describe-instances --instance-id $INSTANCEID | jq -r .Reservations[0].Instances[0].BlockDeviceMappings[0].Ebs.VolumeId)

# Resize the EBS volume.
aws ec2 modify-volume --volume-id $VOLUMEID --size $SIZE

# Wait for the resize to finish.
while [ "$(aws ec2 describe-volumes-modifications --volume-id $VOLUMEID --filters Name=modification-state,Values="optimizing","completed" | jq '.VolumesModifications | length')" != "1" ]; do
  sleep 1
done

# Rewrite the partition table so that the partition takes up all the space that it can.
sudo growpart /dev/xvda 1

# Expand the size of the file system.
sudo resize2fs /dev/xvda1

##lsblk
```

7. Save the Script `Crtl+X` and `Y` then run it with a value `sh resize.sh 30` - if you do not specify it will default to `20 GiB`

8. Ensure your changes worked `lsblk`
![IDE Step 8](/../screenshots/screens/Step8.JPG?raw=true "IDE Step 8")

## Preparing Libra Blockchain Network Dependencies for Ubuntu
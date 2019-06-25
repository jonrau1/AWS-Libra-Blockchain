# My First Transaction (on Cloud9)

This walkthrough will take your through using Amazon [Cloud9](https://aws.amazon.com/cloud9/details/) browser-based Cloud Integrated Development Environment (IDE) which will be built on top of Ubuntu 18.04 (you can additionally choose Amazon Linux 2 if you are familiar with `yum`). This Project assumes you have minimal familiarity of AWS, of Linux (let alone Debian-based flavors) and zero knowledge of Libra Blockchain, therefore, some steps may seem redundant or superfulous - but I am attempting to cater to a wider audience versus my other projects.

## Creating the Cloud9 IDE
1. Log into the AWS Management Console, Scroll down to **Developer Tools** and select Cloud9
![IDE Step 1](/../screenshots/screens/Step1.JPG?raw=true "IDE Step 1")

2. Choose **Create Environment** on the top right-hand side
![IDE Step 2](/../screenshots/screens/Step2.JPG?raw=true "IDE Step 2")

3. Give your Cloud9 IDE an Name and Description, and click **Next Step**
![IDE Step 3](/../screenshots/screens/Step3.JPG?raw=true "IDE Step 3")

4. (**A**): Choose **Create a new instance for environment (EC2)**, under **Instance Type** select whatever you think is appropiate (*t2.small* should be fine), select Ubuntu Server 18.04LTS and leave the **Cost-saving setting** default
![IDE Step 4A](/../screenshots/screens/Step4A.JPG?raw=true "IDE Step 4A")

4. (**B**): Cloud9 will create an AWS managed IAM Service Role, specify what VPC and Subnet you will like to launch your IDE in, ensure the subnets auto-assign a Public IP Address, you can read [more about VPCs here](https://docs.aws.amazon.com/vpc/latest/userguide/getting-started-ipv4.html) and then click **Next Step**
![IDE Step 4B](/../screenshots/screens/Step4B.JPG?raw=true "IDE Step 4B")

5. Review Selections and select **Create environment** at the bottom right

6. Wait a momemnt for the IDE to create and start, clear out cluttered Tabs and create a shell script to resize the Cloud9 IDE Volume `nano resize.sh` (you could also clone this repo as it is saved within the Master branch)
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
```

7. Save the Script `Crtl+X` and `Y` then run it with a value `sh resize.sh 30` - if you do not specify it will default to `20 GiB`

8. Ensure your changes worked `lsblk`
![IDE Step 8](/../screenshots/screens/Step8.JPG?raw=true "IDE Step 8")

## Preparing Libra Blockchain Network Dependencies for Ubuntu
9. Create a Shell script to install dependencies for Libra `nano dependencies.sh` (you could also clone this repo as it is saved within the Master branch)
```shell
#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y git
sudo apt install -y unzip
sudo apt install -y cmake
sudo apt install -y zlib1g-dev
git clone https://github.com/libra/libra.git
cd libra
./scripts/dev_setup.sh
```

10. To connect to the Testnet, change directories `cd libra` and run `./scripts/cli/start_cli_testnet.sh` which will take a few minutes, you should see `libra%` when done to denote you are within the Libra CLI
![IDE Step 10](/../screenshots/screens/Step10.JPG?raw=true "IDE Step 10")

## Basic Transactions on Libra Blockchain - Public Testnet
11. Create your 1st Account `account create`, you can create an additional account by repeating the command
![IDE Step 11](/../screenshots/screens/Step11.JPG?raw=true "IDE Step 11")

12. List out your Accounts - note from now on we will refer to the Index Number verus the Account Number `account list`
![IDE Step 12](/../screenshots/screens/Step12.JPG?raw=true "IDE Step 12")

13. Add coins to your Accounts by **Minting** them on the Testnet Faucet, this will generate a number of Libra Coins to add to your accounts and they have no real world value `account mint 0 999` and `account mint 1 111`
![IDE Step 13](/../screenshots/screens/Step13.JPG?raw=true "IDE Step 13")

14. From the previous step, note that the statement returned is `Mint request submitted` to confirm the Libra Coin was successfully added to the accounts, perform a query operation for the Balance `query balance 0` and `query balance 1`
![IDE Step 14](/../screenshots/screens/Step14.JPG?raw=true "IDE Step 14")

15. To send Libra Coin from one account to another, use a transfer operation `transfer 0 1 99` - this will submit the Transaction to the Validator Nodes, once [Consensus](https://developers.libra.org/docs/crates/consensus) is achieved, the transaction will be recorded to the Ledger
![IDE Step 15](/../screenshots/screens/Step15.JPG?raw=true "IDE Step 15")

16. To confirm the Libra Coin was received, query the balance again on Account Index 1 `query balance 1` you can also query the Transaction via Account and Sequence number by issuing a command such as `txn_acc_seq 0 0 true` where `true` will fetch all related Events
![IDE Step 16](/../screenshots/screens/Step16.JPG?raw=true "IDE Step 16")

17. You can also refer to Account Numbers instead of Index numbers to transfer Libra Coin during a Transfer, and to ensure you only receive a command prompt in return when the Transaction is accepted and published to the Ledger by the Validators, run your Transfer in **Blocking** mode [Read more here](https://developers.libra.org/docs/reference/libra-cli)
`transferb 1 b31c76a6c781bdc1426ad95272cc74eb2f6579bbc5efe7f63c1a4976a760c2fc 10`
![IDE Step 17](/../screenshots/screens/Step17.JPG?raw=true "IDE Step 17")

# Next Steps

You have now demonstrated the ability to configure Cloud9 IDE to interact with the Libra Blockchain and Public Testnet. Feel free to stay here or continue on to [Phase 2](https://github.com/jonrau1/AWS-Libra-Blockchain) to go through creating your own Localized Testnet.
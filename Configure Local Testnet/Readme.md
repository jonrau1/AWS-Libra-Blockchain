# Local Libra Blockchain Network

## Introduction & Housekeeping
This Readme will take you through the steps of building a localized version of the Libra testnet (I will refer to it as a Local Libra Blockchain Network, or a variation of throughout), sharing the necessary files for your remote Clients to connect to it, and executing transactions.

We will be building this on a Single EC2 Instance in the same VPC as your Cloud9 IDE to use RFC1918 Private IP Addresses, and will be permitting traffic using references to Security Groups. You can find out more information on Intra-VPC Routing [Here](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html#RouteTables), and some basic information on Security Groups (essentially, stateful L3/L4 Firewalls) [Here](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html).

We will be using [S3 Buckets](https://aws.amazon.com/s3/) which is an object storage solution, [IAM Users](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) which represent identities of users/entities on AWS and another [EC2 Instance](https://aws.amazon.com/ec2/) which is Cloud-based compute to create our Local Libra Blockchain Network.

In a Production-like Environment, we would do quite a bit more hardening at the OS and Network levels and layer in additional Security controls as well as architect for High Availability, but this will do for some basic testing and familiarization. We would also use stronger Identity-based controls and practices to ensure least privilege and ephemeral access keys, but we will short cut a lot of these security best practices, so go forth at your own risk!!

## Solution Architecture (Really Bad Representation)
![Architecture](/../screenshots/local-net-screens/local-net-architecture.jpg?raw=true "Architecture")

## Infrastructure Setup
In this Stage, we will create our supporting infrastructure - in this case a single S3 Bucket, an IAM User with permission to Access S3 and an EC2 Instance will be created. Configuration of EC2, and creation of the Local Libra Blockchain Network will take place in different Stages.

***If you are familiar with AWS, feel free to skip past these steps and quickly create an IAM user w/ S3 PUT & GET Permissions & Security Credentials, a S3 Bucket and an Ubuntu 18.04LTS EC2 Instance with a 64GiB GP2 EBS volume and skip to the next Stage.***

1. On the Management Console homescreen, scroll down to the Storage section and select **S3**
![Local Net Step 1](/../screenshots/local-net-screens/Step1.JPG?raw=true "Local Net Step 1")

2. On the Top-Left, select **Create Bucket** and give it a simple name `easy-local-libra-bucket` and then Click **Next** (note these are Global DNS values, failures are probably due to duplicate entries)
![Local Net Step 2](/../screenshots/local-net-screens/Step2.JPG?raw=true "Local Net Step 2")

3. Enable **Versioning** and **Default Encryption** with AES-256, feel free to turn on Object-level or Access Logging as well and then Click **Next**
![Local Net Step 3](/../screenshots/local-net-screens/Step3.JPG?raw=true "Local Net Step 3")

4. Block **All** Public Access to your Bucket, and then Click **Next**
![Local Net Step 4](/../screenshots/local-net-screens/Step4.JPG?raw=true "Local Net Step 4")

5. Select **Create Bucket**, and return to the main menu of the Management Console
![Local Net Step 5](/../screenshots/local-net-screens/Step5.JPG?raw=true "Local Net Step 5")

6. In the bottom of the Management Console, under **Security, Identity & Compliance** choose **IAM**
![Local Net Step 6](/../screenshots/local-net-screens/Step6.JPG?raw=true "Local Net Step 6")

7. In the IAM Console, select **Users** from the menu on the left, and click **Add User** on the top left of the Users Console
![Local Net Step 7](/../screenshots/local-net-screens/NewStep7.JPG?raw=true "Local Net Step 7")

8. Give the IAM User a name like `libra-user` and enable **Programmatic Access** and click **Next: Permissions**
![Local Net Step 8](/../screenshots/local-net-screens/NewStep8.JPG?raw=true "Local Net Step 8")

9. In the header Section of the Permissions Screen, select **Attach existing policies directly**, search `s3` in the Search Bar and select the **AmazonS3FullAccess** Policy and select **Next: Tags**
![Local Net Step 9](/../screenshots/local-net-screens/NewStep9.JPG?raw=true "Local Net Step 9")

10. Skip past the Tags Section, select **Next: Review** and on the final screen select **Create user** which will take you to a screen showing you have successfully created your IAM User, on the bottom you will be shown and **Access Key ID** and **Secret Access Key** you can copy these out to a notepad, or save the CSV file - you will need these credentials for later.
![Local Net Step 10](/../screenshots/local-net-screens/Step10.JPG?raw=true "Local Net Step 10")

11. Return to the main menu of the Management Console and select **EC2** under the **Compute** Section
![Local Net Step 11](/../screenshots/local-net-screens/Step11.JPG?raw=true "Local Net Step 11")

12. Select **Launch Instance** when you arrive at the EC2 Console
![Local Net Step 12](/../screenshots/local-net-screens/Step12.JPG?raw=true "Local Net Step 12")

13. Select **Ubuntu Server 18.04 LTS (HVM), SSD Volume Type** to proceed to the next menu
![Local Net Step 13](/../screenshots/local-net-screens/Step13.JPG?raw=true "Local Net Step 13")

14. For testing purposes, scroll down and select the **t3.medium** instance type and size, and select **Next: Configure Instance Details**
![Local Net Step 14](/../screenshots/local-net-screens/Step14.JPG?raw=true "Local Net Step 14")

15. Under **Network** and **Subnet** ensure you select the VPC you placed your Cloud9 IDE into for the first part of this tutorial, you can select a different subnet. Also, ensure you Enable **Auto-assign Pulbic IP** to be able to SSH into your Instance (unless, you're using a Bastion, AppStream 2.0 or Session Manager) and then click **Next: Add Storage**
![Local Net Step 15](/../screenshots/local-net-screens/Step15.JPG?raw=true "Local Net Step 15")

16. In the Storage section, change the size to `64 GiB`, you can additionally encrypt the Root Volume with the default `aws/ebs` KMS key and then click **Next: Add Tags**
![Local Net Step 16](/../screenshots/local-net-screens/Step16.JPG?raw=true "Local Net Step 16")

17. In the Tags section, create a key containing `Name` and under value, give an easy to identify name for the instance and click **Configure Security Group**
![Local Net Step 17](/../screenshots/local-net-screens/Step17.JPG?raw=true "Local Net Step 17")

18. In the Security Group section, select the radio button to **Create a new security group** and give it an easy to reference name such as `Libra-Testnet-SG`. Create a Rule for SSH and select `My IP` (or enter whatever you'd need) and then create a rule for **HTTPS** to allow traffic from everywhere. We will be editing this Security Group later on in this section. After you are finished, click **Review and Launch**.
![Local Net Step 18](/../screenshots/local-net-screens/Step18.JPG?raw=true "Local Net Step 18")

19. Click **Launch** on the bottom-right and you will be given a prompt to choose and existing SSH Key Pair, or to create one. Feel free to use an existing one, if not, enter a name and download the keypair as you will need them later to SSH into your Instance. After you are done, create **Launch Instance** and wait for your Instance to start.
![Local Net Step 19](/../screenshots/local-net-screens/Step19.JPG?raw=true "Local Net Step 19")

20. After you instance is started, SSH into it using Putty or your preferred tool - for more information on SSH via Putty on Windows [Read Here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html?icmpid=docs_ec2_console)

## Local Libra Blockchain Network - Setup

21. After you have SSH'ed into your Instance, create and excute a shell script `nano stage2-dependencies.sh` and `sh stage2-dependencies.sh` (or you can re-clone this Repo and re-use it) to boostrap dependencies, clone and Build Libra Core.
```shell
#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install awscli -y
sudo apt install -y git
sudo apt install -y unzip
sudo apt install -y cmake
sudo apt install -y zlib1g-dev
git clone https://github.com/libra/libra.git
cd libra
./scripts/dev_setup.sh
```

22. Configure your AWS CLI by typing in `aws configure` and copying in your Access Key, Secret Access Key and entering in your Region from the previous Stage - you will need this for later to copy out the necessary files into the S3 Bucket you created.
![Local Net Step 22](/../screenshots/local-net-screens/Step22.JPG?raw=true "Local Net Step 22")

23. Change directories (if the Shell script didn't already) to Libra `cd libra` run Libra Swarm to create your own Local Libra Blockchain Network (go make a coffee, this will take awhile) `cargo run -p libra_swarm -- -s`. After it finishes, you will be see the Libra CLI `libra%` and above you will be given the location of your Faucet keys (to mint coins) and your Config Files that are needed to connect your Remote Clients into your Private Libra Blockchain Network. You can pass additional modifiers such as `-d` to disable logging (and minimize file sizes) or `-n <#>` to specify additional Validators in your Node.
![Local Net Step 23](/../screenshots/local-net-screens/Step23.JPG?raw=true "Local Net Step 23")

24. In a seperate terminal, SSH into the same EC2 Instance and navigate to **Base directory containing logs and configs** `cd /tmp/.tmp<path>`, list out the files in your directory `ls` and find a file that ends in **.node.config.toml** and read it out `nano 8deeeaed65f0<short>.node.config.toml`. Find the **[admission_control]** section and take note of the value for **admission_control_service_port**, you will need that Port Number to connect your Remote Clients.
![Local Net Step 24](/../screenshots/local-net-screens/Step24.JPG?raw=true "Local Net Step 24")

25. From that same directory, copy out **trusted_peers.config.toml** into your S3 Bucket you created earlier `aws s3 cp trusted_peers.config.toml s3://<your_bucket_here>`

26. Navigate to the directory that contains your temporary faucet keys `cd /tmp/keypair.zBE3x2vz9A9B` and copy the faucet keys to your S3 Bucket `aws s3 cp temp_faucet_keys s3://<your_bucket_here>`. After you are finished, navigate to your Cloud9 IDE and boot it back up if needed, and get back to the EC2 Instances screen.

27. Find the EC2 Instance that your Cloud9 IDE is running on top of and select it, in the Instance Description find the Security Group attached to the Instance adn click it to go the Security Groups console.
![Local Net Step 27](/../screenshots/local-net-screens/Step27.JPG?raw=true "Local Net Step 27")

28. Add a TCP rule for the port number you got in Step 24 and for the Source type in `sg-` this will start to prepoulate the list of Security Groups in your VPC, and select the Security Group you created when you created your Instance. **You will do this in the reverse for the other Security Group**, for the sake of simplicity this screenshots shows a rule for All Traffic.
![Local Net Step 28](/../screenshots/local-net-screens/Step28.JPG?raw=true "Local Net Step 28")

29. Open up your Cloud9 IDE and setup your AWS CLI in the same manner as you did in Step 22, (**NOTE** in a Production-setup you would create different Identities, or use Ephemeral Access Keys via STS to facilitate this operation). Navigate to your Libra directory `cd libra` and download the files your uploaded to S3 via the CLI using the `sync` command `aws s3 sync s3://<your_bucket_here> .` (**NOTE** You need to "." as shown).
![Local Net Step 29](/../screenshots/local-net-screens/Step29.JPG?raw=true "Local Net Step 29")

## Local Libra Blockchain Network - Connecting & Basic Transactions

30. From your IDE, issue the following command `cargo run -p client --bin client -- --host <host_IP> --port <PORT> --validator_set_file ./trusted_peers.config.toml --faucet_key_file_path ./temp_faucet_keys` replacing the **--host** value with the Private IP address of your Local Libra Blockchain Network EC2 Instance, and the **--port** value with the Port number you retrieved in Step 24. If successful, you should see the Libra CLI `libra%`.
![Local Net Step 30](/../screenshots/local-net-screens/Step30.JPG?raw=true "Local Net Step 30")

31. Create Accounts and Mint Coins in both your EC2 Instance and Cloud9 Instance `account create` `account mint 0 <value>`. Take Note of your Addresses, as this is what you will use to Transfer Libra, versus the Index Number in the previous walkthrough.

32. Transfer Coins from one of your accounts to the other, you will begin with your own Account's Index Number and enter in your target Account's Address Number. For example, `transferb 0 750dab1fc2cc88dc66312188d1988c1c4c0f7f22f72ab6ea76f9ace95a223add 15` (Note, you do not need to use Blocking mode) and on the Receiver's end: `query balance 0`. Feel free to transfer back and forth between different Accounts to get a feel of this.
![Local Net Step 32](/../screenshots/local-net-screens/Step32.JPG?raw=true "Local Net Step 32")

32. You can also Query Transaction by Account and Sequence numbers to get a full list of Events as the Transaction was written to the Libra Blockchain's Ledger, this example will be given to you as an output in the CLI after every submitted transaction, specifying **true** will give you the Events: `query txn_acc_seq 0 0 true`.
```
libra% query txn_acc_seq 0 0 true
>> Getting committed transaction by account and sequence number
Committed transaction: SignedTransaction {
 raw_txn: RawTransaction {
        sender: 1c985958fae85a21d428d6cf9d260846b57e0d93d1c7483eccc5a94e746649d3,
        sequence_number: 0,
        payload: {,
                transaction: peer_to_peer_transaction,
                args: [
                        {ADDRESS: 750dab1fc2cc88dc66312188d1988c1c4c0f7f22f72ab6ea76f9ace95a223add},
                        {U64: 15000000},
                ]
        },
        max_gas_amount: 10000,
        gas_unit_price: 0,
        expiration_time: 1561487614s,
},
 public_key: 041ab868bee41d627cd842ab368bf974616314451ac62ac66205e73625444e6a,
 signature: Signature( R: CompressedEdwardsY: [14, 21, 164, 210, 17, 104, 53, 90, 132, 224, 246, 68, 79, 177, 118, 190, 195, 99, 252, 240, 178, 251, 54, 137, 141, 234, 182, 10, 140, 4, 46, 144], s: Scalar{
        bytes: [110, 155, 189, 246, 47, 15, 20, 146, 26, 246, 117, 42, 98, 228, 114, 16, 64, 145, 103, 232, 208, 106, 229, 91, 28, 82, 124, 36, 165, 148, 136, 12],
} ),
 }
Events:
ContractEvent { access_path: AccessPath { address: 1c985958fae85a21d428d6cf9d260846b57e0d93d1c7483eccc5a94e746649d3, type: Resource, hash: "217da6c6b3e19f1825cfb2676daecce3bf3de03cf26647c78df00b371b25cc97", suffix: "/sent_events_count/" } , index: 0, event_data: AccountEvent { account: 750dab1fc2cc88dc66312188d1988c1c4c0f7f22f72ab6ea76f9ace95a223add, amount: 15000000 } }
ContractEvent { access_path: AccessPath { address: 750dab1fc2cc88dc66312188d1988c1c4c0f7f22f72ab6ea76f9ace95a223add, type: Resource, hash: "217da6c6b3e19f1825cfb2676daecce3bf3de03cf26647c78df00b371b25cc97", suffix: "/received_events_count/" } , index: 0, event_data: AccountEvent { account: 1c985958fae85a21d428d6cf9d260846b57e0d93d1c7483eccc5a94e746649d3, amount: 15000000 } }
libra%
```

## Outro

This is the end of this phase of the tutorial, you can easily (re)connect Remote Clients to your main Local Libra Blockchain Network to scale out and stress test the single node. Feel free to modify different flags in `libra swarm` to create additional Validators, or use different instance sizes.

Note that restarting the main Local Libra Blockchain Network will cause a totally new Blockchain to instaniate, to include accounts, balance, storage, etc. That will follow on in later sections of this Project
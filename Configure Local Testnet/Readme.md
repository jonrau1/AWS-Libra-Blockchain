# Local Libra Blockchain Network

## Introduction & Housekeeping
This Readme will take you through the steps of building a localized version of the Libra testnet (I will refer to it as a Local Libra Blockchain Network, or a variation of throughout), sharing the necessary files for your remote Clients to connect to it, and executing transactions.

We will be building this on a Single EC2 Instance in the same VPC as your Cloud9 IDE to use RFC1918 Private IP Addresses, and will be permitting traffic using references to Security Groups. You can find out more information on Intra-VPC Routing [Here](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html#RouteTables), and some basic information on Security Groups (essentially, stateful L3/L4 Firewalls) [Here](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html).

We will be using [S3 Buckets](https://aws.amazon.com/s3/) which is an object storage solution, [IAM Users](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) which represent identities of users/entities on AWS and another [EC2 Instance](https://aws.amazon.com/ec2/) which is Cloud-based compute to create our Local Libra Blockchain Network.

In a Production-like Environment, we would do quite a bit more hardening at the OS and Network levels and layer in additional Security controls as well as architect for High Availability, but this will do for some basic testing and familiarization. We would also use stronger Identity-based controls and practices to ensure least privilege and ephemeral access keys, but we will short cut a lot of these security best practices, so go forth at your own risk!!

## Solutions Architecture (Really Bad Representation)
![Architecture](/../screenshots/local-net-screens/local-net-architecture.jpg?raw=true "Architecture")

## Infrastructure Setup
In this Stage, we will create our supporting infrastructure - in this case a single S3 Bucket, an IAM User with permission to Access S3 and an EC2 Instance will be created. Configuration of EC2, and creation of the Local Libra Blockchain Network will take place in different Stages

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
![Local Net Step 7](/../screenshots/local-net-screens/Step7.JPG?raw=true "Local Net Step 7")

8. 